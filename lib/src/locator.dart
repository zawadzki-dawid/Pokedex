import 'package:get_it/get_it.dart';
import 'utils/models/navigation_service.dart';
import 'utils/models/memory_handler.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => MemoryHandler());
}