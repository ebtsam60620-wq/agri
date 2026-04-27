
// ignore_for_file: strict_top_level_inference

import 'package:agri/data/models/failure.dart';

class Option<L, R> {
  final L? _left;
  final R? _right;

  Option({L? left, R? right})
      : _right = right,
        _left = left;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L? get left => _left;
  R? get right => _right;

  Option<L1, R1> fold<L1, R1>(
    L1 Function(L left) onLeft,
    R1 Function(R right) onRight,
  ) {
    try {
      if (isRight) {
        return Right(onRight(_right as R));
      } else {
        return Left(onLeft(_left as L));
      }
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), e.toString(), stackTrace));
    }
  }

  Option<Failure, T1> foldInto<T1>(
    T1 Function(L left) onLeft,
    T1 Function(R right) onRight,
  ) {
    try {
      if (isRight) {
        return Right(onRight(_right as R));
      } else {
        return Left(onLeft(_left as L));
      }
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), e.toString(), stackTrace));
    }
  }

  @override
  String toString() {
    return 'Option{left: ${_left.toString()}, right: ${_right.toString()}}';
  }
}

class Right<L, R> extends Option<L, R> {
  Right( right) : super(right: right);
}

class Left<L, R> extends Option<L, R> {
  Left(left) : super(left: left);
}
