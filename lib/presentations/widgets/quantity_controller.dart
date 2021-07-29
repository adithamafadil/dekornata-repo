import 'package:dekornata_test/presentations/widgets/cutom_buttons.dart';
import 'package:flutter/material.dart';

/// `QuantityController` is a wrapped [Widget] to control the quantity
/// including increment, decrement, and showing current quantity.
class QuantityController extends StatelessWidget {
  /// `onTapAdd` is a void [Function] to call action(s) when the plus
  /// button pressed.
  final Function() onTapAdd;

  /// `onTapDecrease` is a void [Function] to call action(s) when the minus
  /// button pressed.
  final Function() onTapDecrease;

  /// `qtyState` is a [Widget] that used for showing the current quantity.
  final Widget qtyState;
  const QuantityController({
    Key? key,
    required this.onTapAdd,
    required this.onTapDecrease,
    required this.qtyState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlineQuantityButton(
          child: const Text(
            '-',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: onTapDecrease),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8), child: qtyState),
      OutlineQuantityButton(
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        onTap: onTapAdd,
      ),
    ]);
  }
}
