import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/student_provider.dart';
import '../../../common/widgets/learning_card.dart';
import '../../../common/widgets/custom_progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().refreshStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroHeader()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text('Pilih Pelajaran', style: AppTextStyles.h2),
            ),
          ),
          const SliverToBoxAdapter(child: _SubjectGrid()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text('Mulai Aktivitas', style: AppTextStyles.h2),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _FeatureCards(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Header ──────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final student = provider.student;
        final xp = student.totalXP;
        final nextLevelXP = _nextLevelXP(student.currentLevel);
        // Level 5 adalah max level — progress bar penuh
        final isMaxLevel = student.currentLevel >= 5;
        final progress = isMaxLevel
            ? 1.0
            : (nextLevelXP > 0 ? (xp / nextLevelXP).clamp(0.0, 1.0) : 1.0);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9B8FE0), Color(0xFF7C6FCD), Color(0xFF6A5BC2)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
          ),
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // Deco circles
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08)),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: avatar + XP
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(student.avatarEmoji,
                                  style: const TextStyle(fontSize: 28)),
                            ),
                          ).animate().scale(
                              duration: 400.ms, curve: Curves.elasticOut),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, ${student.name} 👋',
                                  style: AppTextStyles.h2White,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  student.levelTitle,
                                  style: AppTextStyles.bodyWhite,
                                ),
                              ],
                            )
                                .animate(delay: 100.ms)
                                .slideX(begin: -0.2)
                                .fadeIn(),
                          ),
                          // XP badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('⭐', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 5),
                                Text('${student.totalXP} XP',
                                    style: AppTextStyles.label
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                          )
                              .animate(delay: 200.ms)
                              .scale(curve: Curves.elasticOut),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Level progress card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Level ${student.currentLevel}',
                                    style: AppTextStyles.h2White),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text('🏆  ${student.levelTitle}',
                                      style: AppTextStyles.caption
                                          .copyWith(color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            WhiteProgressBar(value: progress),
                            const SizedBox(height: 6),
                            Text(
                              isMaxLevel
                                  ? '🏆 Level Maksimal! Total: $xp XP'
                                  : '$xp / $nextLevelXP XP ke level berikutnya',
                              style: AppTextStyles.caption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.75)),
                            ),
                          ],
                        ),
                      )
                          .animate(delay: 150.ms)
                          .slideY(begin: 0.3, duration: 500.ms)
                          .fadeIn(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _nextLevelXP(int level) {
    switch (level) {
      case 1:
        return 100;
      case 2:
        return 250;
      case 3:
        return 500;
      case 4:
        return 800;
      default:
        return 1000; // level 5 = max, tampilkan progress penuh
    }
  }
}

// ─── Subject Grid ─────────────────────────────────────────────────────────────

class _SubjectGrid extends StatelessWidget {
  const _SubjectGrid();

  static const _subjects = [
    {'label': 'Matematika', 'emoji': '🔢', 'subject': AppConstants.subjectMath},
    {'label': 'IPA', 'emoji': '🌿', 'subject': AppConstants.subjectBiology},
    {
      'label': 'B. Inggris',
      'emoji': '🗣️',
      'subject': AppConstants.subjectEnglish
    },
  ];

  LinearGradient _gradient(String subject) {
    switch (subject) {
      case AppConstants.subjectMath:
        return AppColors.mathGradient;
      case AppConstants.subjectBiology:
        return AppColors.biologyGradient;
      default:
        return AppColors.englishGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _subjects.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : 6,
                right: i == _subjects.length - 1 ? 0 : 6,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.quiz,
                    arguments: s['subject']),
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: _gradient(s['subject']!),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: (_gradient(s['subject']!).colors.last)
                            .withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(s['emoji']!,
                                style: const TextStyle(fontSize: 34)),
                            const SizedBox(height: 8),
                            Text(
                              s['label']!,
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: Duration(milliseconds: 80 * i))
                  .slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOut)
                  .fadeIn(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Feature Cards ────────────────────────────────────────────────────────────

class _FeatureCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LearningCard(
          title: 'Materi Pelajaran',
          subtitle: 'Baca ringkasan materi seru!',
          emoji: '📖',
          gradient: AppColors.primaryGradient,
          onTap: () => Navigator.pushNamed(context, AppRoutes.lesson),
        )
            .animate(delay: 100.ms)
            .slideX(begin: -0.2, duration: 400.ms, curve: Curves.easeOut)
            .fadeIn(),
        const SizedBox(height: 14),
        LearningCard(
          title: 'Quiz Final',
          subtitle: '30 soal dari semua pelajaran, diacak!',
          emoji: '🏆',
          gradient: AppColors.finalQuizGradient,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.quiz,
            arguments: AppConstants.subjectAll,
          ),
        )
            .animate(delay: 150.ms)
            .slideX(begin: -0.2, duration: 400.ms, curve: Curves.easeOut)
            .fadeIn(),
        const SizedBox(height: 14),
        _ProgressSummaryCard()
            .animate(delay: 200.ms)
            .slideX(begin: 0.2, duration: 400.ms, curve: Curves.easeOut)
            .fadeIn(),
      ],
    );
  }
}

// ─── Progress Summary Card ────────────────────────────────────────────────────

class _ProgressSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final s = provider.student;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('📊', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 12),
                  Text('Progress Belajar', style: AppTextStyles.h3),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${s.totalQuizPlayed} Quiz',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ProgressRow(
                  label: '🔢 Matematika',
                  value: s.progressMath,
                  color: AppColors.mathColor),
              const SizedBox(height: 14),
              _ProgressRow(
                  label: '🌿 IPA',
                  value: s.progressBiology,
                  color: AppColors.biologyColor),
              const SizedBox(height: 14),
              _ProgressRow(
                  label: '🗣️ B. Inggris',
                  value: s.progressEnglish,
                  color: AppColors.englishColor),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ProgressRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text(
              '${(value * 100).round()}%',
              style: AppTextStyles.label.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        CustomProgressBar(value: value, activeColor: color),
      ],
    );
  }
}
