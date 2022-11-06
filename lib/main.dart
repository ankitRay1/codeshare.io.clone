import 'package:codeshareclone/repository/auth-repository.dart';
import 'package:codeshareclone/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
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

    // print(apiResponseData.message);

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
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark().copyWith(primaryColor: kDartBlue),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        // final user = ref.watch(userStateProvider);

        // if (user != null && user.token.isNotEmpty) {
        //   // print('loggged route is working');
        //   return loggedInRoute;
        // }

        // print('loggged route is not working');

        return loggedInRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
