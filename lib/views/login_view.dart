import 'package:flutter/material.dart';
import 'package:k_office_test_app/utils/constants/app_strings.dart';
import 'package:k_office_test_app/utils/constants/colors.dart';
import 'package:k_office_test_app/utils/constants/images_strings.dart';
import 'package:k_office_test_app/utils/constants/text_styles.dart';
import 'package:k_office_test_app/utils/widgets/custom_button.dart';
import 'package:k_office_test_app/utils/widgets/custom_glass_container.dart';
import 'package:k_office_test_app/utils/widgets/custom_text_field.dart';
import 'package:k_office_test_app/view_models/login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (loginViewModel) async {
        await loginViewModel.getUserDetails();
      },
      fireOnViewModelReadyOnce: true,
      builder: (context, loginViewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.black,
          body: Stack(
            children: [
              Positioned(
                right: -80,
                height: 450,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.bgImagePng),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppStrings.login,
                          style: CustTextStyle.heading1.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: CustomGlassContainer(
                          boxHeight: 330,
                          column: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 18.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                loginViewModel.userData != null
                                    ? Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 34,
                                            backgroundColor: AppColors.white,
                                            // You can use userData.profileUrl here
                                            backgroundImage: loginViewModel
                                                        .userData!.profileUrl !=
                                                    null
                                                ? NetworkImage(loginViewModel
                                                    .userData!.profileUrl!)
                                                : const AssetImage(AppImages
                                                        .defaulProfile1Png)
                                                    as ImageProvider<Object>?,
                                            // For example: backgroundImage: NetworkImage(userData.profileUrl),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                loginViewModel.userData!
                                                        .displayName ??
                                                    '',
                                                style: CustTextStyle.body1
                                                    .copyWith(
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              Text(
                                                loginViewModel
                                                        .userData!.email ??
                                                    '',
                                                style: CustTextStyle.body1
                                                    .copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox(), // Show nothing if data is null
                                const SizedBox(height: 40),
                                Form(
                                  key: loginViewModel.formKey,
                                  child: FocusScope(
                                    autofocus: true,
                                    // password text field
                                    child: CutsomTextField(
                                      controller:
                                          loginViewModel.passwordController,
                                      hintText: AppStrings.password,
                                      suffix: GestureDetector(
                                        onTap: () {
                                          loginViewModel.toggleObsecureText();
                                        },
                                        child: loginViewModel.obscureText
                                            ? const Text(AppStrings.show)
                                            : const Text(AppStrings.hide),
                                      ),
                                      obscureText: loginViewModel.obscureText,
                                      validator: (value) {
                                        RegExp regex = RegExp(r'^.{6,}$');
                                        if (value!.isEmpty) {
                                          return ("Password is required for signup");
                                        }
                                        if (!regex.hasMatch(value)) {
                                          return ("Enter Valid Password(Min. 6 Character)");
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        loginViewModel.passwordController.text =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomButton(
                                  buttonText: AppStrings.continueText,
                                  onPressed: () => loginViewModel.signIn(
                                      password: loginViewModel
                                          .passwordController.text),
                                  foregroundColor: AppColors.white,
                                  backgroundColor: AppColors.ligthGreen,
                                  overlyColor: AppColors.darkGreen,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  AppStrings.forgotPassword,
                                  style: CustTextStyle.body1.copyWith(
                                    color: AppColors.darkGreen,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
