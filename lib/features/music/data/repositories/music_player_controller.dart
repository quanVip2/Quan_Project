import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:untitled/features/bloc/auth_bloc.dart';
import 'package:untitled/features/bloc/auth_state.dart';
import 'package:untitled/features/music/data/models/music_detail_model.dart';
import 'package:untitled/features/music/data/repositories/music_next.dart';
import 'package:untitled/features/music/data/repositories/music_rewind.dart';

class MusicPlayerController {
  // --- Singleton ---
  static final MusicPlayerController _instance = MusicPlayerController._internal();
  factory MusicPlayerController() => _instance;

  static MusicPlayerController get instance => _instance;

  // --- Internal state ---
  final AudioPlayer _player = AudioPlayer();
  final MusicNextRepository _musicNextRepository = MusicNextRepository();
  final MusicRewindRepository _musicRewindRepository = MusicRewindRepository();
  final ValueNotifier<MusicDetail?> currentTrackNotifier = ValueNotifier<MusicDetail?>(null);

  MusicDetail? _currentTrack;
  Function(MusicDetail)? _onMusicChanged;

  MusicPlayerController._internal();

  // --- Public Getters ---
  AudioPlayer get player => _player;
  MusicDetail? get currentTrack => _currentTrack;

  // --- Methods ---

  void setOnMusicChanged(Function(MusicDetail)? callback) {
    _onMusicChanged = callback;
  }

  Future<void> setCurrentTrack(MusicDetail musicDetail) async {
    // Nếu là bài hiện tại, thì không cần load lại
    if (_currentTrack != null && _currentTrack!.id == musicDetail.id) {
      return;
    }

    _currentTrack = musicDetail;
    currentTrackNotifier.value = musicDetail;

    try {
      await _player.setUrl(musicDetail.linkUrlMusic);
      _player.play();
      _onMusicChanged?.call(musicDetail);
    } catch (e) {
      debugPrint('Lỗi khi phát nhạc: $e');
    }
  }

  Future<MusicDetail?> getCurrentMusic() async {
    return _currentTrack;
  }

  Future<void> playNextMusic(BuildContext context, [void Function(MusicDetail)? onChanged]) async {
    try {
      final authState = context.read<AuthBloc>().state;
      String token = authState is AuthAuthenticated ? authState.token : '';

      if (_currentTrack != null) {
        final nextMusic = await _musicNextRepository.fetchNextMusic(
          currentMusicId: _currentTrack!.id,
          token: token,
        );

        await setCurrentTrack(nextMusic);
        onChanged?.call(nextMusic);
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi playNextMusic: $e');
    }
  }

  Future<void> playRewindMusic(BuildContext context, [void Function(MusicDetail)? onChanged]) async {
    try {
      final authState = context.read<AuthBloc>().state;
      String token = authState is AuthAuthenticated ? authState.token : '';

      if (_currentTrack != null) {
        final rewindMusic = await _musicRewindRepository.fetchRewindMusic(
          currentMusicId: _currentTrack!.id,
          token: token,
        );

        await setCurrentTrack(rewindMusic);
        onChanged?.call(rewindMusic);
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi playRewindMusic: $e');
    }
  }

  void pause() => _player.pause();
  void resume() => _player.play();

  void dispose() => _player.dispose();

  void reset() {
    _currentTrack = null;
    _onMusicChanged = null;
  }
}
