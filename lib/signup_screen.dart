import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';
import 'homescreen.dart';

/// AgroVision sign-up page: a realistic crop-field backdrop with a soft blur,
/// floating leaves and an AI disease-scanner motif behind a glassmorphism
/// registration card. All registration state, validation, terms gating and
/// navigation to the home page are unchanged.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static final RegExp _emailPattern = RegExp(
    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
  );

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onRegister() {
    if (!_agreedToTerms) {
      _showMessage('Please agree to the Terms & Privacy Policy.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              const _CropFieldBackground(),
              const _BottomHills(),
              if (!isCompact) const _DiseaseScanner(),
              _FloatingLeaves(reduceMotion: reduceMotion, compact: isCompact),
              const _AiDetectionBadge(),
              if (!isCompact) const _HandwrittenTagline(),
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    isCompact ? 18 : 24,
                    18,
                    isCompact ? 18 : 24,
                    120,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: _GlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _BrandHeader(),
                              const SizedBox(height: 16),
                              Text(
                                'Create Account',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.cardHeading,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Join us to help keep your crops healthy and '
                                'your farm productive.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.cardBody,
                              ),
                              const SizedBox(height: 18),
                              _AgroTextField(
                                controller: _nameController,
                                hint: 'Full Name',
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
                              _AgroTextField(
                                controller: _emailController,
                                hint: 'Email Address',
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
                              _AgroTextField(
                                controller: _passwordController,
                                hint: 'Password',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                onToggleObscure: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 '
                                        'characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _AgroTextField(
                                controller: _confirmController,
                                hint: 'Confirm Password',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscureConfirm,
                                textInputAction: TextInputAction.done,
                                onToggleObscure: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _TermsRow(
                                value: _agreedToTerms,
                                onChanged: (value) => setState(
                                  () => _agreedToTerms = value,
                                ),
                                onLinkTap: () => _showMessage(
                                  'Terms & Privacy Policy coming soon',
                                ),
                              ),
                              const SizedBox(height: 18),
                              _RegisterButton(onTap: _onRegister),
                              const SizedBox(height: 24),
                              const _OrDivider(),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _SocialButton(
                                    onTap: () => _showMessage(
                                      'Google sign-up coming soon',
                                    ),
                                    child: const _GoogleGlyph(),
                                  ),
                                  const SizedBox(width: 22),
                                  _SocialButton(
                                    onTap: () => _showMessage(
                                      'Apple sign-up coming soon',
                                    ),
                                    child: const Icon(
                                      Icons.apple,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 26),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.agroText,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _showMessage('Log in coming soon'),
                                    child: Text(
                                      'Log In',
                                      style: AppTextStyles.label.copyWith(
                                        color: AppColors.agroDark,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.agroDark,
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Background scenery
// -----------------------------------------------------------------------------

/// Full-bleed procedural crop field: warm sunlit sky, perspective crop rows
/// and bokeh light, softened with a blur and darkened near the bottom/edges.
class _CropFieldBackground extends StatelessWidget {
  const _CropFieldBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: CustomPaint(painter: _CropFieldPainter()),
            ),
            // Warm sunlight wash from the top-right.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.7, -0.85),
                  radius: 1.1,
                  colors: [
                    AppColors.fieldSunGlow.withValues(alpha: 0.65),
                    AppColors.fieldSunGlow.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            // Subtle dark-green gradient near the bottom and edges keeps the
            // card readable and frames the scene.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.agroDark.withValues(alpha: 0.18),
                    AppColors.agroDark.withValues(alpha: 0.02),
                    AppColors.agroDark.withValues(alpha: 0.42),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CropFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.fieldSkyTop,
          AppColors.fieldSkyMid,
          AppColors.fieldCanopy,
        ],
        stops: [0.0, 0.42, 0.64],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), sky);

    final horizon = h * 0.46;

    final ground = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.fieldCanopy, AppColors.fieldDeep],
      ).createShader(Rect.fromLTWH(0, horizon, w, h - horizon));
    canvas.drawRect(Rect.fromLTWH(0, horizon, w, h), ground);

    // Perspective crop rows converging on the horizon.
    final vanish = Offset(w * 0.5, horizon);
    final rowPaint = Paint()
      ..color = AppColors.fieldDeep.withValues(alpha: 0.40)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = -7; i <= 7; i++) {
      final bottomX = w * 0.5 + i * (w * 0.17);
      canvas.drawLine(
        vanish + Offset(i * 6.0, 0),
        Offset(bottomX, h),
        rowPaint,
      );
    }
    // Horizontal furrow seams.
    for (var j = 1; j <= 6; j++) {
      final t = j / 7;
      final y = horizon + (h - horizon) * t * t;
      canvas.drawLine(
        Offset(0, y),
        Offset(w, y),
        Paint()..color = AppColors.fieldDeep.withValues(alpha: 0.14),
      );
    }

    // Bokeh crop highlights scattered over the near field.
    final random = math.Random(7);
    for (var i = 0; i < 46; i++) {
      final cy = horizon + random.nextDouble() * (h - horizon);
      final t = (cy - horizon) / (h - horizon);
      final radius = 2 + t * 15;
      final color = random.nextBool()
          ? AppColors.agroFresh
          : AppColors.fieldSunGlow;
      canvas.drawCircle(
        Offset(random.nextDouble() * w, cy),
        radius,
        Paint()..color = color.withValues(alpha: 0.05 + 0.12 * (1 - t)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Layered green hills / curved shapes anchoring the bottom of the page.
class _BottomHills extends StatelessWidget {
  const _BottomHills();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 240,
      child: IgnorePointer(
        child: CustomPaint(painter: _HillsPainter()),
      ),
    );
  }
}

class _HillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _hill(canvas, size, AppColors.hillBack, 0.52, 26, 0.6);
    _hill(canvas, size, AppColors.hillMid, 0.68, 18, 2.4);
    _hill(canvas, size, AppColors.hillFront, 0.84, 12, 4.1);
  }

  void _hill(
    Canvas canvas,
    Size size,
    Color color,
    double topFraction,
    double wave,
    double phase,
  ) {
    final w = size.width;
    final h = size.height;
    final baseY = h * topFraction;
    final path = Path()..moveTo(0, h);
    for (double x = 0; x <= w; x += 8) {
      final y = baseY + math.sin((x / w) * math.pi * 2 + phase) * wave;
      path.lineTo(x, y);
    }
    path
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// AI disease-scanner decoration (upper-right, desktop)
// -----------------------------------------------------------------------------

class _DiseaseScanner extends StatefulWidget {
  const _DiseaseScanner();

  @override
  State<_DiseaseScanner> createState() => _DiseaseScannerState();
}

class _DiseaseScannerState extends State<_DiseaseScanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _glow
        ..stop()
        ..value = 0.5;
    } else if (!_glow.isAnimating) {
      _glow.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -30,
      right: -40,
      width: 360,
      height: 360,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _glow,
          builder: (context, _) {
            final t = Curves.easeInOut.transform(_glow.value);
            return CustomPaint(
              painter: _ScannerPainter(glow: t),
              size: const Size(360, 360),
            );
          },
        ),
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  _ScannerPainter({required this.glow});

  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringRadius = size.width * 0.40;

    // Glowing circular scanning ring.
    canvas.drawCircle(
      center,
      ringRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..color = AppColors.scanGlow.withValues(alpha: 0.16 + 0.22 * glow)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, 12 + 8 * glow),
    );
    canvas.drawCircle(
      center,
      ringRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.scanGlow.withValues(alpha: 0.85),
    );

    // Rotating scan sweep.
    final rect = Rect.fromCircle(center: center, radius: ringRadius);
    canvas.drawArc(
      rect,
      glow * math.pi * 2,
      math.pi * 0.5,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = AppColors.scanGlow.withValues(alpha: 0.9),
    );

    // Large diseased leaf.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.35);
    final halfLength = size.width * 0.25;
    final halfWidth = size.width * 0.145;
    final leaf = Path()
      ..moveTo(0, -halfLength)
      ..quadraticBezierTo(halfWidth, -halfLength * 0.15, 0, halfLength)
      ..quadraticBezierTo(-halfWidth, -halfLength * 0.15, 0, -halfLength)
      ..close();
    canvas.drawPath(
      leaf,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.agroFresh, AppColors.agroPrimary],
        ).createShader(
          Rect.fromLTWH(
            -halfWidth,
            -halfLength,
            halfWidth * 2,
            halfLength * 2,
          ),
        ),
    );

    // Veins.
    final veinPaint = Paint()
      ..color = AppColors.agroDark.withValues(alpha: 0.32)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, -halfLength), Offset(0, halfLength), veinPaint);
    for (var i = 0; i < 5; i++) {
      final y = -halfLength + (i + 1) * (2 * halfLength / 6);
      canvas.drawLine(
        Offset(0, y),
        Offset(halfWidth * 0.7, y - halfLength * 0.18),
        veinPaint,
      );
      canvas.drawLine(
        Offset(0, y),
        Offset(-halfWidth * 0.7, y - halfLength * 0.18),
        veinPaint,
      );
    }

    // Disease spots with AI detection highlights.
    final spots = <Offset>[
      Offset(halfWidth * 0.35, -halfLength * 0.35),
      Offset(-halfWidth * 0.40, halfLength * 0.15),
      Offset(halfWidth * 0.50, halfLength * 0.50),
      Offset(-halfWidth * 0.25, -halfLength * 0.10),
    ];
    for (final spot in spots) {
      canvas.drawCircle(
        spot,
        9,
        Paint()
          ..color = AppColors.scanGlow.withValues(alpha: 0.25)
          ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, 5),
      );
      canvas.drawCircle(
        spot,
        5.5,
        Paint()..color = AppColors.scanSpot.withValues(alpha: 0.9),
      );
      canvas.drawCircle(
        spot,
        5.5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = AppColors.agroDark.withValues(alpha: 0.5),
      );
    }
    canvas.restore();

    // Four AI scanning corner brackets.
    final bracketPaint = Paint()
      ..color = AppColors.scanGlow
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final r = ringRadius + 16;
    final len = 22.0;
    void bracket(Offset corner, double dx, double dy) {
      canvas.drawLine(corner, corner + Offset(dx * len, 0), bracketPaint);
      canvas.drawLine(corner, corner + Offset(0, dy * len), bracketPaint);
    }

    bracket(Offset(center.dx - r, center.dy - r), 1, 1);
    bracket(Offset(center.dx + r, center.dy - r), -1, 1);
    bracket(Offset(center.dx - r, center.dy + r), 1, -1);
    bracket(Offset(center.dx + r, center.dy + r), -1, -1);
  }

  @override
  bool shouldRepaint(covariant _ScannerPainter oldDelegate) =>
      oldDelegate.glow != glow;
}

// -----------------------------------------------------------------------------
// Floating leaf decorations
// -----------------------------------------------------------------------------

class _FloatingLeaves extends StatefulWidget {
  const _FloatingLeaves({required this.reduceMotion, required this.compact});

  final bool reduceMotion;
  final bool compact;

  @override
  State<_FloatingLeaves> createState() => _FloatingLeavesState();
}

class _FloatingLeavesState extends State<_FloatingLeaves>
    with SingleTickerProviderStateMixin {
  AnimationController? _float;

  @override
  void initState() {
    super.initState();
    if (!widget.reduceMotion) {
      _float = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 6),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _float?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = widget.compact ? _compactLeaves : _desktopLeaves;
    final controller = _float;
    return Positioned.fill(
      child: IgnorePointer(
        child: controller == null
            ? Stack(children: [for (final spec in specs) spec.build(0)])
            : AnimatedBuilder(
                animation: controller,
                builder: (context, _) => Stack(
                  children: [
                    for (final spec in specs) spec.build(controller.value),
                  ],
                ),
              ),
      ),
    );
  }
}

class _LeafSpec {
  const _LeafSpec({
    required this.asset,
    required this.size,
    required this.rotation,
    required this.opacity,
    required this.phase,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final String asset;
  final double size;
  final double rotation;
  final double opacity;
  final double phase;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  Widget build(double t) {
    final dy = math.sin(t * math.pi * 2 + phase) * 10;
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.translate(
        offset: Offset(0, dy),
        child: Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: rotation,
            child: Image.asset(
              asset,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

const List<_LeafSpec> _desktopLeaves = [
  _LeafSpec(
    asset: 'assets/images/leaf_1.png',
    size: 150,
    rotation: -0.35,
    opacity: 0.60,
    phase: 0,
    top: -24,
    left: -40,
  ),
  _LeafSpec(
    asset: 'assets/images/leaf_3.png',
    size: 165,
    rotation: 0.80,
    opacity: 0.50,
    phase: 3.1,
    bottom: -10,
    left: -48,
  ),
  _LeafSpec(
    asset: 'assets/images/leaf_4.png',
    size: 130,
    rotation: -0.60,
    opacity: 0.55,
    phase: 4.6,
    bottom: 96,
    right: -38,
  ),
];

const List<_LeafSpec> _compactLeaves = [
  _LeafSpec(
    asset: 'assets/images/leaf_1.png',
    size: 108,
    rotation: -0.35,
    opacity: 0.50,
    phase: 0,
    top: -20,
    left: -32,
  ),
  _LeafSpec(
    asset: 'assets/images/leaf_3.png',
    size: 120,
    rotation: 0.80,
    opacity: 0.45,
    phase: 3.1,
    bottom: -6,
    left: -38,
  ),
];

// -----------------------------------------------------------------------------
// Bottom badges and tagline
// -----------------------------------------------------------------------------

/// Small glowing "AI detection" badge anchored to the bottom-left corner.
class _AiDetectionBadge extends StatelessWidget {
  const _AiDetectionBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      bottom: 22,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.agroDark.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.scanGlow.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.scanGlow.withValues(alpha: 0.30),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.agroFresh.withValues(alpha: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.scanGlow.withValues(alpha: 0.55),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: AppColors.agroWhite,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'AI DETECTION',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.agroWhite,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    'HEALTHY CROP',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.scanGlow,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 9,
                    ),
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

/// Handwritten tagline anchored to the bottom-right corner.
class _HandwrittenTagline extends StatelessWidget {
  const _HandwrittenTagline();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 20,
      child: IgnorePointer(
        child: Text(
          'Healthy Crops, Better Tomorrow',
          style: AppTextStyles.handwritten.copyWith(
            shadows: [
              Shadow(
                color: AppColors.agroDark.withValues(alpha: 0.65),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Glass card
// -----------------------------------------------------------------------------

/// Translucent pale-green glass card with a backdrop blur, rounded corners,
/// a subtle white border and a soft shadow.
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 34,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassFill,
                  AppColors.glassTint.withValues(alpha: 0.78),
                ],
              ),
              borderRadius: radius,
              border: Border.all(color: AppColors.glassBorder, width: 1.2),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Brand header
// -----------------------------------------------------------------------------

/// Green rounded-square logo (white leaf + magnifying glass), app name and
/// tagline.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.agroPrimary, AppColors.agroFresh],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.agroPrimary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.eco_rounded,
                color: AppColors.agroWhite,
                size: 42,
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Icon(
                  Icons.search_rounded,
                  color: AppColors.agroWhite,
                  size: 22,
                  shadows: [
                    Shadow(
                      color: AppColors.agroDark.withValues(alpha: 0.35),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'AgroVision',
          style: AppTextStyles.display.copyWith(
            fontSize: 24,
            color: AppColors.agroDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'AI for Crop Disease Detection',
          style: AppTextStyles.caption.copyWith(color: AppColors.agroText),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Form controls
// -----------------------------------------------------------------------------

/// White pill-shaped form field with a green outline icon and an optional
/// password visibility toggle.
class _AgroTextField extends StatelessWidget {
  const _AgroTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onToggleObscure,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(30);
    final baseBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: AppColors.agroPrimary.withValues(alpha: 0.25),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.agroPrimary, width: 1.8),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.alertRed, width: 1.4),
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      cursorColor: AppColors.agroDark,
      style: AppTextStyles.body.copyWith(
        color: AppColors.agroText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.agroText.withValues(alpha: 0.55),
        ),
        filled: true,
        fillColor: AppColors.agroWhite.withValues(alpha: 0.94),
        prefixIcon: Icon(icon, color: AppColors.agroPrimary, size: 20),
        suffixIcon: onToggleObscure == null
            ? null
            : IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColors.agroPrimary,
                  size: 20,
                ),
              ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.alertRed),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}

/// Terms agreement checkbox with tappable policy copy.
class _TermsRow extends StatelessWidget {
  const _TermsRow({
    required this.value,
    required this.onChanged,
    required this.onLinkTap,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (checked) => onChanged(checked ?? false),
            activeColor: AppColors.agroPrimary,
            checkColor: AppColors.agroWhite,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            side: BorderSide(
              color: AppColors.agroPrimary.withValues(alpha: 0.7),
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GestureDetector(
                onTap: () => onChanged(!value),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'I agree to the ',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.agroText,
                    fontSize: 12.5,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onLinkTap,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Terms & Privacy Policy',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.agroDark,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.agroDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Wide pill-shaped green gradient CTA with a hover lift and a trailing arrow.
class _RegisterButton extends StatefulWidget {
  const _RegisterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<_RegisterButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(30);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.agroDark, AppColors.agroFresh],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: AppColors.agroDark.withValues(
                  alpha: _hovered ? 0.45 : 0.30,
                ),
                blurRadius: _hovered ? 26 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: radius,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Register',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.agroWhite,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Or sign up with" label flanked by thin horizontal rules.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final line = Divider(
      color: AppColors.agroDark.withValues(alpha: 0.22),
      thickness: 1,
      height: 1,
    );
    return Row(
      children: [
        Expanded(child: line),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or sign up with',
            style: AppTextStyles.caption.copyWith(color: AppColors.agroText),
          ),
        ),
        Expanded(child: line),
      ],
    );
  }
}

/// White circular social sign-up button.
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.agroDark.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.agroWhite,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// Multi-colour "G" glyph standing in for the Google logo.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF4285F4),
          Color(0xFF34A853),
          Color(0xFFFBBC05),
          Color(0xFFEA4335),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}
