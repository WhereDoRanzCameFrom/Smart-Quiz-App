import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'services/shared_preferences_service.dart';
import 'services/student_provider.dart';
import 'services/audio_service.dart';
import 'features/quiz/engine/quiz_controller.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/home/screens/main_shell.dart';
import 'features/quiz/screens/quiz_screen.dart';
import 'features/lesson/screens/lesson_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation ke portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Init SharedPreferences
  final prefs = await SharedPreferencesService.getInstance();

  // Mulai backsound
  await AudioService.instance.startBacksound();

  runApp(BimbelApp(prefs: prefs));
}

class BimbelApp extends StatefulWidget {
  final SharedPreferencesService prefs;

  const BimbelApp({super.key, required this.prefs});

  @override
  State<BimbelApp> createState() => _BimbelAppState();
}

class _BimbelAppState extends State<BimbelApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioService.instance.dispose();
    super.dispose();
  }

  /// Pause backsound saat app di-minimize, resume saat kembali ke foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      AudioService.instance.pauseBacksound();
    } else if (state == AppLifecycleState.resumed) {
      AudioService.instance.resumeBacksound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // SharedPreferencesService sebagai singleton (sudah diinit di main)
        Provider<SharedPreferencesService>.value(value: widget.prefs),

        // StudentProvider — global state data siswa
        ChangeNotifierProvider<StudentProvider>(
          create: (_) => StudentProvider(widget.prefs),
        ),

        // QuizController — engine quiz
        ChangeNotifierProvider<QuizController>(
          create: (_) => QuizController(widget.prefs),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fadeRoute(const SplashScreen(), settings);

      case AppRoutes.onboarding:
        return _slideRoute(const OnboardingScreen(), settings);

      case AppRoutes.home:
        return _fadeRoute(const MainShell(), settings);

      case AppRoutes.lesson:
        return _slideRoute(const LessonScreen(), settings);

      case AppRoutes.profile:
        return _slideRoute(const ProfileScreen(), settings);

      case AppRoutes.quiz:
        final subject = settings.arguments as String? ??
            AppConstants.subjectMath;
        return _slideRoute(QuizScreen(subject: subject), settings);

      default:
        return _fadeRoute(const SplashScreen(), settings);
    }
  }

  static PageRoute<T> _fadeRoute<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRoute<T> _slideRoute<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return SlideTransition(position: offset, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}