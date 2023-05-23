import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkStatusService extends GetxService with WidgetsBindingObserver {
  late StreamSubscription<InternetConnectionStatus> listener;
  static const Duration DEFAULT_INTERVAL = const Duration(seconds: 5);
  static const Duration checkIntervalTime = DEFAULT_INTERVAL;

  final connectionCheckerInstance = InternetConnectionChecker.createInstance(
    checkInterval: checkIntervalTime,
  );

  bool isDisplayDialogueShown = false;
  //var errorScreen =
  NetworkStatusService(BuildContext context) {
    listener = connectionCheckerInstance.onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          //Get.delete(AppRoutes.networkConnectionError);
          if (isDisplayDialogueShown) {
            isDisplayDialogueShown = false;
            Navigator.of(context).pop();
          }

          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          isDisplayDialogueShown = true;
          await _displayDialog(context);

          break;
      }
    });
  }

  Future<void> _displayDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xff3B4A54),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* ClipRect(
                  child: Align(
                    //heightFactor: 0.5,
                    heightFactor: 0.8,
                    child: Transform.scale(
                      scale: 0.6,
                      child: Image(
                        color: Colors.white,
                        image: AssetImage(
                          'assets/images/NoConnectionLogo.png',
                        ),
                      ),
                    ),
                  ),
                ), */
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Ooops!',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'No network connection found.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 214, 214, 214),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Please check your connection',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 214, 214, 214),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'and try again.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 214, 214, 214),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      //listener.resume();
      //listener.pause();
      await listener.cancel();
    } else {
      //await listener.cancel();
      listener =
          connectionCheckerInstance.onStatusChange.listen((status) async {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            //Get.delete(AppRoutes.networkConnectionError);
            if (isDisplayDialogueShown) {
              isDisplayDialogueShown = false;
              Get.back();
            }

            break;
          case InternetConnectionStatus.disconnected:
            print('You are disconnected from the internet.');
            isDisplayDialogueShown = true;
            await _displayDialog(Get.context!);

            //Get.toNamed(AppRoutes.networkConnectionError);
            break;
        }
      });
    }
  }

  @override
  void onClose() async {
    await listener.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
