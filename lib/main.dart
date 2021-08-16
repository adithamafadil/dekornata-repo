import 'package:dekornata_test/blocs/makeup/makeup_bloc.dart';
import 'package:dekornata_test/inject/inject.dart';
import 'package:dekornata_test/presentations/router/router.gr.dart';
import 'package:dekornata_test/presentations/screens/screens.dart';
import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _dekornataTestRouter = DekornataTestRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => inject<MakeupBloc>())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.dosis().fontFamily,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: DekornataColors.primaryColor,
            ),
            actionsIconTheme: IconThemeData(
              color: DekornataColors.primaryColor,
            ),
          ),
        ),
        routerDelegate: _dekornataTestRouter.delegate(),
        routeInformationParser: _dekornataTestRouter.defaultRouteParser(),
      ),
    );
  }
}
