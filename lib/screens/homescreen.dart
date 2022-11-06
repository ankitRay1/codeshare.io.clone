import 'package:codeshareclone/repository/auth-repository.dart';
import 'package:codeshareclone/utils/color.dart';
import 'package:codeshareclone/widgets/featurebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:routemaster/routemaster.dart';

import '../common/function.dart';
import '../models/user.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final controller = ScrollController();
  User? userState;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    userState = ref.watch(userStateProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leadingWidth: 180,
          elevation: 0,
          backgroundColor: kDartBlue,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SvgPicture.asset(
              'assets/images/codeshare-logo.svg',
              semanticsLabel: 'Codeshare.io logo',
            ),
          ),
          actions: [
            userState?.token != null
                ? Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 07, right: 10),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {},
                        icon: CircleAvatar(
                            backgroundImage: NetworkImage(userState
                                    ?.profilePic ??
                                'https://gravatar.com/avatar/cbab9be1cf0a386588838721ffaf9857')),
                        label: Text(
                          userState?.name ?? '',
                          style: const TextStyle(color: kWhiteColor),
                        )),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 07, right: 10),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(14),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(06),
                                side: const BorderSide(
                                  color: kWhiteColor,
                                ))),
                        onPressed: () =>
                            signInWithGoogle(ref: ref, context: context),
                        icon: SvgPicture.asset(
                          'assets/images/google.svg',
                          height: 27,
                        ),
                        label: const Text(
                          'Login',
                          style: TextStyle(color: kWhiteColor),
                        )),
                  ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            // height: screenSize.height,
            // width: screenSize.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [kDartBlue, kLightBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: Container(
              // height: screenSize.height,
              width: screenSize.width,
              padding: const EdgeInsets.symmetric(vertical: 125),
              child: Column(children: [
                const Text(
                  'Share Code in Real-time with Developers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 48,
                      color: kWhiteColor,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'An online code editor for interviews, troubleshooting, teaching & more…',
                  style: TextStyle(
                      fontSize: 24,
                      color: kWhiteColor,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(
                  height: 35,
                ),
                TextButton(
                  onPressed: () =>
                      createNewDocument(ref: ref, context: context),
                  style: TextButton.styleFrom(
                      backgroundColor: kRedColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 28,
                      )),
                  child: const Text(
                    'Share Code Now',
                    style: TextStyle(
                      color: kWhiteColor,
                      decoration: TextDecoration.none,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Share code for free',
                  style: TextStyle(
                      fontSize: 17,
                      color: kGreyColor,
                      decoration: TextDecoration.none),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/example-code.gif',
                      width: screenSize.width * 0.9,
                      height: screenSize.height * 0.5,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 110, vertical: 130),
                  child: Row(
                    children: [
                      const Expanded(
                          child: FeatureTextBox(
                              title: 'Code with your team',
                              description:
                                  'Open a Codeshare editor, write or copy code, then share it with friends and colleagues. Pair program and troubleshoot together.',
                              buttonText: 'Hack Together')),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      const Expanded(
                          child: FeatureTextBox(
                              title: 'Interview developers',
                              description:
                                  'Set coding tasks and observe in real-time when interviewing remotely or in person. Nobody likes writing code on a whiteboard.',
                              buttonText: 'Start an Interview')),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      const Expanded(
                          child: FeatureTextBox(
                              title: 'Teach people to program',
                              description:
                                  'Share your code with students and peers then educate them. Universities and colleges around the world use Codeshare every day',
                              buttonText: 'Teach Code')),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(50),
            color: kLightBlack,
            height: screenSize.height * 0.2,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'Created by ',
                        style: TextStyle(
                          color: kGreyColor,
                          decoration: TextDecoration.none,
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: 'Ankit.',
                        style: TextStyle(
                          color: kGreyColor,
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: '  For help and support shoot us an ',
                        style: TextStyle(
                          color: kGreyColor,
                          decoration: TextDecoration.none,
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: 'email.',
                        style: TextStyle(
                          color: kGreyColor,
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                        ),
                      ),
                    ])),
                RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: kGreyColor,
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Service.',
                        style: TextStyle(
                          color: kGreyColor,
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                        ),
                      ),
                    ])),
              ],
            ),

            // child: ,
          ),
        )
      ],
    );
  }
}
