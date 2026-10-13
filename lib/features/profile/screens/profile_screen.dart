import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/student_provider.dart';
import '../../../common/widgets/custom_progress_bar.dart';
import '../../../common/widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProfileHeader()),
          SliverToBoxAdapter(child: _StatsSection()),
          SliverToBoxAdapter(child: _ProgressSection()),
          SliverToBoxAdapter(child: _ResetProgressSection()),
          SliverToBoxAdapter(child: _AboutSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final student = provider.student;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9B8FE0), Color(0xFF7C6FCD), Color(0xFF5A4FB0)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // Deco circles
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: -50,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                  child: Column(
                    children: [
                      // Avatar + edit
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 2.5),
                            ),
                            child: Center(
                              child: Text(student.avatarEmoji,
                                  style: const TextStyle(fontSize: 50)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _showEditProfile(context, provider),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: AppColors.softShadow,
                                ),
                                child: const Icon(Icons.edit_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .scale(duration: 500.ms, curve: Curves.elasticOut),

                      const SizedBox(height: 16),

                      Text(
                        student.name,
                        style: AppTextStyles.h1White.copyWith(fontSize: 26),
                      ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1),
                        ),
                        child: Text(
                          '🏆  ${student.levelTitle} • Level ${student.currentLevel}',
                          style:
                              AppTextStyles.label.copyWith(color: Colors.white),
                        ),
                      ).animate(delay: 200.ms).fadeIn(),
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

  void _showEditProfile(BuildContext context, StudentProvider provider) {
    final nameCtrl = TextEditingController(text: provider.student.name);
    String selectedAvatar = provider.student.avatarEmoji;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Edit Profil', style: AppTextStyles.h2),
              const SizedBox(height: 20),
              Text('Pilih Avatar', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppConstants.avatarOptions.map((e) {
                  final isSelected = e == selectedAvatar;
                  return GestureDetector(
                    onTap: () => setModalState(() => selectedAvatar = e),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: Center(
                        child: Text(e, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Nama Panggilan', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              TextField(
                controller: nameCtrl,
                textCapitalization: TextCapitalization.words,
                style: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Simpan',
                onPressed: () async {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    await provider.updateName(nameCtrl.text.trim());
                    await provider.updateAvatar(selectedAvatar);
                    if (ctx.mounted) Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stats Section ────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final s = provider.student;
        final stats = [
          {
            'label': 'Total XP',
            'value': '${s.totalXP}',
            'emoji': '⭐',
            'color': AppColors.accentYellow
          },
          {
            'label': 'Quiz Done',
            'value': '${s.totalQuizPlayed}',
            'emoji': '✅',
            'color': AppColors.success
          },
          {
            'label': 'Best Math',
            'value': '${s.highScoreMath}',
            'emoji': '🔢',
            'color': AppColors.mathColor
          },
          {
            'label': 'Best IPA',
            'value': '${s.highScoreBiology}',
            'emoji': '🌿',
            'color': AppColors.biologyColor
          },
        ];

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: stats.asMap().entries.map((e) {
              final color = e.value['color'] as Color;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(e.value['emoji']! as String,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(e.value['value']! as String,
                              style: AppTextStyles.h2.copyWith(color: color)),
                          Text(e.value['label']! as String,
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: 80 * e.key))
                  .slideY(begin: 0.3, duration: 400.ms)
                  .fadeIn();
            }).toList(),
          ),
        );
      },
    );
  }
}

// ─── Progress Section ─────────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final s = provider.student;
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                ],
              ),
              const SizedBox(height: 20),
              _ProgressItem(
                  label: '🔢 Matematika',
                  value: s.progressMath,
                  highScore: s.highScoreMath,
                  color: AppColors.mathColor),
              const SizedBox(height: 16),
              _ProgressItem(
                  label: '🌿 IPA',
                  value: s.progressBiology,
                  highScore: s.highScoreBiology,
                  color: AppColors.biologyColor),
              const SizedBox(height: 16),
              _ProgressItem(
                  label: '🗣️ Bahasa Inggris',
                  value: s.progressEnglish,
                  highScore: s.highScoreEnglish,
                  color: AppColors.englishColor),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String label;
  final double value;
  final int highScore;
  final Color color;

  const _ProgressItem({
    required this.label,
    required this.value,
    required this.highScore,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Best: $highScore',
                  style: AppTextStyles.caption
                      .copyWith(color: color, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 8),
            Text('${(value * 100).round()}%',
                style: AppTextStyles.label.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 8),
        CustomProgressBar(value: value, activeColor: color, height: 10),
      ],
    );
  }
}

// ─── Reset Progress Section ───────────────────────────────────────────────────

class _ResetProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(
            color: AppColors.error.withValues(alpha: 0.1), width: 1.5),
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
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Icon(Icons.delete_outline_rounded,
                        color: AppColors.error, size: 22)),
              ),
              const SizedBox(width: 12),
              Text('Data & Privasi', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Hapus semua skor, progress, dan XP. Nama dan avatar tetap tersimpan.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmReset(context),
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 18),
              label: Text('Hapus Data Progress',
                  style: AppTextStyles.label.copyWith(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.error, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Hapus & Keluar?', style: AppTextStyles.h2),
        content: Text(
          'Semua data termasuk nama, avatar, skor, XP, dan progress belajar akan dihapus. Kamu akan diarahkan ke halaman awal untuk membuat profil baru. Tindakan ini tidak bisa dibatalkan.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Batal',
                style: AppTextStyles.label.copyWith(color: AppColors.primary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await context.read<StudentProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.onboarding,
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Hapus & Keluar'),
          ),
        ],
      ),
    );
  }
}

// ─── About Section ────────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          // Header gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const Text('📱', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text('Tentang Aplikasi', style: AppTextStyles.h3White),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppConstants.appDescription,
                    style: AppTextStyles.bodyMedium),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                const _InfoRow(
                    emoji: '👨‍💻',
                    label: 'Developer & Ketua Kelompok',
                    value: AppConstants.developerName),
                const SizedBox(height: 10),
                const _InfoRow(
                    emoji: '👥',
                    label: 'Support Team',
                    value: AppConstants.teamName),
                const SizedBox(height: 10),
                const _InfoRow(
                    emoji: '🏫', label: 'Program', value: AppConstants.kkn),
                const SizedBox(height: 10),
                const _InfoRow(
                    emoji: '📌',
                    label: 'Versi Aplikasi',
                    value: 'v${AppConstants.appVersion}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _InfoRow(
      {required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
