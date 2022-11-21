import 'package:codeshareclone/repository/auth-repository.dart';
import 'package:codeshareclone/router.dart';
import 'package:codeshareclone/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kDarkBlack,
  ));

  runApp(const ProviderScope(child: CodeShareApp()));
}

class CodeShareApp extends ConsumerStatefulWidget {
  const CodeShareApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CodeShareAppState();
}

class _CodeShareAppState extends ConsumerState<CodeShareApp> {
  void getUserData() async {
    final apiResponseData =
        await ref.read(authRepositoryProvider).getUserData();
    if (apiResponseData.responseData != null) {
      ref
          .read(userStateProvider.notifier)
          .update((state) => apiResponseData.responseData);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CodeUrl || Share Code Online',
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        return loggedInRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
