class QuestionModel {
  final String id;
  final String subject;     // 'math' | 'biology' | 'english'
  final String question;
  final List<String> options; // selalu 4 pilihan [A, B, C, D]
  final int correctAnswerIndex; // 0=A, 1=B, 2=C, 3=D
  final String explanation;
  final String? imageAsset;    // optional, untuk soal bergambar

  const QuestionModel({
    required this.id,
    required this.subject,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.imageAsset,
  });

  String get correctAnswer => options[correctAnswerIndex];

  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswerIndex;
}
