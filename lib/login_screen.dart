import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';
import 'auth_service.dart';
import 'homescreen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = const AuthService();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _restoreRememberedEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _restoreRememberedEmail() async {
    final saved = await _authService.loadRememberedLogin();
    if (!mounted || saved == null) return;
    setState(() {
      _emailController.text = saved.email;
      _rememberMe = true;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onLogin() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    setState(() => _isLoading = true);

    try {
      await _authService.login(
        email: email,
        password: _passwordController.text,
      );
      if (!mounted) return;

      try {
        if (_rememberMe) {
          await _authService.saveRememberedLogin(email: email);
        } else {
          await _authService.clearRememberedLogin();
        }
      } catch (_) {
        // Remember-me is a convenience; never block a successful login.
      }

      if (!mounted) return;
      _showMessage('Login successful. Welcome back!');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onForgotPassword() async {
    final email = await showDialog<String>(
      context: context,
      builder: (context) =>
          _ForgotPasswordDialog(initialEmail: _emailController.text.trim()),
    );
    if (email == null || !mounted) return;

    try {
      await _authService.requestPasswordReset(email: email);
      if (!mounted) return;
      _showMessage('Password reset link sent to $email');
    } on AuthException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    }
  }

  void _onGoogleLogin() {
    _showMessage('Google sign-in coming soon');
  }

  void _goToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.agroWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final compact = width < 720;
            final desktop = width >= 1080;

            if (compact) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 320, child: _BrandPanel(compact: true)),
                    _FormSurface(child: _buildForm(compact: true)),
                  ],
                ),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: desktop ? 1 : 5,
                  child: _BrandPanel(compact: false),
                ),
                Expanded(
                  flex: desktop ? 1 : 6,
                  child: _FormSurface(child: _buildForm(compact: false)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm({required bool compact}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _LoginHeader(),
          const SizedBox(height: 26),
          _AuthField(
            controller: _emailController,
            hint: 'Email Address',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Please enter your email address';
              if (!_emailPattern.hasMatch(email)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _AuthField(
            controller: _passwordController,
            hint: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onToggleObscure: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            onSubmitted: (_) => _onLogin(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 2,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) =>
                          setState(() => _rememberMe = value ?? false),
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
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      'Remember Me',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.agroText,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: _onForgotPassword,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: AppColors.agroDark,
                ),
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.agroDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _LoginButton(isLoading: _isLoading, onTap: _onLogin),
          const SizedBox(height: 26),
          const _OrDivider(),
          const SizedBox(height: 22),
          _GoogleButton(onTap: _onGoogleLogin),
          const SizedBox(height: 26),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.agroText,
                  fontSize: 12.5,
                ),
              ),
              GestureDetector(
                onTap: _goToSignup,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Sign Up',
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
    );
  }
}

class _BrandPanel extends StatefulWidget {
  const _BrandPanel({required this.compact});

  final bool compact;

  @override
  State<_BrandPanel> createState() => _BrandPanelState();
}

class _BrandPanelState extends State<_BrandPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _float
        ..stop()
        ..value = 0.4;
    } else if (!_float.isAnimating) {
      _float.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        const _FieldBackdrop(),
        Positioned(
          top: compact ? -26 : -18,
          left: compact ? -34 : -46,
          child: _Leaf(
            asset: 'assets/images/leaf_1.png',
            size: compact ? 120 : 210,
            angle: -0.35,
          ),
        ),
        Positioned(
          bottom: compact ? -34 : -30,
          right: compact ? -30 : -54,
          child: _Leaf(
            asset: 'assets/images/leaf_3.png',
            size: compact ? 130 : 240,
            angle: 0.8,
          ),
        ),
        if (!compact) const Positioned(top: 40, right: 44, child: _Drone()),
        Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 22 : 52,
            compact ? 18 : 44,
            compact ? 22 : 52,
            compact ? 20 : 44,
          ),
          child: compact ? _compactContent() : _desktopContent(),
        ),
      ],
    );
  }

  Widget _desktopContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BrandWordmark(large: false),
                  const Spacer(),
                  Text(
                    'Agrovision',
                    style: AppTextStyles.display.copyWith(
                      fontSize: 54,
                      color: AppColors.agroWhite,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: AppColors.agroDark.withValues(alpha: 0.5),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Smart Farming... Brighter Future...',
                    style: AppTextStyles.titleWhite.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: AppColors.agroWhite.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 34),
                  const _FeatureHighlights(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _compactContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BrandWordmark(large: false),
          const SizedBox(height: 20),
          Text(
            'Agrovision',
            style: AppTextStyles.display.copyWith(
              fontSize: 34,
              color: AppColors.agroWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Smart Farming... Brighter Future...',
            style: AppTextStyles.bodySmallWhite.copyWith(
              fontSize: 13,
              color: AppColors.agroWhite.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 18),
          const _FeatureHighlights(compact: true),
        ],
      ),
    );
  }
}

class _FieldBackdrop extends StatelessWidget {
  const _FieldBackdrop();

  static const String _asset =
      'assets/images/WhatsApp Image 2026-09-04 at 23.02.47.jpeg';

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _asset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.fieldSkyMid,
                    AppColors.fieldCanopy,
                    AppColors.fieldDeep,
                  ],
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.agroDark.withValues(alpha: 0.86),
                  AppColors.agroDark.withValues(alpha: 0.42),
                  AppColors.agroDark.withValues(alpha: 0.90),
                ],
                stops: const [0.0, 0.52, 1.0],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.agroDark.withValues(alpha: 0.30),
                  Colors.transparent,
                  AppColors.agroDark.withValues(alpha: 0.45),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Leaf extends StatelessWidget {
  const _Leaf({required this.asset, required this.size, required this.angle});

  final String asset;
  final double size;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.22,
        child: Transform.rotate(
          angle: angle,
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
    );
  }
}

class _Drone extends StatelessWidget {
  const _Drone();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.agroWhite.withValues(alpha: 0.10),
          border: Border.all(
            color: AppColors.agroWhite.withValues(alpha: 0.22),
          ),
        ),
        child: CustomPaint(painter: _DronePainter()),
      ),
    );
  }
}

class _DronePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.agroWhite.withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final arm = size.width * 0.24;
    canvas.drawLine(
      center + Offset(-arm, -arm),
      center + Offset(arm, arm),
      paint,
    );
    canvas.drawLine(
      center + Offset(arm, -arm),
      center + Offset(-arm, arm),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: size.width * 0.24,
          height: size.height * 0.15,
        ),
        const Radius.circular(5),
      ),
      paint,
    );

    for (final corner in [
      center + Offset(-arm, -arm),
      center + Offset(arm, -arm),
      center + Offset(-arm, arm),
      center + Offset(arm, arm),
    ]) {
      canvas.drawCircle(corner, 8, paint);
      canvas.drawLine(
        corner + const Offset(-13, 0),
        corner + const Offset(13, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeatureHighlights extends StatelessWidget {
  const _FeatureHighlights({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: compact ? 8 : 12,
      runSpacing: compact ? 8 : 12,
      children: const [
        _FeatureBadge(icon: Icons.biotech_rounded, label: 'Detect Diseases'),
        _FeatureBadge(
          icon: Icons.lightbulb_outline_rounded,
          label: 'Get Solutions',
        ),
        _FeatureBadge(icon: Icons.public_rounded, label: 'Track Spread'),
      ],
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.agroWhite.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.agroWhite.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.agroWhite, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.agroWhite,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandWordmark extends StatelessWidget {
  const _BrandWordmark({required this.large});

  final bool large;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LeafLogo(size: large ? 64 : 46),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Agrovision',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.agroWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                'AI for Healthier Crops',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.agroWhite.withValues(alpha: 0.78),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeafLogo extends StatelessWidget {
  const _LeafLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.agroPrimary, AppColors.agroFresh],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.agroDark.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.eco_rounded,
            color: AppColors.agroWhite,
            size: size * 0.52,
          ),
          Positioned(
            right: size * 0.14,
            bottom: size * 0.14,
            child: Icon(
              Icons.search_rounded,
              color: AppColors.agroWhite,
              size: size * 0.28,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _LeafLogo(size: 72),
        const SizedBox(height: 18),
        Text(
          'Welcome Back!',
          textAlign: TextAlign.center,
          style: AppTextStyles.cardHeading.copyWith(
            fontSize: 30,
            color: AppColors.agroDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Login to continue with Agrovision',
          textAlign: TextAlign.center,
          style: AppTextStyles.cardBody.copyWith(fontSize: 13.5),
        ),
      ],
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.onToggleObscure,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final base = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: AppColors.agroPrimary.withValues(alpha: 0.18),
      ),
    );
    final focused = OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.agroPrimary, width: 1.6),
    );
    final error = OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.alertRed, width: 1.4),
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      obscureText: obscureText,
      onFieldSubmitted: onSubmitted,
      cursorColor: AppColors.agroDark,
      style: AppTextStyles.body.copyWith(
        color: AppColors.agroText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.agroText.withValues(alpha: 0.52),
        ),
        filled: true,
        fillColor: AppColors.agroPale.withValues(alpha: 0.62),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.alertRed),
        border: base,
        enabledBorder: base,
        focusedBorder: focused,
        errorBorder: error,
        focusedErrorBorder: error,
      ),
    );
  }
}

class _LoginButton extends StatefulWidget {
  const _LoginButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final enabled = !widget.isLoading;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered && enabled ? 1.015 : 1.0,
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
                  alpha: _hovered && enabled ? 0.42 : 0.26,
                ),
                blurRadius: _hovered && enabled ? 26 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? widget.onTap : null,
              borderRadius: radius,
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.agroWhite,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Login',
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

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final line = Divider(
      color: AppColors.agroDark.withValues(alpha: 0.18),
      thickness: 1,
      height: 1,
    );
    return Row(
      children: [
        Expanded(child: line),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.agroText.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          ),
        ),
        Expanded(child: line),
      ],
    );
  }
}

class _GoogleButton extends StatefulWidget {
  const _GoogleButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<_GoogleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 54,
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.agroPale.withValues(alpha: 0.7)
              : AppColors.agroWhite,
          borderRadius: radius,
          border: Border.all(
            color: AppColors.agroDark.withValues(alpha: _hovered ? 0.32 : 0.18),
            width: 1.2,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.agroDark.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: radius,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _GoogleGlyph(),
                    const SizedBox(width: 10),
                    Text(
                      'Continue with Google',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.agroText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
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
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}

class _FormSurface extends StatelessWidget {
  const _FormSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.agroWhite,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialEmail,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: AppColors.agroWhite,
      title: Text(
        'Reset Password',
        style: AppTextStyles.title.copyWith(
          color: AppColors.agroDark,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your email and we will send you a reset link.',
              style: AppTextStyles.cardBody,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              style: AppTextStyles.body.copyWith(color: AppColors.agroText),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Please enter your email address';
                if (!_emailPattern.hasMatch(email)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Email Address',
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.agroPrimary,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.agroPale.withValues(alpha: 0.62),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: AppColors.agroPrimary.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: AppColors.agroPrimary.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.agroPrimary,
                    width: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: AppTextStyles.label.copyWith(
              color: AppColors.agroText.withValues(alpha: 0.75),
            ),
          ),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.agroPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Send Reset Link',
            style: AppTextStyles.button.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
