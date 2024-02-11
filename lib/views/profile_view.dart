import 'package:flutter/material.dart';
import 'package:k_office_test_app/models/user_model.dart';
import 'package:k_office_test_app/utils/constants/app_strings.dart';
import 'package:k_office_test_app/utils/constants/colors.dart';
import 'package:k_office_test_app/utils/constants/images_strings.dart';
import 'package:k_office_test_app/utils/constants/text_styles.dart';
import 'package:k_office_test_app/utils/widgets/bg_shadow_container.dart';
import 'package:k_office_test_app/view_models/profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, profileViewModel, child) {
        return ViewModelBuilder<ProfileViewModel>.reactive(
          viewModelBuilder: () => ProfileViewModel(),
          onViewModelReady: (profileViewModel) async {
            // Start listening to the stream on ViewModelReady
            profileViewModel.getUserDetailsStream();
          },
          builder: (context, profileViewModel, child) {
            return Scaffold(
              resizeToAvoidBottomInset: false, //  false to prevent resizing
              backgroundColor: const Color.fromARGB(255, 17, 17, 17),
              appBar: AppBar(
                foregroundColor: AppColors.white,
                backgroundColor: const Color.fromARGB(255, 17, 17, 17),
                title: const Text("Profile"),
                actions: [
                  GestureDetector(
                    onTap: () => profileViewModel.signOut(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.exit_to_app,
                      ),
                    ),
                  ),
                ],
              ),
              body: profileViewModel.isBusy
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.darkGreen,
                      ),
                    )
                  : StreamBuilder<UserModel>(
                      stream: profileViewModel.getUserDetailsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.darkGreen,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final UserModel userData = snapshot.data!;
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),

                                SizedBox(
                                  height: 160,
                                  width: 160,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomBgShadowContainer(
                                        width: 130,
                                        height: 130,
                                        shape: BoxShape.circle,
                                        backgroundImage: DecorationImage(
                                          isAntiAlias: true,
                                          fit: BoxFit.fill,
                                          image: userData.profileUrl != null
                                              ? NetworkImage(
                                                  userData.profileUrl!)
                                              : const AssetImage(AppImages
                                                      .defaulProfile1Png)
                                                  as ImageProvider<Object>,
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: IconButton(
                                              splashColor: AppColors.ligthGreen,
                                              color: AppColors.darkGreen,
                                              onPressed: () => profileViewModel
                                                  .selectImage(),
                                              icon: const Icon(Icons.edit))),
                                    ],
                                  ),
                                ),
                                // Circular Avatar
                                const SizedBox(
                                  height: 20,
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.name,
                                        style: CustTextStyle.hintText,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      CustomBgShadowContainer(
                                        width: double.infinity,
                                        height: 50,
                                        shape: BoxShape.rectangle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userData.displayName!,
                                                style: CustTextStyle.body1
                                                    .copyWith(
                                                        color: AppColors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.email,
                                        style: CustTextStyle.hintText,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      CustomBgShadowContainer(
                                        width: double.infinity,
                                        height: 50,
                                        shape: BoxShape.rectangle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userData.email!,
                                                style: CustTextStyle.body1
                                                    .copyWith(
                                                        color: AppColors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('User not found.'),
                          );
                        }
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
