import 'package:dekornata_test/blocs/makeup/makeup_bloc.dart';
import 'package:dekornata_test/presentations/widgets/custom_card.dart';
import 'package:dekornata_test/presentations/widgets/cutom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pembayaran Berhasil',
            style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocBuilder<MakeupBloc, MakeupState>(
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Nomor invoice'),
                Text(state.invoice),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: state.checkoutCart.length,
                  itemBuilder: (context, index) {
                    var item = state.checkoutCart[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: StaticItemCard(item: item),
                    );
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Kembali ke halaman utama'),
                      ),
                      onPressed: () {
                        context
                            .read<MakeupBloc>()
                            .add(const MakeupEvent.clearCheckoutCart());
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
