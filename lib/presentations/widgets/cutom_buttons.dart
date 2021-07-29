import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:flutter/material.dart';

/// `CustomElevatedButton` is a custom button widget that adjusted for
/// this app theme.
class CustomElevatedButton extends StatelessWidget {
  /// `child` returns a [Widget] that will be shown on the button.
  ///
  /// The `child` cannot be null.
  final Widget child;

  /// `onPressed` returns a [Function] to callback action(s) when the
  /// button are tapped.
  ///
  /// The `onPressed` cannot be null.
  final Function() onPressed;
  const CustomElevatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(DekornataColors.primaryColor),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

/// `OutlineQuantityButton` is an outlined button for increment or
/// decrement quantity purposes.
class OutlineQuantityButton extends StatelessWidget {
  /// `child` returns a [Widget] that will shown in the middle of the button.
  final Widget child;

  /// `onTap` is a callback [Function] to call the action(s).
  final Function() onTap;
  const OutlineQuantityButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: DekornataColors.primaryColor,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
