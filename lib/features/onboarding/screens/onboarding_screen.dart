import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/shared_preferences_service.dart';
import '../../../services/student_provider.dart';
import '../../../common/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  String _selectedAvatar = AppConstants.avatarOptions[0];
  final _nameController = TextEditingController();
  bool _isLoading = false;

  final _pages = const [
    _OnboardingData(
      emoji: '📚',
      title: 'Selamat Datang di\nKuis Pintar!',
      subtitle: 'Belajar jadi seru dan menyenangkan bersama teman-teman!',
      bgColor: Color(0xFFEDE9FF),
      accentColor: Color(0xFF7C6FCD),
    ),
    _OnboardingData(
      emoji: '🎯',
      title: 'Belajar 3 Mata\nPelajaran Seru!',
      subtitle:
          'Matematika, Ipa, dan Bahasa Inggris\ntersedia dengan cara yang fun!',
      bgColor: Color(0xFFFFEEF2),
      accentColor: Color(0xFFFF6B8A),
    ),
    _OnboardingData(
      emoji: '🏆',
      title: 'Kumpulkan XP &\nNaik Level!',
      subtitle: 'Jawab quiz, raih bintang, dan jadilah\npelajar super terbaik!',
      bgColor: Color(0xFFE8F8F1),
      accentColor: Color(0xFF43C47F),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Masukkan namamu dulu ya! 😊',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = context.read<SharedPreferencesService>();
      final studentProvider = context.read<StudentProvider>();

      await prefs.saveStudentName(name);
      await prefs.saveStudentAvatar(_selectedAvatar);
      await prefs.setOnboardingDone(true);
      await studentProvider.loadStudent();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (_) {
      // Jika terjadi error, pastikan tombol tidak stuck loading
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          ..._pages.asMap().entries.map((e) => _OnboardingPage(
                data: e.value,
                isLast: false,
                onNext: _nextPage,
                currentPage: _currentPage,
                totalPages: _pages.length + 1,
                pageController: _pageController,
              )),
          // Halaman terakhir: input nama
          _ProfileSetupPage(
            nameController: _nameController,
            selectedAvatar: _selectedAvatar,
            onAvatarSelected: (emoji) =>
                setState(() => _selectedAvatar = emoji),
            onFinish: _finishOnboarding,
            isLoading: _isLoading,
            currentPage: _currentPage,
            totalPages: _pages.length + 1,
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}

// ─── Data model onboarding ────────────────────────────────────────────────────

class _OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;

  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
  });
}

// ─── Halaman onboarding biasa ─────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final bool isLast;
  final VoidCallback onNext;
  final int currentPage;
  final int totalPages;
  final PageController pageController;

  const _OnboardingPage({
    required this.data,
    required this.isLast,
    required this.onNext,
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.bgColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Skip button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    pageController.animateToPage(
                      totalPages - 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    'Lewati',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: data.accentColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Ilustrasi emoji besar
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: data.accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    data.emoji,
                    style: const TextStyle(fontSize: 90),
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 48),

              Text(
                data.title,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: 200.ms)
                  .slideY(begin: 0.3, duration: 400.ms)
                  .fadeIn(),

              const SizedBox(height: 16),

              Text(
                data.subtitle,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              )
                  .animate(delay: 350.ms)
                  .slideY(begin: 0.3, duration: 400.ms)
                  .fadeIn(),

              const Spacer(),

              // Indicator dots
              SmoothPageIndicator(
                controller: pageController,
                count: totalPages,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: data.accentColor,
                  dotColor: data.accentColor.withValues(alpha: 0.2),
                  spacing: 10,
                ),
              ),

              const SizedBox(height: 28),

              PrimaryButton(
                text: 'Lanjut →',
                onPressed: onNext,
                backgroundColor: data.accentColor,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Halaman setup profil (terakhir) ─────────────────────────────────────────

class _ProfileSetupPage extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedAvatar;
  final ValueChanged<String> onAvatarSelected;
  final VoidCallback onFinish;
  final bool isLoading;
  final int currentPage;
  final int totalPages;
  final PageController pageController;

  const _ProfileSetupPage({
    required this.nameController,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    required this.onFinish,
    required this.isLoading,
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F2FF),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Text('Siapa namamu? 👋', style: AppTextStyles.displayMedium)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.2),

              const SizedBox(height: 8),
              Text(
                'Pilih avatar dan masukkan namamu untuk mulai belajar!',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ).animate(delay: 100.ms).fadeIn(duration: 500.ms),

              const SizedBox(height: 36),

              // Avatar picker
              Text('Pilih Avatarmu', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children: AppConstants.avatarOptions.map((emoji) {
                  final isSelected = emoji == selectedAvatar;
                  return GestureDetector(
                    onTap: () => onAvatarSelected(emoji),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).animate(delay: 200.ms).fadeIn(duration: 500.ms),

              const SizedBox(height: 36),

              // Input nama
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Nama Panggilanmu', style: AppTextStyles.h3),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  hintText: 'Contoh: Andi, Siti, Budi...',
                  hintStyle: AppTextStyles.bodyMedium,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFFEEEBFF), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 14, right: 8),
                    child: Text('✏️', style: TextStyle(fontSize: 20)),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 0,
                  ),
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 500.ms),

              const SizedBox(height: 40),

              // Indicator dots
              SmoothPageIndicator(
                controller: pageController,
                count: totalPages,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.primary.withValues(alpha: 0.2),
                  spacing: 10,
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Mulai Belajar! 🚀',
                onPressed: onFinish,
                isLoading: isLoading,
              ).animate(delay: 400.ms).fadeIn(duration: 500.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
