import 'package:auto_route/auto_route.dart';
import 'package:dekornata_test/blocs/makeup/makeup_bloc.dart';
import 'package:dekornata_test/presentations/router/router.gr.dart';
import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:dekornata_test/presentations/widgets/custom_card.dart';
import 'package:dekornata_test/presentations/widgets/cutom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Checkout',
            style: TextStyle(color: Colors.black),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: context
                .select((MakeupBloc bloc) => bloc.state.cart.isEmpty)
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Bayar'),
                        ),
                        onPressed: () {
                          context
                              .read<MakeupBloc>()
                              .add(const MakeupEvent.confirmCheckout());
                          context.router.push(const ConfirmationScreenRoute());
                        })),
              ),
        body: () {
          if (context.select((MakeupBloc bloc) => bloc.state.cart.isEmpty)) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Anda belum memilih barang untuk dicheckout.'
                      'Yuk tambahkan dari keranjang Anda!',
                      textAlign: TextAlign.center,
                    ),
                    CustomElevatedButton(
                        child: const Text('Kembali ke halaman utama'),
                        onPressed: () {
                          context.router.pop();
                        })
                  ],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Maaf, fitur belum tersedia'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Lokasi pengiriman:'),
                                    Text('Jalan Melati no.33, Ciputat, Banten'),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: DekornataColors.primaryColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<MakeupBloc, MakeupState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            ListView.builder(
                              itemCount: state.checkoutCart.length,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = state.checkoutCart[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: StaticItemCard(item: item),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Barang:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${state.totalQty} Barang',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Harga:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${state.totalPrice} USD',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 48),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        }());
  }
}
