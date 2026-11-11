import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

enum AccountType {
  farmer('Farmer'),
  generalUser('General User'),
  nurseryWorker('Nursery Worker');

  const AccountType(this.label);

  final String label;

  static AccountType fromStorage(String? value) {
    return values.firstWhere(
      (type) => type.name == value,
      orElse: () => AccountType.farmer,
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.userId,
    required this.accountType,
    required this.registrationDate,
    required this.preferredLanguage,
    required this.notificationsEnabled,
    required this.locationAccessEnabled,
  });

  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String userId;
  final AccountType accountType;
  final DateTime registrationDate;
  final String preferredLanguage;
  final bool notificationsEnabled;
  final bool locationAccessEnabled;

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'AV';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }

  String get formattedRegistrationDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = registrationDate.day.toString().padLeft(2, '0');
    final month = months[registrationDate.month - 1];
    return '$day $month ${registrationDate.year}';
  }

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? userId,
    AccountType? accountType,
    DateTime? registrationDate,
    String? preferredLanguage,
    bool? notificationsEnabled,
    bool? locationAccessEnabled,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      accountType: accountType ?? this.accountType,
      registrationDate: registrationDate ?? this.registrationDate,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationAccessEnabled:
          locationAccessEnabled ?? this.locationAccessEnabled,
    );
  }
}

class ProfileService {
  const ProfileService();

  static const String _prefix = 'agrovision.profile.';
  static const String _fullNameKey = '${_prefix}full_name';
  static const String _emailKey = '${_prefix}email';
  static const String _phoneKey = '${_prefix}phone';
  static const String _locationKey = '${_prefix}location';
  static const String _userIdKey = '${_prefix}user_id';
  static const String _accountTypeKey = '${_prefix}account_type';
  static const String _registrationDateKey = '${_prefix}registration_date';
  static const String _languageKey = '${_prefix}language';
  static const String _notificationsKey = '${_prefix}notifications';
  static const String _locationAccessKey = '${_prefix}location_access';

  Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString(_fullNameKey);
    if (savedName != null && savedName.trim().isNotEmpty) {
      return _read(prefs);
    }

    final remembered = await const AuthService().loadRememberedLogin();
    final now = DateTime.now();
    final profile = UserProfile(
      fullName: 'User Name',
      email: remembered?.email ?? 'user@gmail.com',
      phone: '+91 98765 43210',
      location: 'Kolkata, West Bengal',
      userId: 'AV-${10294 + now.millisecondsSinceEpoch % 1000}',
      accountType: AccountType.farmer,
      registrationDate: now,
      preferredLanguage: 'English',
      notificationsEnabled: true,
      locationAccessEnabled: true,
    );
    await save(profile);
    return profile;
  }

  Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, profile.fullName);
    await prefs.setString(_emailKey, profile.email);
    await prefs.setString(_phoneKey, profile.phone);
    await prefs.setString(_locationKey, profile.location);
    await prefs.setString(_userIdKey, profile.userId);
    await prefs.setString(_accountTypeKey, profile.accountType.name);
    await prefs.setString(
      _registrationDateKey,
      profile.registrationDate.toIso8601String(),
    );
    await prefs.setString(_languageKey, profile.preferredLanguage);
    await prefs.setBool(_notificationsKey, profile.notificationsEnabled);
    await prefs.setBool(_locationAccessKey, profile.locationAccessEnabled);
  }

  UserProfile _read(SharedPreferences prefs) {
    final userId = prefs.getString(_userIdKey);
    final registration = DateTime.tryParse(
      prefs.getString(_registrationDateKey) ?? '',
    );
    return UserProfile(
      fullName: prefs.getString(_fullNameKey) ?? 'User Name',
      email: prefs.getString(_emailKey) ?? 'user@gmail.com',
      phone: prefs.getString(_phoneKey) ?? '+91 98765 43210',
      location: prefs.getString(_locationKey) ?? 'Kolkata, West Bengal',
      userId: userId == null || userId.isEmpty ? 'AV-10294' : userId,
      accountType: AccountType.fromStorage(prefs.getString(_accountTypeKey)),
      registrationDate: registration ?? DateTime.now(),
      preferredLanguage: prefs.getString(_languageKey) ?? 'English',
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      locationAccessEnabled: prefs.getBool(_locationAccessKey) ?? true,
    );
  }
}
