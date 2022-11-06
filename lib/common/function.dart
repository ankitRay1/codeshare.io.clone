import 'package:codeshareclone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth-repository.dart';
import '../repository/document-repository.dart';

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
    {required WidgetRef ref, required BuildContext context}) async {
  // String token = ref.watch(userStateProvider)!.token;
  final navigator = Routemaster.of(context);
  final scaffoldMessanger = ScaffoldMessenger.of(context);

  var documentData =
      await ref.read(documentRepositoryProvider).createDocument();
  if (documentData.responseData != null) {
    navigator.push('/${documentData.responseData.id}');
  } else {
    scaffoldMessanger
        .showSnackBar(SnackBar(content: Text(documentData.message!)));
  }
}

User? checkStateOfUser({required WidgetRef ref}) {
  final user = ref.watch(userStateProvider);

  return user;
}
