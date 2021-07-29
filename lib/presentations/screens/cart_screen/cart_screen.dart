import 'package:cached_network_image/cached_network_image.dart';
import 'package:dekornata_test/blocs/makeup/makeup_bloc.dart';
import 'package:dekornata_test/data/model/makeup/makeup_model.dart';
import 'package:dekornata_test/presentations/screens/screens.dart';
import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:dekornata_test/presentations/widgets/custom_card.dart';
import 'package:dekornata_test/presentations/widgets/cutom_buttons.dart';
import 'package:dekornata_test/presentations/widgets/quantity_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<MakeupBloc, MakeupState>(
        builder: (context, state) {
          if (state.checkoutCart.isEmpty) {
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.totalQty} Barang',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Total Harga: ${state.totalPrice} USD',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const Text('Checkout'),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutScreen(),
                        ));
                  },
                ),
              ),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocBuilder<MakeupBloc, MakeupState>(
          builder: (context, state) {
            if (state.cart.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Keranjang Anda masih kosong. Yuk tambahkan'),
                    CustomElevatedButton(
                        child: const Text('Kembali ke halaman utama'),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: state.cart.length,
                        itemBuilder: (context, index) {
                          var item = state.cart[index];

                          return _buildListContent(
                            context,
                            item,
                            index,
                            state,
                          );
                        }),
                    const SizedBox(height: 48),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListContent(
    BuildContext context,
    ProductModel item,
    int index,
    MakeupState state,
  ) {
    return InkWell(
      onTap: () {
        context
            .read<MakeupBloc>()
            .add(MakeupEvent.addToCheckoutCart(product: item));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomCard(
          color: () {
            if (state.checkoutCart.any((element) => element.id == item.id)) {
              return Colors.limeAccent;
            } else {
              return Colors.white;
            }
          }(),
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          QuantityController(
                            onTapAdd: () {
                              context.read<MakeupBloc>().add(
                                  MakeupEvent.addQuantityFromCart(
                                      index: index));
                            },
                            onTapDecrease: item.qty! > 1
                                ? () {
                                    context.read<MakeupBloc>().add(
                                        MakeupEvent.decreaseQuantityFromCart(
                                            index: index));
                                  }
                                : () {},
                            qtyState: Text(item.qty.toString()),
                          ),
                          IconButton(
                            padding: const EdgeInsets.only(right: 8),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Menghapus ${item.name}'),
                                    content: Text(
                                        'Anda yakin ingin menghapus ${item.name}?'),
                                    actions: [
                                      CustomElevatedButton(
                                          child: const Text('Tidak'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      OutlinedButton(
                                          onPressed: () {
                                            context.read<MakeupBloc>().add(
                                                MakeupEvent.deleteFromCart(
                                                    index: index));
                                            if (state.cart.length == 1) {
                                              Navigator.pop(context);
                                            }

                                            Navigator.pop(context);
                                          },
                                          child: const Text('Hapus'))
                                    ],
                                  );
                                },
                              );
                            },
                            iconSize: 16,
                            color: Colors.red,
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
