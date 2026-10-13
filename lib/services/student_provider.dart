import 'package:flutter/foundation.dart';
import '../models/student_model.dart';
import '../services/shared_preferences_service.dart';

class StudentProvider extends ChangeNotifier {
  final SharedPreferencesService _prefs;

  StudentModel _student = const StudentModel(name: 'Siswa');
  bool _isLoaded = false;

  StudentProvider(this._prefs);

  StudentModel get student => _student;
  bool get isLoaded => _isLoaded;

  Future<void> loadStudent() async {
    _student = _prefs.loadStudent();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    await _prefs.saveStudentName(name);
    _student = _student.copyWith(name: name);
    notifyListeners();
  }

  Future<void> updateAvatar(String emoji) async {
    await _prefs.saveStudentAvatar(emoji);
    _student = _student.copyWith(avatarEmoji: emoji);
    notifyListeners();
  }

  Future<void> refreshStudent() async {
    await loadStudent();
  }

  Future<void> resetProgress() async {
    await _prefs.resetProgress();
    _student = _prefs.loadStudent();
    notifyListeners();
  }

  /// Hapus semua data dan reset ke kondisi awal (seperti install ulang).
  /// Setelah ini, user harus mengisi nama baru di onboarding.
  Future<void> logout() async {
    await _prefs.fullReset();
    _student = const StudentModel(name: 'Siswa');
    _isLoaded = false;
    notifyListeners();
  }
}
