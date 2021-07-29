part of 'makeup_bloc.dart';

@freezed
class MakeupEvent with _$MakeupEvent {
  const factory MakeupEvent.load() = Load;

  const factory MakeupEvent.pageChange({required int index}) = PageChange;

  const factory MakeupEvent.addToCart({
    required ProductModel product,
  }) = AddToCart;
  const factory MakeupEvent.addToCheckoutCart({
    required ProductModel product,
  }) = AddToCheckoutCart;
  const factory MakeupEvent.clearCheckoutCart() = ClearCheckoutCart;
  const factory MakeupEvent.confirmCheckout() = ConfirmCheckout;
  const factory MakeupEvent.deleteFromCart({
    required int index,
  }) = DeleteFromCart;
  const factory MakeupEvent.addQuantity() = AddQuantity;
  const factory MakeupEvent.decreaseQuantity() = DecreaseQuantity;
  const factory MakeupEvent.addQuantityFromCart({required int index}) =
      AddQuantityFromCart;
  const factory MakeupEvent.decreaseQuantityFromCart({required int index}) =
      DecreaseQuantityFromCart;
  const factory MakeupEvent.resetQuantity() = ResetQuantity;
  const factory MakeupEvent.countTotalPrice() = CountTotalPrice;
  const factory MakeupEvent.countTotalQty() = CountTotalQty;
}
