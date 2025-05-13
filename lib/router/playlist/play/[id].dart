import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../constant/config.message.dart';
import '../../../../controllers/history_controller.dart';
import '../../../../controllers/playlist_controller.dart';
import '../../../../exception/config.exception.dart';
import '../../../../model/response.dart';
import '../../../../model/users.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method.value != 'GET') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, ErrorMessage.MSG_METHOD_NOT_ALLOW);
  }
  final _playlistController = context.read<PlaylistController>();
  final historyController = context.read<HistoryController>();
  final user = context.read<User?>();
  if (user == null || user.id == null) {
    return AppResponse().error(HttpStatus.forbidden, ErrorMessage.FORBIDDEN);
  }
  final id = int.tryParse(context.request.uri.pathSegments.last);
  final musicId = id;
  if (musicId == null) {
    return AppResponse()
        .error(HttpStatus.badRequest, ErrorMessage.MUSIC_NOT_FOUND);
  }
  final playlistIdStr = context.request.uri.queryParameters['playlistId'];
  final playlistId = int.tryParse(playlistIdStr ?? '');
  if (playlistId == null) {
    return AppResponse()
        .error(HttpStatus.badRequest, ErrorMessage.PLAYLIST_NOT_FOUND);
  }
  try {
    await _playlistController.setPlayMusicHistory(user.id!, musicId.toString());
    await _playlistController.incrementListenCount(musicId);
    final result = await _playlistController.playMusicInPlayList(
        user.id!, playlistId, musicId);
    await historyController.addMusicToHistory(user.id!, musicId);

    final authors = (result?.authors ?? []);
    for (final author in authors) {
      await historyController.addAuthorToHistoryAuthor(user.id!, author.id!);
    }
    await historyController.createHistoryAlbum(
        user.id!, result?.albumId, musicId);

    return AppResponse().ok(HttpStatus.ok, {
      'music': {
        'id': result?.id,
        'title': result?.title,
        'description': result?.description,
        'broadcastTime': result?.broadcastTime,
        'linkUrlMusic': result?.linkUrlMusic,
        'createdAt': result?.createdAt?.toIso8601String(),
        'updatedAt': result?.updatedAt?.toIso8601String(),
        'imageUrl': result?.imageUrl,
        'albumId': result?.albumId,
        'listenCount': result?.listenCount,
        'nation': result?.nation,
      },
      'authors': result?.authors?.map((author) {
        return {
          'id': author.id,
          'name': author.name,
          'description': author.description,
          'avatarUrl': author.avatarUrl,
          'createdAt': author.createdAt?.toIso8601String(),
          'updatedAt': author.updatedAt?.toIso8601String(),
        };
      }).toList(),
    });
  } catch (e) {
    if (e is CustomHttpException) {
      return AppResponse().error(e.statusCode, e.message);
    }
    return AppResponse().error(HttpStatus.internalServerError, e.toString());
  }
}
