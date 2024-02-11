import 'package:k_office_test_app/services/shared_prefs_service.dart';
import 'package:k_office_test_app/views/login_view.dart';
import 'package:k_office_test_app/views/profile_view.dart';
import 'package:k_office_test_app/views/signup_view.dart';
import 'package:k_office_test_app/views/welcome_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: WelcomeView,initial: true),
  MaterialRoute(page: SignupView),
  MaterialRoute(page: LoginView),
  MaterialRoute(page: ProfileView),
], dependencies: [
  Singleton(classType: NavigationService),
  Singleton(classType: SharedPrefsService),
])
class App {}
