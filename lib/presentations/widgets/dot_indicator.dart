import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:flutter/material.dart';

/// `DotIndicator` is a [Widget] that used for indicating the [PageView]'s
/// page on.
class DotIndicator extends StatelessWidget {
  /// `isActive` returns a [bool] for verifying the page state. It will
  /// control the [DotIndicator]'s color.
  final bool isActive;
  const DotIndicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
        color: isActive
            ? DekornataColors.primaryColor
            : Colors.grey.withOpacity(.5),
      ),
    );
  }
}
