import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/shared_preferences_service.dart';
import '../../../services/student_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    final prefs = context.read<SharedPreferencesService>();
    final studentProvider = context.read<StudentProvider>();
    await studentProvider.loadStudent();
    if (!mounted) return;
    if (prefs.isOnboardingDone) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9B8FE0),
                  Color(0xFF7C6FCD),
                  Color(0xFF5A4FB0)
                ],
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Floating stars
          Positioned(
            top: 80,
            left: 40,
            child: const Text('⭐', style: TextStyle(fontSize: 20))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                    begin: 0,
                    end: -12,
                    duration: 2000.ms,
                    curve: Curves.easeInOut)
                .fadeIn(),
          ),
          Positioned(
            top: 140,
            right: 50,
            child: const Text('✨', style: TextStyle(fontSize: 16))
                .animate(delay: 400.ms, onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                    begin: 0,
                    end: -10,
                    duration: 1800.ms,
                    curve: Curves.easeInOut)
                .fadeIn(),
          ),
          Positioned(
            top: 240,
            left: 30,
            child: const Text('🌟', style: TextStyle(fontSize: 14))
                .animate(delay: 700.ms, onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                    begin: 0,
                    end: -8,
                    duration: 2200.ms,
                    curve: Curves.easeInOut)
                .fadeIn(),
          ),
          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo circle
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('📚', style: TextStyle(fontSize: 70)),
                    ),
                  )
                      .animate()
                      .scale(duration: 700.ms, curve: Curves.elasticOut)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 32),

                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 44,
                      letterSpacing: -1,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                      .animate(delay: 300.ms)
                      .slideY(
                          begin: 0.4, duration: 500.ms, curve: Curves.easeOut)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 10),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Belajar Itu Menyenangkan! 🌟',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                      .animate(delay: 500.ms)
                      .slideY(
                          begin: 0.4, duration: 500.ms, curve: Curves.easeOut)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 70),

                  _LoadingBar().animate(delay: 800.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: 48),

                  Text(
                    AppConstants.kkn,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ).animate(delay: 900.ms).fadeIn(duration: 600.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBar extends StatefulWidget {
  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _anim.value,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Memuat...',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
