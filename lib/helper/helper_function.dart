import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:routemaster/routemaster.dart';

import 'package:codeshareclone/models/user.dart';
import 'package:universal_html/html.dart';

import '../repository/auth-repository.dart';
import '../repository/document-repository.dart';
import '../utils/color.dart';
import '../widgets/triangular_clip.dart';

void signInWithGoogle(
    {required WidgetRef ref, required BuildContext context}) async {
  // final navigator = Routemaster.of(context);
  final scaffoldMessanger = ScaffoldMessenger.of(context);
  final userResponse =
      await ref.read(authRepositoryProvider).signInWithGoogle();
  if (userResponse.responseData != null) {
    ref
        .read(userStateProvider.notifier)
        .update((state) => userResponse.responseData);
    scaffoldMessanger
        .showSnackBar(SnackBar(content: Text(userResponse.message ?? '')));
  } else {
    scaffoldMessanger.showSnackBar(SnackBar(
        content: Text(userResponse.message ?? "Something went Wrong!")));
  }
}

void createNewDocument(
    {required WidgetRef ref,
    required BuildContext context,
    String? token}) async {
  // String token = ref.watch(userStateProvider)!.token;
  final navigator = Routemaster.of(context);
  final scaffoldMessanger = ScaffoldMessenger.of(context);

  print('I exist $token');

  var documentData = token != null
      ? await ref
          .read(documentRepositoryProvider)
          .createDocumentForAuthUser(token: token)
      : await ref.read(documentRepositoryProvider).createDocument();

  if (documentData.responseData != null) {
    navigator.push('/${documentData.responseData.id}');
  } else {
    scaffoldMessanger
        .showSnackBar(SnackBar(content: Text(documentData.message!)));
  }
}

void downloadCodeFile({
  required List<int> bytes,
  String? downloadName,
}) {
  // Encode our file in base64
  final base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor =
      AnchorElement(href: 'data:application/octet-stream;base64,$base64')
        ..target = 'blank';
  // add the name
  if (downloadName != null) {
    anchor.download = downloadName;
  }
  // trigger download
  document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}

User? checkStateOfUser({required WidgetRef ref}) {
  final user = ref.watch(userStateProvider);

  return user;
}

String formatDateTitle({required int timeStamp}) {
  DateTime rawDateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);

  String formattedTitleDate = DateFormat('MMMM d, hh:mm a').format(rawDateTime);

  return formattedTitleDate;
}

String findDifferenceTime({required int timeStamp}) {
  DateTime rawTime = DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);

  String differenceInDaysWords = DateFormat('MMMM d, hh:mm a').format(rawTime);

  final currentTime = DateTime.now();

  final Duration differenceTime = currentTime.difference(rawTime);

  if (differenceTime.inSeconds < 60) {
    return "${differenceTime.inSeconds} seconds ago";
  } else if (differenceTime.inMinutes < 2) {
    return "${differenceTime.inMinutes} min ago";
  } else if (differenceTime.inMinutes < 60) {
    return "${differenceTime.inMinutes} minutes ago";
  } else if (differenceTime.inHours < 24) {
    return "${differenceTime.inHours} hours ago";
  } else if (differenceTime.inHours > 24) {
    return differenceInDaysWords;
  }

  return differenceInDaysWords;
}

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 800;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1200;

Future<dynamic> profileDialog(BuildContext context, WidgetRef ref,
    {bool isSavedScreen = false}) {
  final token = ref.read(userStateProvider)?.token;
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.only(top: 40),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
              right: 45,
              child: ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  padding: EdgeInsets.zero,
                  color: kWhiteColor,
                  height: 10,
                  width: 15,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 10,
              child: AlertDialog(
                backgroundColor: kWhiteColor,
                actionsPadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.only(
                    top: 0, right: 20, left: 0, bottom: 0),
                titlePadding: EdgeInsets.zero,
                buttonPadding: EdgeInsets.zero,
                iconPadding: EdgeInsets.zero,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                content: SizedBox(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isSavedScreen
                          ? const SizedBox.shrink()
                          : TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                final navigator = Routemaster.of(context);
                                navigator.push('/codes');
                              },
                              child: const Text(
                                'Your Codeshares',
                                style: TextStyle(
                                    color: kDarkBlueTextColor,
                                    wordSpacing: 04,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none),
                              )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            createNewDocument(
                                ref: ref, context: context, token: token);
                          },
                          child: const Text(
                            'New Codeshares',
                            style: TextStyle(
                                color: kDarkBlueTextColor,
                                wordSpacing: 04,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            final navigator = Routemaster.of(context);
                            ref.read(authRepositoryProvider).signOut();
                            ref
                                .read(userStateProvider.notifier)
                                .update((state) => null);

                            navigator.replace('/');
                          },
                          child: const Text(
                            'Log Out',
                            style: TextStyle(
                                color: kDarkBlueTextColor,
                                wordSpacing: 04,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                decoration: TextDecoration.none),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
