part of 'makeup_bloc.dart';

@freezed
class MakeupState with _$MakeupState {
  const factory MakeupState({
    required EntityState entityState,
    required String fetchMessage,
    required List<ProductModel> makeupData,
    required List<ProductModel> cart,
    required List<ProductModel> checkoutCart,
    required int qty,
    required int totalQty,
    required int totalPrice,
    required int pageIndex,
    required List<int> storedIdToCheckout,
    required String invoice,
  }) = _MakeupState;

  factory MakeupState.initial() => const MakeupState(
        cart: [],
        checkoutCart: [],
        entityState: EntityState.loading(),
        fetchMessage: '',
        invoice: '',
        makeupData: [],
        pageIndex: 0,
        qty: 1,
        storedIdToCheckout: [],
        totalPrice: 0,
        totalQty: 0,
      );
}
