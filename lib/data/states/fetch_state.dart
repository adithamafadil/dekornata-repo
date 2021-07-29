import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_state.freezed.dart';

/// `FetchState` is a state that use for manage whenether the remote datas
/// are in a certain state to handle each progress the datas.
@freezed
class FetchState<T> with _$FetchState<T> {
  const factory FetchState.success(T data) = _Success<T>;
  const factory FetchState.error([T? data]) = _Error<T>;
  const factory FetchState.connectionError([T? data]) = _ConnectionErorError<T>;
}
