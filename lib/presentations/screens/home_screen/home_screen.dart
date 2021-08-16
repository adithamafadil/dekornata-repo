import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dekornata_test/blocs/makeup/makeup_bloc.dart';
import 'package:dekornata_test/data/model/makeup/makeup_model.dart';
import 'package:dekornata_test/data/model/poster/poster_model.dart';
import 'package:dekornata_test/presentations/router/router.gr.dart';
import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:dekornata_test/presentations/widgets/custom_card.dart';
import 'package:dekornata_test/presentations/widgets/cutom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .25,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider.builder(
                itemCount: posters.length,
                itemBuilder: (context, index, realIndex) {
                  var poster = posters[index];
                  return Container(
                    margin: const EdgeInsets.all(4),
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: poster.imageUrl,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          value: progress.downloaded.toDouble(),
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 8),
            BlocBuilder<MakeupBloc, MakeupState>(
              builder: (context, state) {
                return state.entityState.maybeWhen(
                  loading: () {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).size.height * .25,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  success: () {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .6,
                        ),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: state.makeupData.length,
                        itemBuilder: (context, index) {
                          var product = state.makeupData[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    context
                                        .read<MakeupBloc>()
                                        .add(const MakeupEvent.resetQuantity());
                                    context.router.push(
                                        DetailScreenRoute(product: product));
                                  },
                                  child: _buildCard(context, product)),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  connectionError: () {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Maaf, terjadi kesalahan koneksi. Silahkan tekan tombol '
                            'di bawah untuk memuat kembali.'),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<MakeupBloc>()
                                .add(const MakeupEvent.load());
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    );
                  },
                  error: () {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Maaf, terjadi kesalahan. Silahkan tekan tombol '
                            'di bawah untuk memuat kembali.'),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<MakeupBloc>()
                                .add(const MakeupEvent.load());
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    );
                  },
                  orElse: () {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Maaf, terjadi kesalahan. Silahkan tekan tombol '
                            'di bawah untuk memuat kembali.'),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<MakeupBloc>()
                                .add(const MakeupEvent.load());
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, ProductModel product) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: product.imageLink,
                fit: BoxFit.fitHeight,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                      value: progress.downloaded.toDouble()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    style: const TextStyle(
                      color: DekornataColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price} USD',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
                child: const Text(
                  'Tambah ke keranjang',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  context
                      .read<MakeupBloc>()
                      .add(const MakeupEvent.resetQuantity());
                  context
                      .read<MakeupBloc>()
                      .add(MakeupEvent.addToCart(product: product));
                }),
          )
        ],
      ),
    );
  }
}
