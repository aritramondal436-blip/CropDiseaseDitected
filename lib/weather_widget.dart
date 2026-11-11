import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'app_text_styles.dart';
import 'weather_service.dart';

/// Compact weather + detection panel rendered on the right of the hero
/// section. Shows the current location, temperature, condition, humidity,
/// wind speed and the active AI detection status. Fetches live weather for
/// the device's current position via Open-Meteo.
class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key, this.service});

  final WeatherService? service;

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

enum _WeatherStatus { locating, fetching, loaded, error }

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService _service = WeatherService();

  _WeatherStatus _status = _WeatherStatus.locating;
  WeatherData? _data;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _status = _WeatherStatus.locating;
      _data = null;
    });
    try {
      final position = await _currentPosition();
      if (!mounted) return;
      setState(() => _status = _WeatherStatus.fetching);
      final data = await (widget.service ?? _service).fetchWeather(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;
      debugPrint(
        'WeatherCard: loaded ${data.city}${data.region.isEmpty ? '' : ', ${data.region}'}, '
        '${data.tempC}C for '
        '${position.latitude.toStringAsFixed(3)},'
        '${position.longitude.toStringAsFixed(3)}',
      );
      setState(() {
        _data = data;
        _status = _WeatherStatus.loaded;
      });
    } catch (e) {
      if (!mounted) return;
      final message = e is WeatherApiException ? e.message : e.toString();
      // The error label is 8px and truncated to 3 lines, so a setup mistake
      // such as a missing key is unreadable on screen. Log it in full.
      debugPrint('WeatherCard: $message');
      setState(() {
        _error = message;
        _status = _WeatherStatus.error;
      });
    }
  }

  Future<Position> _currentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const WeatherApiException('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const WeatherApiException('Location permission denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const WeatherApiException(
        'Location permission is permanently denied.',
      );
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: switch (_status) {
        _WeatherStatus.locating =>
          const _WeatherPlaceholder(message: 'Getting your location...'),
        _WeatherStatus.fetching =>
          const _WeatherPlaceholder(message: 'Getting weather...'),
        _WeatherStatus.error => _WeatherError(message: _error, onRetry: _load),
        _WeatherStatus.loaded =>
          _LoadedState(data: _data!, onRefresh: _load),
      },
    );
  }
}

class _LoadedState extends StatelessWidget {
  const _LoadedState({required this.data, required this.onRefresh});

  final WeatherData data;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final icon = WeatherService.weatherIcon(data.conditionCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 12,
              color: Colors.white70,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.city,
                    style: AppTextStyles.captionWhite.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (data.region.isNotEmpty)
                    Text(
                      data.region,
                      style: AppTextStyles.captionWhite.copyWith(
                        fontSize: 9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRefresh,
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.refresh_rounded,
                  size: 12,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '${data.tempC}°C',
          style: AppTextStyles.heroTitle.copyWith(fontSize: 30, height: 1.05),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                data.conditionText,
                style: AppTextStyles.captionWhite,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(color: Colors.white.withValues(alpha: 0.25), height: 1),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricChip(
                icon: Icons.water_drop_rounded,
                label: 'Humidity',
                value: '${data.humidity}%',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricChip(
                icon: Icons.air_rounded,
                label: 'Wind',
                value: '${data.windKph} km/h',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const _ScanStatusIndicator(),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 11, color: Colors.white70),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.captionWhite.copyWith(fontSize: 9),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.statWhite.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Pulsing "AI Detection In Progress..." chip shown under the weather
/// metrics while a scan is running.
class _ScanStatusIndicator extends StatefulWidget {
  const _ScanStatusIndicator();

  @override
  State<_ScanStatusIndicator> createState() => _ScanStatusIndicatorState();
}

class _ScanStatusIndicatorState extends State<_ScanStatusIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.3, end: 1).animate(_pulse),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              'AI Detection In Progress...',
              style: AppTextStyles.captionWhite.copyWith(
                color: Colors.white,
                fontSize: 9,
                height: 1.3,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherPlaceholder extends StatelessWidget {
  const _WeatherPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.captionWhite,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 20, color: Colors.white70),
          const SizedBox(height: 6),
          Text(
            'Weather unavailable',
            textAlign: TextAlign.center,
            style: AppTextStyles.captionWhite.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.captionWhite.copyWith(fontSize: 8),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh_rounded,
                    size: 11,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Retry',
                    style: AppTextStyles.captionWhite.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
