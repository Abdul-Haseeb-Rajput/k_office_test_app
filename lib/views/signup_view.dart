import 'package:flutter/material.dart';
import 'package:k_office_test_app/utils/constants/app_strings.dart';
import 'package:k_office_test_app/utils/constants/colors.dart';
import 'package:k_office_test_app/utils/constants/images_strings.dart';
import 'package:k_office_test_app/utils/constants/text_styles.dart';
import 'package:k_office_test_app/utils/widgets/custom_button.dart';
import 'package:k_office_test_app/utils/widgets/custom_glass_container.dart';
import 'package:k_office_test_app/utils/widgets/custom_text_field.dart';
import 'package:k_office_test_app/view_models/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, signupViewModel, child) {
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
                          AppStrings.signUp,
                          style: CustTextStyle.heading1
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                      SizedBox(
                        child: CustomGlassContainer(
                          boxHeight: 400,
                          column: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Form(
                              key: signupViewModel.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    AppStrings.dontHaveAccountParagraph,
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                  FutureBuilder(
                                      future: signupViewModel.getEmailValue(),
                                      builder: (context, snapshot) {
                                        var email = snapshot.data;
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text("data");
                                        } else {
                                          return Text(
                                            email!,
                                            style: CustTextStyle.body1.copyWith(
                                                color: AppColors.white),
                                          );
                                        }
                                      }),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  // name text field
                                  FocusScope(
                                    autofocus: true,
                                    child: CutsomTextField(
                                      controller:
                                          signupViewModel.nameController,
                                      hintText: AppStrings.name,
                                      validator: (value) {
                                        RegExp regex = RegExp(r'^.{3,}$');
                                        if (value!.isEmpty) {
                                          return ("First Name cannot be Empty");
                                        }
                                        if (!regex.hasMatch(value)) {
                                          return ("Enter Valid name(Min. 3 Character)");
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        signupViewModel.nameController.text =
                                            value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // password field
                                  FocusScope(
                                    autofocus: true,
                                    child: CutsomTextField(
                                      controller:
                                          signupViewModel.passwordController,
                                      hintText: AppStrings.password,
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
                                        signupViewModel
                                            .passwordController.text = value!;
                                      },
                                      suffix: GestureDetector(
                                        onTap: () {
                                          signupViewModel.toggleObsecureText();
                                        },
                                        child: signupViewModel.obscureText
                                            ? const Text(AppStrings.show)
                                            : const Text(AppStrings.hide),
                                      ),
                                      obscureText: signupViewModel.obscureText,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        AppStrings.privacyPolicyParagraph,
                                        style:
                                            TextStyle(color: AppColors.white),
                                      ),
                                      RichText(
                                        text: const TextSpan(
                                          text: AppStrings.iAgreeTo,
                                          children: [
                                            TextSpan(
                                                style: TextStyle(
                                                    color: AppColors.darkGreen),
                                                text:
                                                    AppStrings.termsOfService),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomButton(
                                    buttonText: AppStrings.agreeAndContinue,
                                    onPressed: () => signupViewModel.signUp(
                                        name:
                                            signupViewModel.nameController.text,
                                        password: signupViewModel
                                            .passwordController.text),
                                    foregroundColor: AppColors.white,
                                    backgroundColor: AppColors.ligthGreen,
                                    overlyColor: AppColors.darkGreen,
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
