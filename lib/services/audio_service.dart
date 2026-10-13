import 'package:audioplayers/audioplayers.dart';

/// AudioService — Singleton yang mengelola 2 AudioPlayer terpisah:
///   • [_backsoundPlayer] → loop backsound, hanya pause/resume (tidak pernah stop total)
///   • [_sfxPlayer]       → one-shot SFX (correct / wrong / complete)
///
/// Pemisahan ini penting agar SFX tidak meng-interrupt atau mematikan backsound.
/// audioplayers v5 mendukung concurrent playback dengan 2 instance AudioPlayer berbeda.
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  // ─── Players ────────────────────────────────────────────────────────────────
  final AudioPlayer _backsoundPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // ─── State ──────────────────────────────────────────────────────────────────
  bool _backsoundEnabled = true;
  bool _sfxEnabled = true;
  bool _isBacksoundPlaying = false;
  bool _isDisposed = false; // guard agar method tidak dipanggil setelah dispose

  // ─── Getters ──────────────────────────────────────────────────────────────
  bool get backsoundEnabled => _backsoundEnabled;
  bool get sfxEnabled => _sfxEnabled;

  // ─── Init ────────────────────────────────────────────────────────────────────

  Future<void> startBacksound() async {
    if (_isDisposed || !_backsoundEnabled) return;
    try {
      await _backsoundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backsoundPlayer.setVolume(0.35);
      await _backsoundPlayer.play(AssetSource('audio/backsound.mp3'));
      _isBacksoundPlaying = true;
    } catch (_) {
      _isBacksoundPlaying = false;
    }
  }

  // ─── Backsound Controls ──────────────────────────────────────────────────────

  Future<void> pauseBacksound() async {
    if (_isDisposed || !_isBacksoundPlaying) return;
    try {
      await _backsoundPlayer.pause();
      _isBacksoundPlaying = false;
    } catch (_) {}
  }

  Future<void> resumeBacksound() async {
    if (_isDisposed || _isBacksoundPlaying || !_backsoundEnabled) return;
    try {
      await _backsoundPlayer.resume();
      _isBacksoundPlaying = true;
    } catch (_) {}
  }

  // ─── SFX ────────────────────────────────────────────────────────────────────
  // KUNCI: _sfxPlayer dan _backsoundPlayer adalah 2 instance BERBEDA.
  // SFX tidak akan mematikan backsound karena mereka berjalan paralel.

  Future<void> playCorrect() async {
    if (_isDisposed || !_sfxEnabled) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(1.0);
      await _sfxPlayer.play(AssetSource('audio/quiz_correct.mp3'));
    } catch (_) {}
  }

  Future<void> playWrong() async {
    if (_isDisposed || !_sfxEnabled) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(1.0);
      await _sfxPlayer.play(AssetSource('audio/quiz_wrong.mp3'));
    } catch (_) {}
  }

  Future<void> playComplete() async {
    if (_isDisposed || !_sfxEnabled) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(1.0);
      await _sfxPlayer.play(AssetSource('audio/quiz_complete.mp3'));
    } catch (_) {}
  }

  // ─── Toggle ──────────────────────────────────────────────────────────────────

  Future<void> toggleBacksound() async {
    if (_isDisposed) return;
    _backsoundEnabled = !_backsoundEnabled;
    if (_backsoundEnabled) {
      await startBacksound();
    } else {
      await _backsoundPlayer.stop();
      _isBacksoundPlaying = false;
    }
  }

  void toggleSfx() {
    _sfxEnabled = !_sfxEnabled;
  }

  // ─── Dispose ─────────────────────────────────────────────────────────────────

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _isBacksoundPlaying = false;
    await _backsoundPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
