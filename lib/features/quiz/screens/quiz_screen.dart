import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../common/widgets/primary_button.dart';
import '../engine/quiz_controller.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  const QuizScreen({super.key, required this.subject});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizController>().startQuiz(widget.subject);
    });
  }

  @override
  void dispose() {
    // Ambil reference SEBELUM super.dispose() agar context masih valid
    final quizController = context.read<QuizController>();
    quizController.reset();
    super.dispose();
  }

  String get _subjectLabel {
    switch (widget.subject) {
      case AppConstants.subjectMath:
        return 'Matematika';
      case AppConstants.subjectBiology:
        return 'Biologi';
      case AppConstants.subjectEnglish:
        return 'Bahasa Inggris';
      case AppConstants.subjectAll:
        return 'Quiz Final';
      default:
        return 'Quiz';
    }
  }

  String get _subjectEmoji {
    switch (widget.subject) {
      case AppConstants.subjectMath:
        return '🔢';
      case AppConstants.subjectBiology:
        return '🌿';
      case AppConstants.subjectAll:
        return '🏆';
      default:
        return '🗣️';
    }
  }

  LinearGradient get _subjectGradient {
    switch (widget.subject) {
      case AppConstants.subjectMath:
        return AppColors.mathGradient;
      case AppConstants.subjectBiology:
        return AppColors.biologyGradient;
      case AppConstants.subjectAll:
        return AppColors.finalQuizGradient;
      default:
        return AppColors.englishGradient;
    }
  }

  Color get _subjectColor {
    switch (widget.subject) {
      case AppConstants.subjectMath:
        return AppColors.mathColor;
      case AppConstants.subjectBiology:
        return AppColors.biologyColor;
      case AppConstants.subjectAll:
        return const Color(0xFFFF7043);
      default:
        return AppColors.englishColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizController>(
      builder: (context, controller, _) {
        if (controller.isFinished) {
          return _QuizResultScreen(
            controller: controller,
            subject: widget.subject,
            subjectLabel: _subjectLabel,
            subjectEmoji: _subjectEmoji,
            subjectColor: _subjectColor,
            subjectGradient: _subjectGradient,
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: controller.currentQuestion == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Colored header with progress
                    _QuizHeader(
                      subjectLabel: _subjectLabel,
                      subjectEmoji: _subjectEmoji,
                      gradient: _subjectGradient,
                      controller: controller,
                      onExit: () => _confirmExit(context, controller),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          children: [
                            // Question card
                            _QuestionCard(
                              question: controller.currentQuestion!.question,
                              color: _subjectColor,
                              index: controller.currentIndex,
                            ),

                            const SizedBox(height: 16),

                            // Answer options
                            Expanded(
                              child: ListView.separated(
                                itemCount:
                                    controller.currentQuestion!.options.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  return _AnswerOption(
                                    index: index,
                                    text: controller
                                        .currentQuestion!.options[index],
                                    isSelected:
                                        controller.selectedAnswerIndex == index,
                                    isAnswered: controller.isAnswered,
                                    isCorrect: index ==
                                        controller.currentQuestion!
                                            .correctAnswerIndex,
                                    accentColor: _subjectColor,
                                    onTap: () => controller.selectAnswer(index),
                                  );
                                },
                              ),
                            ),

                            if (controller.isAnswered) ...[
                              const SizedBox(height: 10),
                              _ExplanationCard(
                                explanation:
                                    controller.currentQuestion!.explanation,
                                isCorrect: controller.currentQuestion!
                                    .isCorrect(controller.selectedAnswerIndex),
                              ).animate().slideY(
                                  begin: 0.4,
                                  duration: 300.ms,
                                  curve: Curves.easeOut),
                              const SizedBox(height: 10),
                              PrimaryButton(
                                text: controller.currentIndex <
                                        controller.totalQuestions - 1
                                    ? 'Soal Berikutnya →'
                                    : 'Lihat Hasil 🎉',
                                onPressed: () => controller.nextQuestion(),
                                backgroundColor: _subjectColor,
                              ).animate().slideY(begin: 0.3, duration: 300.ms),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _confirmExit(BuildContext context, QuizController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Keluar Quiz?', style: AppTextStyles.h2),
        content: Text(
          'Progress quiz ini tidak akan tersimpan. Yakin mau keluar?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Lanjut Quiz',
                style: AppTextStyles.label.copyWith(color: AppColors.primary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

// ─── Quiz Header ──────────────────────────────────────────────────────────────

class _QuizHeader extends StatelessWidget {
  final String subjectLabel;
  final String subjectEmoji;
  final LinearGradient gradient;
  final QuizController controller;
  final VoidCallback onExit;

  const _QuizHeader({
    required this.subjectLabel,
    required this.subjectEmoji,
    required this.gradient,
    required this.controller,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onExit,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('$subjectEmoji $subjectLabel',
                      style: AppTextStyles.h2White),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text('✅', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text('${controller.correctCount}',
                            style: AppTextStyles.label
                                .copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: controller.progressValue,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soal ${controller.currentIndex + 1} / ${controller.totalQuestions}',
                    style: AppTextStyles.caption
                        .copyWith(color: Colors.white.withValues(alpha: 0.85)),
                  ),
                  Text(
                    '${(controller.progressValue * 100).round()}%',
                    style: AppTextStyles.caption
                        .copyWith(color: Colors.white.withValues(alpha: 0.85)),
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

// ─── Question Card ────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final String question;
  final Color color;
  final int index;

  const _QuestionCard(
      {required this.question, required this.color, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
      ),
      child: Text(
        question,
        style: AppTextStyles.h2.copyWith(height: 1.55),
        textAlign: TextAlign.center,
      ),
    )
        .animate(key: ValueKey(index))
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.1);
  }
}

// ─── Answer Option ────────────────────────────────────────────────────────────

class _AnswerOption extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final Color accentColor;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.accentColor,
    required this.onTap,
  });

  static const _labels = ['A', 'B', 'C', 'D'];

  Color get _bgColor {
    if (!isAnswered)
      return isSelected ? accentColor.withValues(alpha: 0.08) : Colors.white;
    if (isCorrect) return AppColors.success.withValues(alpha: 0.08);
    if (isSelected && !isCorrect)
      return AppColors.error.withValues(alpha: 0.08);
    return Colors.white;
  }

  Color get _borderColor {
    if (!isAnswered) return isSelected ? accentColor : const Color(0xFFEEEBFF);
    if (isCorrect) return AppColors.success;
    if (isSelected && !isCorrect) return AppColors.error;
    return const Color(0xFFEEEBFF);
  }

  Color get _labelBg {
    if (!isAnswered)
      return isSelected ? accentColor : accentColor.withValues(alpha: 0.1);
    if (isCorrect) return AppColors.success;
    if (isSelected && !isCorrect) return AppColors.error;
    return accentColor.withValues(alpha: 0.1);
  }

  Color get _labelColor {
    if (!isAnswered) return isSelected ? Colors.white : accentColor;
    if (isCorrect) return Colors.white;
    if (isSelected && !isCorrect) return Colors.white;
    return accentColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor, width: 2),
        boxShadow: AppColors.softShadow,
      ),
      child: InkWell(
        onTap: isAnswered ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _labelBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(_labels[index],
                      style: AppTextStyles.label.copyWith(color: _labelColor)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
              if (isAnswered && isCorrect)
                const Text('✅', style: TextStyle(fontSize: 18)),
              if (isAnswered && isSelected && !isCorrect)
                const Text('❌', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 50 * index))
        .slideX(begin: 0.15, duration: 300.ms, curve: Curves.easeOut)
        .fadeIn();
  }
}

// ─── Explanation Card ─────────────────────────────────────────────────────────

class _ExplanationCard extends StatelessWidget {
  final String explanation;
  final bool isCorrect;

  const _ExplanationCard({required this.explanation, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCorrect
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isCorrect ? '🎉' : '💡', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Hebat! Jawaban Benar!' : 'Yuk Belajar Lagi!',
                  style: AppTextStyles.label.copyWith(
                      color: isCorrect ? AppColors.success : AppColors.error),
                ),
                const SizedBox(height: 4),
                Text(explanation, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quiz Result Screen ───────────────────────────────────────────────────────

class _QuizResultScreen extends StatelessWidget {
  final QuizController controller;
  final String subject;
  final String subjectLabel;
  final String subjectEmoji;
  final Color subjectColor;
  final LinearGradient subjectGradient;

  const _QuizResultScreen({
    required this.controller,
    required this.subject,
    required this.subjectLabel,
    required this.subjectEmoji,
    required this.subjectColor,
    required this.subjectGradient,
  });

  String get _resultEmoji {
    final s = controller.score;
    if (s >= 80) return '🏆';
    if (s >= 60) return '⭐';
    if (s >= 40) return '💪';
    return '📚';
  }

  String get _resultMessage {
    final s = controller.score;
    if (s >= 80) return 'Luar Biasa!';
    if (s >= 60) return 'Bagus Sekali!';
    if (s >= 40) return 'Sudah Baik!';
    return 'Jangan Menyerah!';
  }

  String get _resultSub {
    final s = controller.score;
    if (s >= 80) return 'Kamu keren banget 🌟';
    if (s >= 60) return 'Terus semangat berlatih!';
    if (s >= 40) return 'Sedikit lagi bisa lebih bagus!';
    return 'Belajar lagi yuk, kamu pasti bisa!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header gradient
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: subjectGradient,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
                  child: Column(
                    children: [
                      Text(_resultEmoji, style: const TextStyle(fontSize: 80))
                          .animate()
                          .scale(duration: 700.ms, curve: Curves.elasticOut),
                      const SizedBox(height: 16),
                      Text(
                        _resultMessage,
                        style: AppTextStyles.displayMedium
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),
                      const SizedBox(height: 6),
                      Text(
                        _resultSub,
                        style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white.withValues(alpha: 0.85)),
                        textAlign: TextAlign.center,
                      ).animate(delay: 300.ms).fadeIn(),
                      const SizedBox(height: 8),
                      Text(
                        '$subjectEmoji $subjectLabel',
                        style: AppTextStyles.label.copyWith(
                            color: Colors.white.withValues(alpha: 0.75)),
                      ).animate(delay: 350.ms).fadeIn(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Score card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    // Big score
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${controller.score}',
                            style: AppTextStyles.displayLarge.copyWith(
                              fontSize: 72,
                              color: subjectColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('/100',
                                style: AppTextStyles.h2
                                    .copyWith(color: AppColors.textHint)),
                          ),
                        ],
                      ),
                    )
                        .animate(delay: 400.ms)
                        .scale(begin: const Offset(0.8, 0.8))
                        .fadeIn(),
                    // Stats row
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                              label: 'Benar',
                              value: '${controller.correctCount}',
                              emoji: '✅',
                              color: AppColors.success),
                          Container(
                              width: 1,
                              height: 40,
                              color: AppColors.textHint.withValues(alpha: 0.3)),
                          _StatItem(
                              label: 'Salah',
                              value:
                                  '${controller.totalQuestions - controller.correctCount}',
                              emoji: '❌',
                              color: AppColors.error),
                          Container(
                              width: 1,
                              height: 40,
                              color: AppColors.textHint.withValues(alpha: 0.3)),
                          _StatItem(
                              label: 'XP',
                              value: '+${controller.earnedXP}',
                              emoji: '⭐',
                              color: AppColors.accentYellow),
                        ],
                      ),
                    ).animate(delay: 500.ms).fadeIn(),
                  ],
                ),
              ).animate(delay: 400.ms).slideY(begin: 0.3).fadeIn(),
            ),
          ),

          // Answer dots
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rekap Jawaban', style: AppTextStyles.label),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          controller.answerResults.asMap().entries.map((e) {
                        return Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: e.value
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  e.value ? AppColors.success : AppColors.error,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${e.key + 1}',
                              style: AppTextStyles.caption.copyWith(
                                color: e.value
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 600.ms).fadeIn(),
          ),

          // Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Ulangi Quiz 🔄',
                    onPressed: () =>
                        context.read<QuizController>().startQuiz(subject),
                    backgroundColor: subjectColor,
                  ).animate(delay: 700.ms).slideY(begin: 0.3).fadeIn(),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Kembali ke Home',
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.home, (route) => false),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.75),
                  ).animate(delay: 800.ms).slideY(begin: 0.3).fadeIn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  final Color color;

  const _StatItem(
      {required this.label,
      required this.value,
      required this.emoji,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h2.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
