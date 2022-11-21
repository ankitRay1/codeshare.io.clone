import 'package:codeshareclone/models/api_response_data.dart';
import 'package:codeshareclone/models/document.dart';
import 'package:codeshareclone/repository/auth-repository.dart';
import 'package:codeshareclone/repository/document-repository.dart';
import 'package:codeshareclone/utils/color.dart';
// import 'package:codeshareclone/widgets/featurebox.dart';
import 'package:codeshareclone/widgets/saved_codes_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';
// import 'dart:html';
// import 'package:routemaster/routemaster.dart';

import '../helper/helper_function.dart';
import '../models/user.dart';

// ignore: must_be_immutable
class SavedCodeScreen extends ConsumerWidget {
  SavedCodeScreen({super.key});

  User? userState;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final screenSize = MediaQuery.of(context).size;
    userState = ref.read(userStateProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leadingWidth: 180,
          elevation: 0,
          backgroundColor: kDartBlue,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: InkWell(
              onTap: () {
                final navigator = Routemaster.of(context);

                navigator.push('/');
              },
              child: SvgPicture.asset(
                'assets/images/codeshare-logo.svg',
                semanticsLabel: 'Codeshare.io logo',
              ),
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
                        onPressed: () =>
                            profileDialog(context, ref, isSavedScreen: true),
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
        SliverPadding(
            padding: EdgeInsets.only(
                top: 50, left: isMobile(context) ? 0 : 100, bottom: 50),
            sliver: const SliverToBoxAdapter(
              child: Text(
                'Your Codeshares',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 48,
                    color: kBlackColor,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),
              ),
            )),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 120, bottom: 20),
              child: TextButton(
                onPressed: () => createNewDocument(
                    ref: ref, context: context, token: userState?.token),
                style: TextButton.styleFrom(
                  backgroundColor: kRedColor,
                ),
                child: const Text(
                  'New CodeShare',
                  style: TextStyle(
                    color: kWhiteColor,
                    decoration: TextDecoration.none,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FutureBuilder<ApiResponseData>(
            future: ref
                .watch(documentRepositoryProvider)
                .displayAllDocsOfAuthUser(
                    token: ref.watch(userStateProvider)?.token ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator.adaptive();
              }

              if (snapshot.data?.responseData == null) {
                debugPrint('no data');
                return const Center(child: CircularProgressIndicator());
              }

              // print(snapshot.data?.responseData[0].content);
              return Container(
                padding: EdgeInsets.only(
                    left: isMobile(context) ? 0 : 80, bottom: 30),
                child: SavedCodesTable(
                  documents: snapshot.data?.responseData as List<Document>,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
