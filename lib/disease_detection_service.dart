import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class DetectionResult {
  const DetectionResult({
    required this.crop,
    required this.disease,
    required this.confidence,
    required this.status,
    required this.treatment,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      crop: (json['crop'] ?? 'Unknown').toString(),
      disease: (json['disease'] ?? 'Unknown').toString(),
      confidence: (json['confidence'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      treatment: (json['treatment'] ?? '').toString(),
    );
  }

  final String crop;
  final String disease;
  final String confidence;
  final String status;
  final String treatment;

  bool get isHealthy => disease.toLowerCase() == 'healthy';
}

class DiseaseDetectionException implements Exception {
  const DiseaseDetectionException(this.message);
  final String message;
  @override
  String toString() => 'DiseaseDetectionException: $message';
}

class DiseaseDetectionService {
  DiseaseDetectionService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<DetectionResult> detectDisease({
    required Uint8List bytes,
    required String filename,
  }) async {
    final uri = Uri.parse('$apiBaseUrl/api/detect-disease');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));

    http.StreamedResponse streamed;
    try {
      streamed = await _client.send(request).timeout(const Duration(seconds: 60));
    } on TimeoutException {
      throw const DiseaseDetectionException(
        'Request timed out. Check that the backend is running and try again.',
      );
    } catch (e) {
      throw DiseaseDetectionException(
        'Could not reach server at $apiBaseUrl. Is the backend running?',
      );
    }

    final response = await http.Response.fromStream(streamed);
    if (response.statusCode != 200) {
      String message = 'Server error (${response.statusCode}).';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['detail'] != null) {
          message = body['detail'].toString();
        }
      } catch (_) {}
      throw DiseaseDetectionException(message);
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return DetectionResult.fromJson(json);
    } catch (_) {
      throw const DiseaseDetectionException('Invalid response from server.');
    }
  }
}
