import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:emergency_app/weather_service.dart';

void main() {
  const payload = {
    'current': {
      'temperature_2m': 31.6,
      'relative_humidity_2m': 72,
      'wind_speed_10m': 11.3,
      'weather_code': 2,
    },
  };

  group('WeatherService.fetchWeather', () {
    test('requests Open-Meteo without a key and maps the response', () async {
      final requests = <Uri>[];
      final client = MockClient((request) async {
        requests.add(request.url);
        return http.Response(jsonEncode(payload), 200);
      });
      final service = WeatherService(client: client);

      final data = await service.fetchWeather(22.5726, 88.3639);

      final weather = requests.firstWhere(
        (u) => u.host == 'api.open-meteo.com',
      );
      expect(weather.queryParameters['latitude'], '22.5726');
      expect(weather.queryParameters['longitude'], '88.3639');
      expect(weather.queryParameters['current'], contains('weather_code'));
      expect(weather.queryParameters.containsKey('key'), isFalse);
      expect(data.tempC, 32);
      expect(data.conditionText, 'Partly cloudy');
      expect(data.conditionCode, 2);
      expect(data.humidity, 72);
      expect(data.windKph, 11);
      expect(data.city, 'Unknown');
    });

    test('throws WeatherApiException on a non-200 response', () async {
      final client = MockClient((_) async => http.Response('nope', 500));
      final service = WeatherService(client: client);

      await expectLater(
        service.fetchWeather(22.5726, 88.3639),
        throwsA(
          isA<WeatherApiException>().having(
            (e) => e.message,
            'message',
            contains('500'),
          ),
        ),
      );
    });

    test('resolves the administrative city and region from OSM', () async {
      final client = MockClient((request) async {
        if (request.url.host == 'nominatim.openstreetmap.org') {
          return http.Response(
            jsonEncode({
              'address': {
                'municipality': 'Kolkata Metropolitan Area',
                'city': 'New Town',
                'state': 'West Bengal',
              },
            }),
            200,
          );
        }
        return http.Response(jsonEncode(payload), 200);
      });
      final service = WeatherService(client: client);

      final data = await service.fetchWeather(22.571, 88.480);

      expect(data.city, 'Kolkata');
      expect(data.region, 'West Bengal');
      expect(data.tempC, 32);
    });

    test('falls back to an unknown place when OSM is unreachable', () async {
      final client = MockClient((request) async {
        if (request.url.host == 'nominatim.openstreetmap.org') {
          throw http.ClientException(
            'Failed host lookup: nominatim.openstreetmap.org',
          );
        }
        return http.Response(jsonEncode(payload), 200);
      });
      final service = WeatherService(client: client);

      final data = await service.fetchWeather(22.571, 88.480);

      expect(data.city, 'Unknown');
      expect(data.region, '');
      expect(data.tempC, 32);
    });

    test('reports a failed connection as no internet, not a raw error',
        () async {
      final client = MockClient(
        (_) async => throw http.ClientException(
          'Failed host lookup: api.open-meteo.com',
        ),
      );
      final service = WeatherService(client: client);

      await expectLater(
        service.fetchWeather(22.5726, 88.3639),
        throwsA(
          isA<WeatherApiException>().having(
            (e) => e.message,
            'message',
            contains('No internet connection'),
          ),
        ),
      );
    });
  });
}
