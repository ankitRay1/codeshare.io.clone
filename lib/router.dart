import 'package:codeshareclone/screens/codescreen.dart';
import 'package:codeshareclone/screens/homescreen.dart';
import 'package:flutter/material.dart';

import 'package:routemaster/routemaster.dart';

final loggedInRoute = RouteMap(routes: {
  '/': (route) =>  MaterialPage(child: HomeScreen()),
  '/:id': (route) => MaterialPage(
      child: CodeScreen(documentId: route.pathParameters['id'] ?? ''))
});
// final loggedOutRoute = RouteMap(
//     routes: {'/': (route) => const MaterialPage(child: LoginScreen())});
