import 'package:dekornata_test/inject/inject.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final inject = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => $initGetIt(inject);
