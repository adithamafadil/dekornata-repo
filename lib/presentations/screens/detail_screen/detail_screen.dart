import 'package:cached_network_image/cached_network_image.dart';
import 'package:dekornata_test/blocs/makeup/makeup_bloc.dart';
import 'package:dekornata_test/data/model/makeup/makeup_model.dart';
import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:dekornata_test/presentations/widgets/dot_indicator.dart';
import 'package:dekornata_test/presentations/widgets/quantity_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreen extends StatelessWidget {
  final ProductModel product;
  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              context.read<MakeupBloc>().add(
                    MakeupEvent.addToCart(product: product),
                  );
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(DekornataColors.primaryColor),
            ),
            child: const Text('Tambah ke keranjang'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                BlocBuilder<MakeupBloc, MakeupState>(
                  buildWhen: (previous, current) =>
                      current.pageIndex != previous.pageIndex,
                  builder: (context, state) => Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        width: double.infinity,
                        child: PageView(
                          pageSnapping: true,
                          onPageChanged: (index) {
                            context
                                .read<MakeupBloc>()
                                .add(MakeupEvent.pageChange(index: index));
                          },
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            CachedNetworkImage(
                              imageUrl: product.imageLink,
                              height: MediaQuery.of(context).size.height * .3,
                              fit: BoxFit.fitHeight,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(
                                    value: progress.downloaded.toDouble()),
                              ),
                            ),
                            CachedNetworkImage(
                              imageUrl: product.imageLink,
                              height: MediaQuery.of(context).size.height * .3,
                              fit: BoxFit.fitHeight,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(
                                    value: progress.downloaded.toDouble()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildDotIndicator(state.pageIndex),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.name,
                  style: const TextStyle(
                    color: DekornataColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.price} USD',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                product.productColors.isNotEmpty
                    ? const SizedBox(height: 16)
                    : Container(),
                product.productColors.isNotEmpty
                    ? const Text(
                        'Varian',
                        style: TextStyle(
                          color: DekornataColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : Container(),
                product.productColors.isNotEmpty
                    ? const SizedBox(height: 8)
                    : Container(),
                product.productColors.isNotEmpty
                    ? SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: product.productColors.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var productColor = product.productColors[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Chip(
                                label: Text(productColor.colourName ??
                                    'Tidak ada Nama'),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    color: DekornataColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Jumlah'),
                    BlocBuilder<MakeupBloc, MakeupState>(
                      buildWhen: (previous, current) =>
                          current.qty != previous.qty,
                      builder: (context, state) => QuantityController(
                        onTapAdd: () {
                          context
                              .read<MakeupBloc>()
                              .add(const MakeupEvent.addQuantity());
                        },
                        onTapDecrease: state.qty > 1
                            ? () {
                                context
                                    .read<MakeupBloc>()
                                    .add(const MakeupEvent.decreaseQuantity());
                              }
                            : () {},
                        qtyState: SizedBox(
                          width: 30,
                          child: Center(
                            child: Text(
                              state.qty.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDotIndicator(int page) {
    List<DotIndicator> _dotIndicator = [];

    for (int i = 0; i < 2; i++) {
      _dotIndicator.add(page == i
          ? const DotIndicator(isActive: true)
          : const DotIndicator(isActive: false));
    }

    return _dotIndicator;
  }
}
