import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../models/question_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/shared_preferences_service.dart';
import '../../../services/audio_service.dart';
import '../../../data/questions/math_questions.dart';
import '../../../data/questions/biology_questions.dart';
import '../../../data/questions/english_questions.dart';

enum QuizState { idle, inProgress, answered, finished }

class QuizController extends ChangeNotifier {
  final SharedPreferencesService _prefs;

  QuizController(this._prefs);

  // ─── State ────────────────────────────────────────────────────────────────────
  QuizState _state = QuizState.idle;
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int _selectedAnswerIndex = -1;
  int _correctCount = 0;
  String _currentSubject = '';
  List<bool> _answerResults = [];

  // ─── Getters ──────────────────────────────────────────────────────────────────
  QuizState get state => _state;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get correctCount => _correctCount;
  int get selectedAnswerIndex => _selectedAnswerIndex;
  String get currentSubject => _currentSubject;
  List<bool> get answerResults => List.unmodifiable(_answerResults);
  bool get isAnswered => _state == QuizState.answered;
  bool get isFinished => _state == QuizState.finished;

  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  double get progressValue =>
      _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length;

  int get score => totalQuestions == 0
      ? 0
      : ((_correctCount / totalQuestions) * 100).round();

  int get earnedXP =>
      (_correctCount * AppConstants.xpPerCorrectAnswer) +
      AppConstants.xpPerQuizComplete;

  // ─── Start Quiz ───────────────────────────────────────────────────────────────

  void startQuiz(String subject) {
    _currentSubject = subject;
    _currentIndex = 0;
    _correctCount = 0;
    _selectedAnswerIndex = -1;
    _answerResults = [];
    _state = QuizState.inProgress;
    _questions = _buildQuestions(subject);
    notifyListeners();
  }

  List<QuestionModel> _buildQuestions(String subject) {
    switch (subject) {
      case AppConstants.subjectMath:
        return _pickRandom(mathQuestions, AppConstants.questionsPerQuiz);
      case AppConstants.subjectBiology:
        return _pickRandom(biologyQuestions, AppConstants.questionsPerQuiz);
      case AppConstants.subjectEnglish:
        return _pickRandom(englishQuestions, AppConstants.questionsPerQuiz);
      case AppConstants.subjectAll:
        // Ambil 10 dari masing-masing mapel, lalu acak semua (total 30 soal)
        final picked = [
          ..._pickRandom(mathQuestions, 10),
          ..._pickRandom(biologyQuestions, 10),
          ..._pickRandom(englishQuestions, 10),
        ]..shuffle(Random());
        return picked;
      default:
        return _pickRandom(mathQuestions, AppConstants.questionsPerQuiz);
    }
  }

  List<QuestionModel> _pickRandom(List<QuestionModel> source, int count) {
    final pool = List<QuestionModel>.from(source)..shuffle(Random());
    return pool.take(count).toList();
  }

  // ─── Answer Question ──────────────────────────────────────────────────────────

  void selectAnswer(int index) {
    if (_state != QuizState.inProgress) return;

    _selectedAnswerIndex = index;
    _state = QuizState.answered;

    final isCorrect = currentQuestion!.isCorrect(index);
    if (isCorrect) {
      _correctCount++;
      AudioService.instance.playCorrect();
    } else {
      AudioService.instance.playWrong();
    }
    _answerResults.add(isCorrect);

    notifyListeners();
  }

  // ─── Next Question ────────────────────────────────────────────────────────────

  Future<void> nextQuestion() async {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswerIndex = -1;
      _state = QuizState.inProgress;
      notifyListeners();
    } else {
      await _finishQuiz();
      notifyListeners();
    }
  }

  // ─── Finish & Save ────────────────────────────────────────────────────────────

  Future<void> _finishQuiz() async {
    _state = QuizState.finished;

    AudioService.instance.playComplete();

    await _prefs.incrementQuizPlayed();

    // Quiz Final (subjectAll) tidak update high score / progress per-mapel
    if (_currentSubject != AppConstants.subjectAll) {
      await _prefs.updateHighScore(_currentSubject, score);
      final newProgress = score / 100.0;
      await _prefs.updateProgress(_currentSubject, newProgress);
    }

    final xpEarned = (_correctCount * AppConstants.xpPerCorrectAnswer) +
        AppConstants.xpPerQuizComplete;
    await _prefs.addXP(xpEarned);
  }

  // ─── Reset ────────────────────────────────────────────────────────────────────

  void reset() {
    _state = QuizState.idle;
    _questions = [];
    _currentIndex = 0;
    _selectedAnswerIndex = -1;
    _correctCount = 0;
    _answerResults = [];
    notifyListeners();
  }
}
