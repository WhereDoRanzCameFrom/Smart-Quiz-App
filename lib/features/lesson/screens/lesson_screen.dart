import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../common/widgets/custom_app_bar.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Materi Pelajaran 📖',
        actions: [],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.softShadow,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: AppTextStyles.label
                  .copyWith(color: Colors.white, fontSize: 12),
              unselectedLabelStyle: AppTextStyles.label.copyWith(
                color: AppColors.textHint,
                fontSize: 12,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textHint,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: '🔢 Matematika'),
                Tab(text: '🌿 IPA'),
                Tab(text: '🗣️ B. Inggris'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _LessonTabContent(
                  subject: AppConstants.subjectMath,
                  color: AppColors.mathColor,
                  gradient: AppColors.mathGradient,
                ),
                _LessonTabContent(
                  subject: AppConstants.subjectBiology,
                  color: AppColors.biologyColor,
                  gradient: AppColors.biologyGradient,
                ),
                _LessonTabContent(
                  subject: AppConstants.subjectEnglish,
                  color: AppColors.englishColor,
                  gradient: AppColors.englishGradient,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab Content ──────────────────────────────────────────────────────────────

class _LessonTabContent extends StatelessWidget {
  final String subject;
  final Color color;
  final LinearGradient gradient;

  const _LessonTabContent({
    required this.subject,
    required this.color,
    required this.gradient,
  });

  List<_LessonData> get _lessons => _getLessons(subject);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        return _LessonCard(
          data: _lessons[index],
          color: color,
          gradient: gradient,
          index: index,
        );
      },
    );
  }
}

// ─── Lesson Card ──────────────────────────────────────────────────────────────

class _LessonCard extends StatefulWidget {
  final _LessonData data;
  final Color color;
  final LinearGradient gradient;
  final int index;

  const _LessonCard({
    required this.data,
    required this.color,
    required this.gradient,
    required this.index,
  });

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isExpanded
                  ? widget.color.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            children: [
              // Header
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: _isExpanded ? widget.gradient : null,
                  color: _isExpanded ? null : Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(20),
                    bottom: _isExpanded ? Radius.zero : const Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _isExpanded
                            ? Colors.white.withValues(alpha: 0.25)
                            : widget.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          widget.data.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.title,
                            style: _isExpanded ? AppTextStyles.h3White : AppTextStyles.h3,
                          ),
                          Text(
                            widget.data.subtitle,
                            style: _isExpanded ? AppTextStyles.bodyWhite : AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _isExpanded ? Colors.white : widget.color,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded content
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                          color: widget.color.withValues(alpha: 0.2),
                          height: 1),
                      const SizedBox(height: 14),
                      ...widget.data.points.map(
                        (point) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: widget.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  point,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.data.formula != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.color.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            widget.data.formula!,
                            style: AppTextStyles.h3.copyWith(
                              color: widget.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn(duration: 250.ms),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: 60 * widget.index))
            .slideY(
              begin: 0.3,
              duration: 400.ms,
              curve: Curves.easeOut,
            )
            .fadeIn(),
      ),
    );
  }
}

// ─── Lesson Data ──────────────────────────────────────────────────────────────

class _LessonData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<String> points;
  final String? formula;

  const _LessonData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.points,
    this.formula,
  });
}

List<_LessonData> _getLessons(String subject) {
  switch (subject) {
    case AppConstants.subjectMath:
      return _mathLessons;
    case AppConstants.subjectBiology:
      return _biologyLessons;
    default:
      return _englishLessons;
  }
}

// ─── Materi Matematika ────────────────────────────────────────────────────────
// Sesuai soal: penjumlahan dan pengurangan bilangan dasar (1–10)

const _mathLessons = [
  _LessonData(
    emoji: '➕',
    title: 'Penjumlahan Dasar',
    subtitle: 'Menjumlahkan dua bilangan',
    points: [
      '2 + 3 = 5 (bayangkan 2 apel ditambah 3 apel jadi 5 apel 🍎)',
      '4 + 6 = 10 (sepuluh jari tanganmu adalah 4 + 6 ✋)',
      '3 + 7 = 10 (tiga kelompok dan tujuh benda, pas sepuluh! 🖐️)',
      'Cara mudah: hitung maju dari bilangan yang lebih besar.',
    ],
    formula: '2+3=5  |  4+6=10  |  3+7=10',
  ),
  _LessonData(
    emoji: '➖',
    title: 'Pengurangan Dasar',
    subtitle: 'Mengurangi satu bilangan dari bilangan lain',
    points: [
      '5 - 3 = 2 (punya 5 kue, dimakan 3, sisa 2 kue 🍰)',
      '8 - 5 = 3 (dari angka 8, mundur 5 langkah, sampai di angka 3 👣)',
      'Cara mudah: hitung mundur dari bilangan yang dikurangi.',
      'Cek jawabanmu: hasil + pengurang = bilangan awal. (2 + 3 = 5 ✅)',
    ],
    formula: '5-3=2  |  8-5=3',
  ),
  _LessonData(
    emoji: '🔢',
    title: 'Tips Berhitung Cepat',
    subtitle: 'Trik mudah penjumlahan dan pengurangan',
    points: [
      'Gunakan jari tanganmu untuk menghitung bilangan kecil.',
      'Untuk penjumlahan besar, pecah menjadi bagian kecil. Contoh: 7+6 = 7+3+3 = 13.',
      'Ingat pasangan 10: 1+9, 2+8, 3+7, 4+6, 5+5.',
      'Pengurangan adalah kebalikan penjumlahan: jika 4+6=10, maka 10-6=4.',
    ],
    formula: 'Pasangan 10: 1+9, 2+8, 3+7, 4+6, 5+5',
  ),
];

// ─── Materi IPA ───────────────────────────────────────────────────────────────
// Sesuai soal: bagian-bagian tumbuhan (akar, batang, daun, bunga, buah/biji)

const _biologyLessons = [
  _LessonData(
    emoji: '🌱',
    title: 'Akar Tumbuhan',
    subtitle: 'Bagian paling bawah yang ada di dalam tanah',
    points: [
      'Akar berfungsi menyerap air dan mineral dari dalam tanah.',
      'Akar juga menopang tumbuhan agar tidak roboh.',
      'Beberapa tumbuhan menyimpan cadangan makanan di akar (wortel, singkong).',
      'Jenis akar: akar tunggang (satu akar besar) dan akar serabut (banyak akar kecil).',
    ],
    formula: 'Akar → menyerap air & mineral dari tanah',
  ),
  _LessonData(
    emoji: '🌿',
    title: 'Batang Tumbuhan',
    subtitle: 'Penopang dan jalur transportasi tumbuhan',
    points: [
      'Batang berfungsi menopang dan menegakkan tumbuhan.',
      'Batang menjadi jalur pengangkut air dari akar ke daun (pembuluh xilem).',
      'Batang juga mengangkut hasil fotosintesis dari daun ke seluruh tubuh (pembuluh floem).',
      'Beberapa tumbuhan menyimpan makanan di batang (tebu, sagu).',
    ],
    formula: 'Akar → Batang → Daun (air & mineral naik)',
  ),
  _LessonData(
    emoji: '🍃',
    title: 'Daun Tumbuhan',
    subtitle: 'Tempat tumbuhan membuat makanan',
    points: [
      'Daun adalah tempat fotosintesis, yaitu proses tumbuhan membuat makanan.',
      'Fotosintesis membutuhkan cahaya matahari, air (H₂O), dan CO₂ dari udara.',
      'Hasil fotosintesis adalah glukosa (makanan tumbuhan) dan oksigen (O₂).',
      'Warna hijau daun berasal dari klorofil yang menyerap energi cahaya matahari.',
    ],
    formula: 'CO₂ + H₂O + Cahaya → Glukosa + O₂',
  ),
  _LessonData(
    emoji: '🌸',
    title: 'Bunga Tumbuhan',
    subtitle: 'Alat perkembangbiakan tumbuhan',
    points: [
      'Bunga adalah alat perkembangbiakan generatif pada tumbuhan.',
      'Mahkota bunga berwarna-warni berfungsi menarik serangga (kupu-kupu, lebah) agar terjadi penyerbukan.',
      'Bagian bunga: kelopak (pelindung), mahkota (penarik serangga), benang sari (jantan), putik (betina).',
      'Setelah terjadi pembuahan, bunga berkembang menjadi buah.',
    ],
    formula: 'Mahkota bunga → menarik serangga → penyerbukan',
  ),
  _LessonData(
    emoji: '🍎',
    title: 'Buah dan Biji',
    subtitle: 'Hasil pembuahan dan penyebar benih',
    points: [
      'Buah terbentuk dari bakal buah setelah terjadi pembuahan.',
      'Di dalam buah terdapat biji yang merupakan calon tumbuhan baru.',
      'Buah melindungi biji dari kerusakan dan membantu penyebarannya.',
      'Biji bisa disebarkan oleh angin, air, hewan, atau manusia.',
      'Jika biji ditanam di tanah yang subur dengan cukup air dan cahaya, biji akan berkecambah dan tumbuh.',
    ],
    formula: 'Bunga → Buah → Biji → Tumbuhan Baru',
  ),
];

// ─── Materi Bahasa Inggris ────────────────────────────────────────────────────
// Sesuai soal: hobi (hobby) dalam Bahasa Inggris

const _englishLessons = [
  _LessonData(
    emoji: '🎯',
    title: 'Hobby (Hobi)',
    subtitle: 'Kegiatan yang kita sukai dan sering lakukan',
    points: [
      'Hobby adalah kegiatan yang kita lakukan di waktu luang karena kita menyukainya.',
      'Cara menanyakan hobi: "What is your hobby?" atau "What do you like to do?"',
      'Cara menjawab: "My hobby is ..." atau "I like ..." atau "I love ..."',
      'Contoh: "My hobby is reading." / "I like cooking." / "I love singing."',
    ],
    formula: 'What is your hobby? → My hobby is ...',
  ),
  _LessonData(
    emoji: '📖',
    title: 'Reading (Membaca)',
    subtitle: 'Hobi membaca buku',
    points: [
      'Reading = membaca. Orang yang suka membaca sering punya buku (book).',
      'Contoh kalimat: "I have a new book. My hobby is reading."',
      'Alat yang dibutuhkan: book (buku), magazine (majalah), newspaper (koran).',
      'Reading membuat kita lebih pintar dan menambah pengetahuan.',
    ],
    formula: 'book → reading (membaca)',
  ),
  _LessonData(
    emoji: '⚽',
    title: 'Playing Football (Sepak Bola)',
    subtitle: 'Hobi bermain sepak bola',
    points: [
      'Football = sepak bola. Dimainkan dengan menendang bola (ball) ke gawang.',
      'Contoh kalimat: "Roni loves playing football. He needs a ball."',
      'Alat yang dibutuhkan: ball (bola).',
      'Kata kerja terkait: play (bermain), kick (menendang), run (berlari).',
    ],
    formula: 'football → needs a ball (bola)',
  ),
  _LessonData(
    emoji: '🍳',
    title: 'Cooking (Memasak)',
    subtitle: 'Hobi memasak makanan di dapur',
    points: [
      'Cooking = memasak. Kegiatan yang dilakukan di kitchen (dapur).',
      'Contoh kalimat: "Sinta likes cooking in the kitchen. She makes fried rice."',
      'Fried rice = nasi goreng. Cook = juru masak.',
      'Kata kerja terkait: cook (memasak), fry (menggoreng), boil (merebus).',
    ],
    formula: 'cooking → done in the kitchen (dapur)',
  ),
  _LessonData(
    emoji: '✏️',
    title: 'Drawing & Singing',
    subtitle: 'Menggambar dan bernyanyi',
    points: [
      'Drawing = menggambar. Menggunakan pencil (pensil) dan paper (kertas).',
      'Contoh: "Tania uses a pencil and paper to make a picture. Her hobby is drawing."',
      'Singing = bernyanyi. Berkaitan dengan music (musik) dan songs (lagu-lagu).',
      'Contoh: "Maya likes singing because she loves music and songs."',
    ],
    formula: 'pencil + paper → drawing  |  music + songs → singing',
  ),
];
