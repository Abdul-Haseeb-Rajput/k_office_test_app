import 'package:flutter/material.dart';
import 'package:k_office_test_app/utils/constants/app_strings.dart';
import 'package:k_office_test_app/utils/constants/colors.dart';
import 'package:k_office_test_app/utils/constants/images_strings.dart';
import 'package:k_office_test_app/utils/constants/text_styles.dart';
import 'package:k_office_test_app/utils/widgets/custom_button.dart';
import 'package:k_office_test_app/utils/widgets/custom_glass_container.dart';
import 'package:k_office_test_app/utils/widgets/custom_icon_button.dart';
import 'package:k_office_test_app/utils/widgets/custom_text_field.dart';
import 'package:k_office_test_app/view_models/welcome_viewmodel.dart';
import 'package:stacked/stacked.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => WelcomeViewModel(),
      builder: (context, welcomeViewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false, //  false to prevent resizing
          backgroundColor: AppColors.black,
          body: Stack(
            children: [
              Positioned(
                right: -80,
                height: 450,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImages.bgImagePng),
                          fit: BoxFit.cover)),
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.sizeOf(context).width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Hi!",
                          style: CustTextStyle.heading1
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                      SizedBox(
                        child: CustomGlassContainer(
                          boxHeight: double.infinity,
                          column: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 18.0),
                            child: Form(
                              key: welcomeViewModel.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FocusScope(
                                    autofocus: true,
                                    child: CutsomTextField(
                                      controller:
                                          welcomeViewModel.emailController,
                                      hintText: AppStrings.email,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Please Enter Your Email");
                                        }
                                        // reg expression for email validation
                                        if (!RegExp(
                                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                            .hasMatch(value)) {
                                          return ("Please Enter a valid email");
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        welcomeViewModel.emailController.text =
                                            value!;
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  CustomButton(
                                    buttonText: AppStrings.continueText,
                                    onPressed: () =>
                                        welcomeViewModel.checkUserAndNavigate(
                                            email: welcomeViewModel
                                                .emailController.text),
                                    foregroundColor: AppColors.white,
                                    backgroundColor: AppColors.ligthGreen,
                                    overlyColor: AppColors.darkGreen,
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  const Center(
                                    child: Text(
                                      "or",
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // continue with facebook button
                                  CustomIconButon(
                                    prefixIcon: Image.asset(
                                      AppImages.facebookIcon,
                                      width: 40,
                                    ),
                                    label: const Text(
                                        AppStrings.continueWithFacebook),
                                    foregroundColor: AppColors.black,
                                    overlyColor: AppColors.hintTextColor,
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // continue with google button
                                  CustomIconButon(
                                    prefixIcon: Image.asset(
                                      AppImages.googleIcon,
                                      width: 40,
                                    ),
                                    label: const Text(
                                        AppStrings.continueWithGoogle),
                                    foregroundColor: AppColors.black,
                                    overlyColor: AppColors.hintTextColor,
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // contiue with apple button
                                  CustomIconButon(
                                    prefixIcon: Image.asset(
                                      AppImages.appleIcon,
                                      width: 40,
                                    ),
                                    label: const Text(
                                        AppStrings.continueWithApple),
                                    foregroundColor: AppColors.black,
                                    overlyColor: AppColors.hintTextColor,
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppStrings.dontHaveAccount,
                                        style: CustTextStyle.body1
                                            .copyWith(color: AppColors.white),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          " ${AppStrings.signUp}",
                                          style: CustTextStyle.body1.copyWith(
                                              color: AppColors.darkGreen),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      AppStrings.forgotPassword,
                                      style: CustTextStyle.body1
                                          .copyWith(color: AppColors.darkGreen),
                                    ),
                                  ),
                                ],
                              ),
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
