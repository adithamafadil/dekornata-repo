import 'package:cached_network_image/cached_network_image.dart';
import 'package:dekornata_test/data/model/makeup/makeup_model.dart';
import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:dekornata_test/presentations/widgets/quantity_controller.dart';
import 'package:flutter/material.dart';

/// `CustomCard` is a cuztomized card so every card will be using the
/// same style.
class CustomCard extends StatelessWidget {
  ///`child` returns a [Widget] that will be inside the card.
  final Widget child;
  final Color color;
  const CustomCard({
    Key? key,
    required this.child,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: DekornataColors.primaryColor.withOpacity(.5),
              offset: const Offset(0, 3),
            ),
          ]),
      child: child,
    );
  }
}

/// `StaticItemCard` is a card to show products in static without the
/// [QuantityController]
class StaticItemCard extends StatelessWidget {
  final ProductModel item;
  const StaticItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CachedNetworkImage(
              imageUrl: item.imageLink,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                    value: progress.downloaded.toDouble()),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: DekornataColors.primaryColor),
                      ),
                      Text(
                        '${item.price} USD',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('x${item.qty}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
