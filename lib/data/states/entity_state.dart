import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_state.freezed.dart';

/// `EntityState` is a state that use for manage whenether the entity
/// are in a certain state to handle each progress the entity.
@freezed
class EntityState with _$EntityState {
  const factory EntityState.loading() = _Loading;
  const factory EntityState.success() = _Success;
  const factory EntityState.error() = _Error;
  const factory EntityState.connectionError() = _ConnectionErorError;
}
