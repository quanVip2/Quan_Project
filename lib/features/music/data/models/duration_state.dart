import 'package:flutter/foundation.dart';

/// Dùng để chứa thông tin về tiến độ phát nhạc:
/// - [position]: Thời gian hiện tại bài hát đang được phát.
/// - [total]: Tổng thời gian của bài hát.
@immutable
class DurationState {
  final Duration position;
  final Duration total;

  const DurationState(this.position, this.total);

  DurationState copyWith({
    Duration? position,
    Duration? total,
  }) {
    return DurationState(
      position ?? this.position,
      total ?? this.total,
    );
  }

  @override
  String toString() =>
      'DurationState(position: ${position.inSeconds}, total: ${total.inSeconds})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationState &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          total == other.total;

  @override
  int get hashCode => position.hashCode ^ total.hashCode;
}
