import 'dart:developer';

import 'package:flutter/material.dart';

class AppRouteLogger extends RouteObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log('Route pushed: ${route.settings.name}', name: 'Route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log('Route replaced: ${oldRoute?.settings.name} with ${newRoute?.settings.name}',
        name: 'Route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    log('Route popped: ${route.settings.name}', name: 'Route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    log('Route removed: ${route.settings.name}', name: 'Route');
  }

  // @override
  // void didStartUserGesture(
  //     Route<dynamic> route, Route<dynamic>? previousRoute) {
  //   super.didStartUserGesture(route, previousRoute);
  //   log('Route pushed: ${route.settings.name}', name: 'Route');
  // }

  // @override
  // void didStopUserGesture() {
  //   super.didStopUserGesture();
  //   log('Route pushed: didStopUserGesture', name: 'Route');
  // }
}
