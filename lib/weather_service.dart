import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Weather data model matching the home-page weather widget:
/// location, temperature, condition (text + icon), humidity and wind speed.
class WeatherData {
  const WeatherData({
    required this.city,
    this.region = '',
    required this.tempC,
    required this.conditionText,
    required this.conditionCode,
    required this.humidity,
    required this.windKph,
  });

  factory WeatherData.fromJson(
    Map<String, dynamic> json, {
    String? city,
    String? region,
  }) {
    final current = json['current'] as Map<String, dynamic>? ?? const {};
    final code = (current['weather_code'] as num?)?.toInt() ?? 0;
    return WeatherData(
      city: city ?? 'Unknown',
      region: region ?? '',
      tempC: ((current['temperature_2m'] as num?) ?? 0).round(),
      conditionText: WeatherService.conditionText(code),
      conditionCode: code,
      humidity: ((current['relative_humidity_2m'] as num?) ?? 0).round(),
      windKph: ((current['wind_speed_10m'] as num?) ?? 0).round(),
    );
  }

  final String city;
  final String region;
  final int tempC;
  final String conditionText;
  final int conditionCode;
  final int humidity;
  final int windKph;
}

/// Fetches live weather for the device's current coordinates from
/// Open-Meteo (https://open-meteo.com), a free service that needs no API key.
class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// OpenStreetMap Nominatim reverse geocoder (free, no key, CORS-open).
  static const String _reverseGeocodeUrl =
      'https://nominatim.openstreetmap.org/reverse';

  /// Cap on the label lookup so a slow OSM never delays the weather card.
  static const Duration geocodeTimeout = Duration(seconds: 4);

  static final RegExp _metropolitanAreaPattern = RegExp(
    r'^(.+?) Metropolitan Area$',
  );

  final http.Client _client;

  Future<WeatherData> fetchWeather(double lat, double lon) async {
    // Started first (and concurrently): OSM resolves the administrative city
    // while Open-Meteo is fetched. The request is issued before the weather
    // call so the weather response stays the primary payload.
    final locationFuture = _resolveLocation(lat, lon);
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code',
        'wind_speed_unit': 'kmh',
        'timezone': 'auto',
      },
    );
    final http.Response response;
    try {
      response = await _client.get(uri);
    } on http.ClientException {
      // On mobile http wraps socket failures in a ClientException, and on
      // web a failed lookup surfaces as one too — both mean "offline".
      throw const WeatherApiException(
        'No internet connection. Check your connection and try again.',
      );
    } on TimeoutException {
      throw const WeatherApiException(
        'The weather request timed out. Check your connection and try again.',
      );
    }
    if (response.statusCode != 200) {
      throw WeatherApiException(
        'Weather service error (${response.statusCode}). Please try again.',
      );
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final location = await locationFuture;
    return WeatherData.fromJson(
      json,
      city: location?.city,
      region: location?.region,
    );
  }

  /// Best-effort city/region label from OpenStreetMap Nominatim (no API key
  /// needed).
  ///
  /// Open-Meteo only reports coordinates, while Nominatim knows the
  /// administrative city ("Kolkata Metropolitan Area" → "Kolkata") and the
  /// containing state. Any failure — offline, timeout, bad payload — leaves
  /// the label unset, so weather is never delayed past [geocodeTimeout] or
  /// failed by this call.
  Future<_GeoLabel?> _resolveLocation(double lat, double lon) async {
    try {
      final uri = Uri.parse(_reverseGeocodeUrl).replace(
        queryParameters: {
          'format': 'jsonv2',
          'lat': lat.toString(),
          'lon': lon.toString(),
          'zoom': '10',
          'addressdetails': '1',
        },
      );
      final response = await _client.get(uri).timeout(geocodeTimeout);
      if (response.statusCode != 200) return null;
      return _labelFromNominatim(response.body);
    } catch (_) {
      return null;
    }
  }

  /// Reads the city/region label out of a Nominatim reverse-geocode payload.
  ///
  /// Prefers a `... Metropolitan Area` municipality (which covers New Town,
  /// Salt Lake and Kolkata proper alike), then the plain `city`/`town`/
  /// `village`/`suburb` fields. The region is the containing `state`.
  static _GeoLabel? _labelFromNominatim(String body) {
    try {
      final Object? decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return null;
      final address = decoded['address'];
      if (address is! Map<String, dynamic>) return null;
      final region = (address['state'] as String?)?.trim() ?? '';
      String? city;
      final municipality = address['municipality'];
      if (municipality is String) {
        final match = _metropolitanAreaPattern.firstMatch(municipality.trim());
        if (match != null) city = match.group(1);
      }
      if (city == null) {
        for (final key in const ['city', 'town', 'village', 'suburb']) {
          final value = address[key];
          if (value is String && value.trim().isNotEmpty) {
            city = value.trim();
            break;
          }
        }
      }
      if (city == null && region.isEmpty) return null;
      return _GeoLabel(city ?? region, region);
    } on FormatException {
      return null;
    }
  }

  /// Maps a WMO weather code (used by Open-Meteo) to a short label.
  static String conditionText(int code) {
    if (code == 0) return 'Clear sky';
    if (code == 1) return 'Mainly clear';
    if (code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code == 95) return 'Thunderstorm';
    if (code == 96 || code == 99) return 'Thunderstorm with hail';
    return 'Unknown';
  }

  /// Maps a WMO weather code (used by Open-Meteo) to a local Material icon.
  static IconData weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code == 1 || code == 2) return Icons.wb_cloudy_rounded;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.blur_on_rounded;
    if (code == 51 || code == 53 || code == 55) {
      return Icons.water_drop_rounded;
    }
    if (code == 56 || code == 57 || code == 66 || code == 67) {
      return Icons.grain_rounded;
    }
    if ((code >= 61 && code <= 65) || (code >= 80 && code <= 82)) {
      return Icons.water_drop_rounded;
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit_rounded;
    }
    if (code == 95 || code == 96 || code == 99) {
      return Icons.flash_on_rounded;
    }
    return Icons.wb_cloudy_rounded;
  }
}

/// Resolved place label: the administrative city and its containing region.
class _GeoLabel {
  const _GeoLabel(this.city, this.region);

  final String city;
  final String region;
}

class WeatherApiException implements Exception {
  const WeatherApiException(this.message);

  final String message;

  @override
  String toString() => 'WeatherApiException: $message';
}
