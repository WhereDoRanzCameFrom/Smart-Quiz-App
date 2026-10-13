import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/student_model.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _prefs;

  SharedPreferencesService._();

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // ─── Onboarding ─────────────────────────────────────────────────────────────

  Future<void> setOnboardingDone(bool done) async {
    await _prefs!.setBool(AppConstants.keyIsOnboardingDone, done);
  }

  bool get isOnboardingDone =>
      _prefs!.getBool(AppConstants.keyIsOnboardingDone) ?? false;

  // ─── Student Profile ─────────────────────────────────────────────────────────

  Future<void> saveStudentName(String name) async {
    await _prefs!.setString(AppConstants.keyStudentName, name);
  }

  String get studentName =>
      _prefs!.getString(AppConstants.keyStudentName) ?? 'Siswa';

  Future<void> saveStudentAvatar(String emoji) async {
    await _prefs!.setString(AppConstants.keyStudentAvatar, emoji);
  }

  String get studentAvatar =>
      _prefs!.getString(AppConstants.keyStudentAvatar) ?? '🐱';

  // ─── Load full StudentModel ───────────────────────────────────────────────────

  StudentModel loadStudent() {
    return StudentModel(
      name: studentName,
      avatarEmoji: studentAvatar,
      totalQuizPlayed: _prefs!.getInt(AppConstants.keyTotalQuizPlayed) ?? 0,
      highScoreMath: _prefs!.getInt(AppConstants.keyHighScoreMath) ?? 0,
      highScoreBiology: _prefs!.getInt(AppConstants.keyHighScoreBiology) ?? 0,
      highScoreEnglish: _prefs!.getInt(AppConstants.keyHighScoreEnglish) ?? 0,
      progressMath: _prefs!.getDouble(AppConstants.keyProgressMath) ?? 0.0,
      progressBiology:
          _prefs!.getDouble(AppConstants.keyProgressBiology) ?? 0.0,
      progressEnglish:
          _prefs!.getDouble(AppConstants.keyProgressEnglish) ?? 0.0,
      currentLevel: _prefs!.getInt(AppConstants.keyCurrentLevel) ?? 1,
      totalXP: _prefs!.getInt(AppConstants.keyTotalXP) ?? 0,
    );
  }

  // ─── Quiz Stats ───────────────────────────────────────────────────────────────

  Future<void> incrementQuizPlayed() async {
    final current = _prefs!.getInt(AppConstants.keyTotalQuizPlayed) ?? 0;
    await _prefs!.setInt(AppConstants.keyTotalQuizPlayed, current + 1);
  }

  Future<void> updateHighScore(String subject, int score) async {
    final key = _highScoreKey(subject);
    final current = _prefs!.getInt(key) ?? 0;
    if (score > current) {
      await _prefs!.setInt(key, score);
    }
  }

  int getHighScore(String subject) {
    return _prefs!.getInt(_highScoreKey(subject)) ?? 0;
  }

  String _highScoreKey(String subject) {
    switch (subject) {
      case AppConstants.subjectMath:
        return AppConstants.keyHighScoreMath;
      case AppConstants.subjectBiology:
        return AppConstants.keyHighScoreBiology;
      case AppConstants.subjectEnglish:
        return AppConstants.keyHighScoreEnglish;
      default:
        return AppConstants.keyHighScoreMath;
    }
  }

  // ─── Progress ─────────────────────────────────────────────────────────────────

  Future<void> updateProgress(String subject, double progress) async {
    final key = _progressKey(subject);
    final current = _prefs!.getDouble(key) ?? 0.0;
    // Progress hanya bisa naik
    if (progress > current) {
      await _prefs!.setDouble(key, progress.clamp(0.0, 1.0));
    }
  }

  double getProgress(String subject) {
    return _prefs!.getDouble(_progressKey(subject)) ?? 0.0;
  }

  String _progressKey(String subject) {
    switch (subject) {
      case AppConstants.subjectMath:
        return AppConstants.keyProgressMath;
      case AppConstants.subjectBiology:
        return AppConstants.keyProgressBiology;
      case AppConstants.subjectEnglish:
        return AppConstants.keyProgressEnglish;
      default:
        return AppConstants.keyProgressMath;
    }
  }

  // ─── XP & Level ───────────────────────────────────────────────────────────────

  Future<void> addXP(int xp) async {
    final current = _prefs!.getInt(AppConstants.keyTotalXP) ?? 0;
    final newXP = current + xp;
    await _prefs!.setInt(AppConstants.keyTotalXP, newXP);
    await _prefs!
        .setInt(AppConstants.keyCurrentLevel, StudentModel.levelFromXP(newXP));
  }

  int get totalXP => _prefs!.getInt(AppConstants.keyTotalXP) ?? 0;
  int get currentLevel => _prefs!.getInt(AppConstants.keyCurrentLevel) ?? 1;

  // ─── Reset Progress ───────────────────────────────────────────────────────────

  /// Hapus semua data progress, skor, dan XP — nama & avatar tetap tersimpan.
  Future<void> resetProgress() async {
    await _prefs!.setInt(AppConstants.keyTotalQuizPlayed, 0);
    await _prefs!.setInt(AppConstants.keyHighScoreMath, 0);
    await _prefs!.setInt(AppConstants.keyHighScoreBiology, 0);
    await _prefs!.setInt(AppConstants.keyHighScoreEnglish, 0);
    await _prefs!.setDouble(AppConstants.keyProgressMath, 0.0);
    await _prefs!.setDouble(AppConstants.keyProgressBiology, 0.0);
    await _prefs!.setDouble(AppConstants.keyProgressEnglish, 0.0);
    await _prefs!.setInt(AppConstants.keyTotalXP, 0);
    await _prefs!.setInt(AppConstants.keyCurrentLevel, 1);
  }

  // ─── Full Reset (Hapus semua data + logout) ──────────────────────────────────

  /// Hapus SEMUA data termasuk nama, avatar, dan flag onboarding.
  /// User akan diarahkan kembali ke halaman onboarding untuk membuat profil baru.
  Future<void> fullReset() async {
    await _prefs!.clear();
  }

  // ─── Reset (untuk testing) ────────────────────────────────────────────────────

  Future<void> clearAll() async {
    await _prefs!.clear();
  }
}
