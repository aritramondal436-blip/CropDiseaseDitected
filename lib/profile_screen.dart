import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';
import 'login_screen.dart';
import 'profile_info_page.dart';
import 'user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _service = const ProfileService();

  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await _service.load();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _persist(UserProfile updated) async {
    setState(() => _profile = updated);
    await _service.save(updated);
  }

  Future<void> _editProfile() async {
    final current = _profile;
    if (current == null) return;
    final updated = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditProfileSheet(profile: current),
    );
    if (updated == null || !mounted) return;
    await _persist(updated);
    if (!mounted) return;
    _showMessage('Profile updated successfully');
  }

  Future<void> _updatePreference(UserProfile updated) async {
    await _persist(updated);
  }

  void _openInfo(String title, IconData icon, String message) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ProfileInfoPage(title: title, icon: icon, message: message),
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: AppColors.agroWhite,
        title: Text(
          'Log out?',
          style: AppTextStyles.title.copyWith(
            color: AppColors.agroDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'You will need to sign in again to access your crop reports.',
          style: AppTextStyles.cardBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTextStyles.label.copyWith(
                color: AppColors.agroText.withValues(alpha: 0.75),
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.alertRed,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.button.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.agroPrimary),
      );
    }

    final profile = _profile!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileHeader(
                profile: profile,
                onEdit: _editProfile,
                onChangePhoto: () => _showMessage('Photo upload coming soon'),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Personal Information',
                icon: Icons.badge_outlined,
                children: [
                  _DetailRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Full Name',
                    value: profile.fullName,
                  ),
                  _DetailRow(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email Address',
                    value: profile.email,
                  ),
                  _DetailRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: profile.phone,
                  ),
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: profile.location,
                  ),
                  const Divider(height: 20, color: AppColors.divider),
                  _ProfilePictureRow(
                    initials: profile.initials,
                    onChangePhoto: () =>
                        _showMessage('Photo upload coming soon'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Account Information',
                icon: Icons.verified_user_outlined,
                children: [
                  _DetailRow(
                    icon: Icons.fingerprint_rounded,
                    label: 'User ID',
                    value: profile.userId,
                  ),
                  _DetailRow(
                    icon: Icons.agriculture_outlined,
                    label: 'Account Type',
                    value: profile.accountType.label,
                  ),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Registration Date',
                    value: profile.formattedRegistrationDate,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'App Preferences',
                icon: Icons.tune_rounded,
                children: [
                  _PreferenceDropdown(
                    icon: Icons.translate_rounded,
                    label: 'Preferred Language',
                    value: profile.preferredLanguage,
                    onChanged: (language) {
                      _updatePreference(
                        profile.copyWith(preferredLanguage: language),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _PreferenceSwitch(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notification Settings',
                    subtitle: 'Alerts about crop health and reports',
                    value: profile.notificationsEnabled,
                    onChanged: (enabled) {
                      _updatePreference(
                        profile.copyWith(notificationsEnabled: enabled),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _PreferenceSwitch(
                    icon: Icons.my_location_rounded,
                    label: 'Location Access',
                    subtitle: 'Local weather and disease alerts',
                    value: profile.locationAccessEnabled,
                    onChanged: (enabled) {
                      _updatePreference(
                        profile.copyWith(locationAccessEnabled: enabled),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Other Options',
                icon: Icons.apps_rounded,
                children: [
                  _OptionTile(
                    icon: Icons.description_outlined,
                    label: 'My Reports',
                    onTap: () => _openInfo(
                      'My Reports',
                      Icons.description_outlined,
                      'Your crop scan reports will appear here once scanning '
                          'is enabled.',
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 54,
                    color: AppColors.divider,
                  ),
                  _OptionTile(
                    icon: Icons.bookmark_outline_rounded,
                    label: 'Saved Plants',
                    onTap: () => _openInfo(
                      'Saved Plants',
                      Icons.bookmark_outline_rounded,
                      'Plants you save will be listed here.',
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 54,
                    color: AppColors.divider,
                  ),
                  _OptionTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () => _openInfo(
                      'Help & Support',
                      Icons.help_outline_rounded,
                      'FAQs and support contact options are on the way.',
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 54,
                    color: AppColors.divider,
                  ),
                  _OptionTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () => _openInfo(
                      'Privacy Policy',
                      Icons.privacy_tip_outlined,
                      'Our privacy policy will be available here soon.',
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 54,
                    color: AppColors.divider,
                  ),
                  _OptionTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    isDestructive: true,
                    onTap: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.onEdit,
    required this.onChangePhoto,
  });

  final UserProfile profile;
  final VoidCallback onEdit;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.agroDark, AppColors.agroPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.agroDark.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -34,
            top: -44,
            child: Icon(
              Icons.eco_rounded,
              size: 160,
              color: AppColors.agroWhite.withValues(alpha: 0.07),
            ),
          ),
          Row(
            children: [
              _ProfileAvatar(
                initials: profile.initials,
                size: 78,
                onTap: onChangePhoto,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleWhite.copyWith(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionWhite.copyWith(
                        color: AppColors.agroWhite.withValues(alpha: 0.82),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: _ActivePill(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _EditChip(onTap: onEdit),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.initials,
    required this.size,
    this.onTap,
  });

  final String initials;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.agroFresh, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.agroWhite, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.agroDark.withValues(alpha: 0.32),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: AppTextStyles.titleWhite.copyWith(
                  fontSize: size * 0.34,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.36,
              height: size * 0.36,
              decoration: BoxDecoration(
                color: AppColors.agroWhite,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.agroPale, width: 1.5),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: size * 0.18,
                color: AppColors.agroDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivePill extends StatelessWidget {
  const _ActivePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.agroWhite.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.agroWhite.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF7CF29A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Active User',
            style: AppTextStyles.captionWhite.copyWith(
              color: AppColors.agroWhite,
              fontWeight: FontWeight.w600,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditChip extends StatelessWidget {
  const _EditChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.agroWhite.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.edit_outlined,
                color: AppColors.agroWhite,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                'Edit',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.agroWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.agroDark.withValues(alpha: 0.06)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.agroPale,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: AppColors.agroPrimary, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.agroDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.agroPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.agroText.withValues(alpha: 0.6),
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.agroText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePictureRow extends StatelessWidget {
  const _ProfilePictureRow({
    required this.initials,
    required this.onChangePhoto,
  });

  final String initials;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ProfileAvatar(initials: initials, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Picture',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.agroText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                'Generated initials avatar',
                style: AppTextStyles.caption.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onChangePhoto,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.agroPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 36),
          ),
          child: Text(
            'Change',
            style: AppTextStyles.label.copyWith(
              color: AppColors.agroPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferenceDropdown extends StatelessWidget {
  const _PreferenceDropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  static const List<String> _languages = ['English', 'Hindi', 'Bengali'];

  final IconData icon;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.agroPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.agroText,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              borderRadius: BorderRadius.circular(14),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.agroPrimary,
              ),
              style: AppTextStyles.body.copyWith(
                color: AppColors.agroDark,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
              items: [
                for (final language in _languages)
                  DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  ),
              ],
              onChanged: (selected) {
                if (selected != null) onChanged(selected);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  const _PreferenceSwitch({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.agroPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.agroText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.agroWhite,
            activeTrackColor: AppColors.agroPrimary,
            trackOutlineColor: WidgetStateProperty.all(
              AppColors.agroPrimary.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.alertRed : AppColors.agroText;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.alertRed.withValues(alpha: 0.10)
                      : AppColors.agroPale,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isDestructive
                      ? AppColors.alertRed
                      : AppColors.agroPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Icon(
                isDestructive
                    ? Icons.arrow_forward_rounded
                    : Icons.chevron_right_rounded,
                size: 20,
                color: isDestructive ? AppColors.alertRed : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.profile});

  final UserProfile profile;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.profile.fullName,
  );
  late final TextEditingController _emailController = TextEditingController(
    text: widget.profile.email,
  );
  late final TextEditingController _phoneController = TextEditingController(
    text: widget.profile.phone,
  );
  late final TextEditingController _locationController = TextEditingController(
    text: widget.profile.location,
  );
  late AccountType _accountType = widget.profile.accountType;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      widget.profile.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        accountType: _accountType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        decoration: const BoxDecoration(
          color: AppColors.agroWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.agroDark.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Profile',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.agroDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.agroText,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _EditField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _EditField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!_emailPattern.hasMatch(email)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _EditField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _EditField(
                  controller: _locationController,
                  label: 'Location',
                  icon: Icons.location_on_outlined,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AccountType>(
                  initialValue: _accountType,
                  borderRadius: BorderRadius.circular(14),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.agroPrimary,
                  ),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.agroText,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  decoration: _fieldDecoration(
                    label: 'Account Type',
                    icon: Icons.agriculture_outlined,
                  ),
                  items: [
                    for (final type in AccountType.values)
                      DropdownMenuItem<AccountType>(
                        value: type,
                        child: Text(type.label),
                      ),
                  ],
                  onChanged: (type) {
                    if (type != null) setState(() => _accountType = type);
                  },
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.agroDark,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                            color: AppColors.agroDark.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.agroDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.agroPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: AppColors.agroDark,
      style: AppTextStyles.body.copyWith(
        color: AppColors.agroText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      decoration: _fieldDecoration(label: label, icon: icon),
    );
  }
}

InputDecoration _fieldDecoration({
  required String label,
  required IconData icon,
}) {
  final radius = BorderRadius.circular(14);
  final base = OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(
      color: AppColors.agroPrimary.withValues(alpha: 0.18),
    ),
  );
  return InputDecoration(
    hintText: label,
    hintStyle: AppTextStyles.body.copyWith(
      color: AppColors.agroText.withValues(alpha: 0.52),
    ),
    filled: true,
    fillColor: AppColors.agroPale.withValues(alpha: 0.62),
    prefixIcon: Icon(icon, color: AppColors.agroPrimary, size: 20),
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
    errorStyle: AppTextStyles.caption.copyWith(color: AppColors.alertRed),
    border: base,
    enabledBorder: base,
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.agroPrimary, width: 1.6),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.alertRed, width: 1.4),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.alertRed, width: 1.4),
    ),
  );
}
