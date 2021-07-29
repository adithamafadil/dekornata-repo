import 'dart:async';
import 'dart:math';

import 'package:dekornata_test/data/model/makeup/makeup_model.dart';
import 'package:dekornata_test/data/repositories/makeup/makeup_remote_repository.dart';
import 'package:dekornata_test/data/states/entity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

part 'makeup_event.dart';
part 'makeup_state.dart';
part 'makeup_bloc.freezed.dart';

@lazySingleton
class MakeupBloc extends Bloc<MakeupEvent, MakeupState> {
  final MakeupRepository _makeupRepository;

  MakeupBloc(this._makeupRepository) : super(MakeupState.initial()) {
    add(const MakeupEvent.load());
  }

  @override
  Stream<MakeupState> mapEventToState(
    MakeupEvent event,
  ) async* {
    yield* event.map(load: (e) async* {
      yield* _handleLoad(e);
    }, addToCart: (e) async* {
      yield* _handleAddToCart(e);
    }, addToCheckoutCart: (e) async* {
      yield* _handleAddToCheckoutCart(e);
    }, deleteFromCart: (e) async* {
      yield* _handleDeleteFromCart(e);
    }, addQuantity: (e) async* {
      yield* _handleAddQuantity(e);
    }, decreaseQuantity: (e) async* {
      yield* _handleDecreaseQuantity(e);
    }, resetQuantity: (e) async* {
      yield* _handleResetQuantity(e);
    }, addQuantityFromCart: (e) async* {
      yield* _handleAddQuantityFromCart(e);
    }, decreaseQuantityFromCart: (e) async* {
      yield* _handleDecreaseQuantityFromCart(e);
    }, countTotalPrice: (e) async* {
      yield* _handleCountTotalPrice(e);
    }, countTotalQty: (e) async* {
      yield* _handleCountTotalQty(e);
    }, pageChange: (e) async* {
      yield* _handlePageChange(e);
    }, confirmCheckout: (e) async* {
      yield* _handleConfirmCheckout(e);
    }, clearCheckoutCart: (e) async* {
      yield* _handleClearCheckoutCart(e);
    });
  }

  Stream<MakeupState> _handlePageChange(PageChange e) async* {
    yield state.copyWith(pageIndex: e.index);
  }

  Stream<MakeupState> _handleLoad(Load e) async* {
    yield state.copyWith(entityState: const EntityState.loading());

    var data = await _makeupRepository.getData();

    yield* data.when(
      success: (makeupData) async* {
        yield state.copyWith(
          entityState: const EntityState.success(),
          fetchMessage: 'Success Getting Data!',
          makeupData: makeupData,
        );
      },
      connectionError: (makeupData) async* {
        yield state.copyWith(
          entityState: const EntityState.connectionError(),
          fetchMessage: 'Connection Error When Getting Data!',
          makeupData: [],
        );
      },
      error: (makeupData) async* {
        yield state.copyWith(
          entityState: const EntityState.error(),
          fetchMessage: 'Something Went Wrong When Getting Data!',
          makeupData: [],
        );
      },
    );
  }

  Stream<MakeupState> _handleAddToCart(AddToCart e) async* {
    var _cart = state.cart.toList();
    _cart.add(e.product.copyWith(qty: state.qty));
    yield state.copyWith(cart: _cart);
  }

  Stream<MakeupState> _handleAddToCheckoutCart(AddToCheckoutCart e) async* {
    var _checkoutCart = state.checkoutCart.toList();
    var _storedIdToCheckout = state.storedIdToCheckout.toList();

    if (_checkoutCart.any((element) => element.id == e.product.id)) {
      var index =
          _checkoutCart.indexWhere((element) => element.id == e.product.id);
      _checkoutCart.removeAt(index);
      _storedIdToCheckout
          .removeWhere((element) => element == _checkoutCart[index].id);
    } else {
      _checkoutCart.add(e.product);
      _storedIdToCheckout.add(e.product.id);
    }
    yield state.copyWith(checkoutCart: _checkoutCart);

    add(const MakeupEvent.countTotalPrice());
    add(const MakeupEvent.countTotalQty());
  }

  Stream<MakeupState> _handleDeleteFromCart(DeleteFromCart e) async* {
    var _cart = state.cart.toList();
    var _checkoutCart = state.checkoutCart.toList();
    var _storedIdToCheckout = state.storedIdToCheckout.toList();
    if (_checkoutCart.any((element) => element.id == _cart[e.index].id)) {
      var _checkoutCartIndex = _checkoutCart
          .indexWhere((element) => element.id == _cart[e.index].id);
      _checkoutCart.removeAt(_checkoutCartIndex);
      _storedIdToCheckout.removeWhere(
          (element) => element == _checkoutCart[_checkoutCartIndex].id);
    }

    _cart.removeAt(e.index);

    yield state.copyWith(
      cart: _cart,
      checkoutCart: _checkoutCart,
      storedIdToCheckout: _storedIdToCheckout,
    );

    add(const MakeupEvent.countTotalPrice());
    add(const MakeupEvent.countTotalQty());
  }

  Stream<MakeupState> _handleAddQuantity(AddQuantity e) async* {
    yield state.copyWith(qty: state.qty + 1);
  }

  Stream<MakeupState> _handleDecreaseQuantity(DecreaseQuantity e) async* {
    yield state.copyWith(qty: state.qty - 1);
  }

  Stream<MakeupState> _handleResetQuantity(ResetQuantity e) async* {
    yield state.copyWith(qty: 1);
  }

  Stream<MakeupState> _handleAddQuantityFromCart(AddQuantityFromCart e) async* {
    var newQty = (state.cart.elementAt(e.index).qty ?? 0) + 1;
    var _cart = state.cart.toList();
    var _checkoutCart = state.checkoutCart.toList();
    if (_checkoutCart.any((element) => element.id == _cart[e.index].id)) {
      var _checkoutIndex = _checkoutCart
          .indexWhere((element) => element.id == _cart[e.index].id);

      yield state.copyWith(
        checkoutCart: state.checkoutCart.toList()
          ..insert(
            _checkoutIndex,
            ProductModel(
              id: state.cart.elementAt(_checkoutIndex).id,
              brand: state.cart.elementAt(_checkoutIndex).brand,
              createdAt: state.cart.elementAt(_checkoutIndex).createdAt,
              description: state.cart.elementAt(_checkoutIndex).description,
              imageLink: state.cart.elementAt(_checkoutIndex).imageLink,
              name: state.cart.elementAt(_checkoutIndex).name,
              price: state.cart.elementAt(_checkoutIndex).price,
              productApiUrl: state.cart.elementAt(_checkoutIndex).productApiUrl,
              productColors: state.cart.elementAt(_checkoutIndex).productColors,
              productType: state.cart.elementAt(_checkoutIndex).productType,
              updatedAt: state.cart.elementAt(_checkoutIndex).updatedAt,
              category: state.cart.elementAt(_checkoutIndex).category,
              priceSign: state.cart.elementAt(_checkoutIndex).priceSign,
              qty: newQty,
            ),
          )
          ..removeAt(_checkoutIndex + 1),
        cart: state.cart.toList()
          ..insert(
            e.index,
            ProductModel(
              id: state.cart.elementAt(e.index).id,
              brand: state.cart.elementAt(e.index).brand,
              createdAt: state.cart.elementAt(e.index).createdAt,
              description: state.cart.elementAt(e.index).description,
              imageLink: state.cart.elementAt(e.index).imageLink,
              name: state.cart.elementAt(e.index).name,
              price: state.cart.elementAt(e.index).price,
              productApiUrl: state.cart.elementAt(e.index).productApiUrl,
              productColors: state.cart.elementAt(e.index).productColors,
              productType: state.cart.elementAt(e.index).productType,
              updatedAt: state.cart.elementAt(e.index).updatedAt,
              category: state.cart.elementAt(e.index).category,
              priceSign: state.cart.elementAt(e.index).priceSign,
              qty: newQty,
            ),
          )
          ..removeAt(e.index + 1),
      );

      add(const MakeupEvent.countTotalPrice());
      add(const MakeupEvent.countTotalQty());
    } else {
      yield state.copyWith(
        cart: state.cart.toList()
          ..insert(
            e.index,
            ProductModel(
              id: state.cart.elementAt(e.index).id,
              brand: state.cart.elementAt(e.index).brand,
              createdAt: state.cart.elementAt(e.index).createdAt,
              description: state.cart.elementAt(e.index).description,
              imageLink: state.cart.elementAt(e.index).imageLink,
              name: state.cart.elementAt(e.index).name,
              price: state.cart.elementAt(e.index).price,
              productApiUrl: state.cart.elementAt(e.index).productApiUrl,
              productColors: state.cart.elementAt(e.index).productColors,
              productType: state.cart.elementAt(e.index).productType,
              updatedAt: state.cart.elementAt(e.index).updatedAt,
              category: state.cart.elementAt(e.index).category,
              priceSign: state.cart.elementAt(e.index).priceSign,
              qty: newQty,
            ),
          )
          ..removeAt(e.index + 1),
      );
    }
  }

  Stream<MakeupState> _handleDecreaseQuantityFromCart(
      DecreaseQuantityFromCart e) async* {
    var newQty = (state.cart.elementAt(e.index).qty ?? 0) - 1;
    var _cart = state.cart.toList();
    var _checkoutCart = state.checkoutCart.toList();
    if (_checkoutCart.any((element) => element.id == _cart[e.index].id)) {
      var _checkoutIndex = _checkoutCart
          .indexWhere((element) => element.id == _cart[e.index].id);

      yield state.copyWith(
        checkoutCart: state.checkoutCart.toList()
          ..insert(
            _checkoutIndex,
            ProductModel(
              id: state.cart.elementAt(_checkoutIndex).id,
              brand: state.cart.elementAt(_checkoutIndex).brand,
              createdAt: state.cart.elementAt(_checkoutIndex).createdAt,
              description: state.cart.elementAt(_checkoutIndex).description,
              imageLink: state.cart.elementAt(_checkoutIndex).imageLink,
              name: state.cart.elementAt(_checkoutIndex).name,
              price: state.cart.elementAt(_checkoutIndex).price,
              productApiUrl: state.cart.elementAt(_checkoutIndex).productApiUrl,
              productColors: state.cart.elementAt(_checkoutIndex).productColors,
              productType: state.cart.elementAt(_checkoutIndex).productType,
              updatedAt: state.cart.elementAt(_checkoutIndex).updatedAt,
              category: state.cart.elementAt(_checkoutIndex).category,
              priceSign: state.cart.elementAt(_checkoutIndex).priceSign,
              qty: newQty,
            ),
          )
          ..removeAt(_checkoutIndex + 1),
        cart: state.cart.toList()
          ..insert(
            e.index,
            ProductModel(
              id: state.cart.elementAt(e.index).id,
              brand: state.cart.elementAt(e.index).brand,
              createdAt: state.cart.elementAt(e.index).createdAt,
              description: state.cart.elementAt(e.index).description,
              imageLink: state.cart.elementAt(e.index).imageLink,
              name: state.cart.elementAt(e.index).name,
              price: state.cart.elementAt(e.index).price,
              productApiUrl: state.cart.elementAt(e.index).productApiUrl,
              productColors: state.cart.elementAt(e.index).productColors,
              productType: state.cart.elementAt(e.index).productType,
              updatedAt: state.cart.elementAt(e.index).updatedAt,
              category: state.cart.elementAt(e.index).category,
              priceSign: state.cart.elementAt(e.index).priceSign,
              qty: newQty,
            ),
          )
          ..removeAt(e.index + 1),
      );

      add(const MakeupEvent.countTotalPrice());
      add(const MakeupEvent.countTotalQty());
    } else {
      yield state.copyWith(
        cart: state.cart.toList()
          ..insert(
            e.index,
            ProductModel(
              id: state.cart.elementAt(e.index).id,
              brand: state.cart.elementAt(e.index).brand,
              createdAt: state.cart.elementAt(e.index).createdAt,
              description: state.cart.elementAt(e.index).description,
              imageLink: state.cart.elementAt(e.index).imageLink,
              name: state.cart.elementAt(e.index).name,
              price: state.cart.elementAt(e.index).price,
              productApiUrl: state.cart.elementAt(e.index).productApiUrl,
              productColors: state.cart.elementAt(e.index).productColors,
              productType: state.cart.elementAt(e.index).productType,
              updatedAt: state.cart.elementAt(e.index).updatedAt,
              category: state.cart.elementAt(e.index).category,
              priceSign: state.cart.elementAt(e.index).priceSign,
              qty: newQty,
            ),
          )
          ..removeAt(e.index + 1),
      );
    }
  }

  Stream<MakeupState> _handleCountTotalPrice(CountTotalPrice e) async* {
    int totalPrice = 0;
    for (var product in state.checkoutCart) {
      totalPrice += double.parse(product.price).toInt() * (product.qty ?? 0);
    }

    yield state.copyWith(totalPrice: totalPrice);
  }

  Stream<MakeupState> _handleCountTotalQty(CountTotalQty e) async* {
    int totalQty = 0;
    for (var product in state.checkoutCart) {
      totalQty += (product.qty ?? 0);
    }

    yield state.copyWith(totalQty: totalQty);
  }

  Stream<MakeupState> _handleConfirmCheckout(ConfirmCheckout e) async* {
    var _invoiceNumber = Random().nextInt(999999);
    var _date = DateFormat('yyyMMdd').format(DateTime.now());
    var _newCart = state.cart.toList();

    for (var checkoutItem in state.checkoutCart) {
      if (_newCart.any((element) => element.id == checkoutItem.id)) {
        var _newCartIndex =
            _newCart.indexWhere((element) => element.id == checkoutItem.id);
        _newCart.removeAt(_newCartIndex);
      }
    }

    yield state.copyWith(
      invoice: 'INVOICE/$_date/DEKORNATA/$_invoiceNumber',
      cart: _newCart,
      storedIdToCheckout: [],
    );
  }

  Stream<MakeupState> _handleClearCheckoutCart(ClearCheckoutCart e) async* {
    yield state.copyWith(
      checkoutCart: [],
    );
  }
}
