import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';
import 'disease_detection_service.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, this.cropName});

  final String? cropName;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  final DiseaseDetectionService _service = DiseaseDetectionService();

  Uint8List? _imageBytes;
  String? _filename;
  DetectionResult? _result;
  String? _error;
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _filename = file.name.isNotEmpty ? file.name : 'leaf.jpg';
        _result = null;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not pick image: $e';
      });
    }
  }

  Future<void> _analyze() async {
    if (_imageBytes == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await _service.detectDisease(
        bytes: _imageBytes!,
        filename: _filename ?? 'leaf.jpg',
      );
      if (!mounted) return;
      setState(() {
        _result = result;
      });
    } catch (e) {
      if (!mounted) return;
      String message = e.toString();
      if (e is DiseaseDetectionException) message = e.message;
      setState(() {
        _error = message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.cropName != null ? 'Scan ${widget.cropName} Leaf' : 'Scan Leaf';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        title: Text(title, style: AppTextStyles.title.copyWith(fontSize: 18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPickerArea(),
              const SizedBox(height: 16),
              if (_imageBytes != null) _buildPreview(),
              if (_imageBytes != null) const SizedBox(height: 16),
              if (_imageBytes != null) _buildAnalyzeButton(),
              if (_loading) const SizedBox(height: 20),
              if (_loading) const _LoadingCard(),
              if (_error != null) const SizedBox(height: 16),
              if (_error != null) _ErrorCard(message: _error!, onRetry: _analyze),
              if (_result != null) const SizedBox(height: 16),
              if (_result != null) _ResultCard(result: _result!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          const Icon(Icons.eco_rounded, size: 40, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            'Upload or capture a leaf photo',
            style: AppTextStyles.title.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'We\'ll detect the crop and any disease using AI.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Gallery'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _loading ? null : () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: const Text('Camera'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.memory(
        _imageBytes!,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return FilledButton.icon(
      onPressed: _loading ? null : _analyze,
      icon: _loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.auto_awesome_rounded),
      label: Text(_loading ? 'Analyzing...' : 'Analyze Leaf'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ctaGreen,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: AppTextStyles.button,
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Analyzing leaf image with AI...\nMake sure the backend server is running.',
              style: AppTextStyles.body.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.alertRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.alertRed),
              const SizedBox(width: 8),
              Text('Analysis failed', style: AppTextStyles.title.copyWith(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: AppTextStyles.body.copyWith(fontSize: 13)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.alertRed),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final DetectionResult result;

  @override
  Widget build(BuildContext context) {
    final healthy = result.isHealthy;
    final color = healthy ? AppColors.secondary : AppColors.alertRed;
    final icon = healthy ? Icons.check_circle_rounded : Icons.warning_amber_rounded;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  healthy ? 'Healthy Plant' : 'Disease Detected',
                  style: AppTextStyles.title.copyWith(fontSize: 18, color: color),
                ),
              ),
              if (result.confidence.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    result.confidence,
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _Row(label: 'Crop', value: result.crop),
          const Divider(height: 16, color: AppColors.divider),
          _Row(label: 'Condition', value: result.disease),
          if (result.status.isNotEmpty) ...[
            const Divider(height: 16, color: AppColors.divider),
            _Row(label: 'Status', value: result.status),
          ],
          const Divider(height: 16, color: AppColors.divider),
          Text('Treatment / Recommendation', style: AppTextStyles.label),
          const SizedBox(height: 6),
          Text(
            result.treatment.isNotEmpty ? result.treatment : 'No recommendation provided.',
            style: AppTextStyles.body.copyWith(fontSize: 13, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: AppTextStyles.caption),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '-',
            style: AppTextStyles.label.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
