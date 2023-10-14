import 'package:tuna/screens/create_wallet.dart';
import 'package:tuna/screens/index.dart';
import 'package:tuna/screens/send.dart';
import 'package:tuna/screens/settings.dart';
import 'package:tuna/screens/splash.dart';
import 'package:tuna/screens/walletimport.dart';
import 'package:tuna/screens/welcome.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class Routers {
  static List<GetPage> getRouters = [
    GetPage(
      name: '/',
      page: () => const Splash(),
    ),
    GetPage(
      name: '/index',
      page: () => const IndexScreen(),
    ),
    GetPage(
      name: '/welcome',
      page: () => const Welcome(),
    ),
    GetPage(
      name: '/createwallet',
      page: () => const CreateWallet(),
    ),
    GetPage(
      name: '/settings',
      page: () => const Settings(),
    ),
    GetPage(
      name: '/importwallet',
      page: () => const WalletImport(),
    ),
    GetPage(
      name: '/send',
      page: () => const SendScreen(),
    ),
  ];

  static final defaultPage = GetPage(
    name: '/notfound',
    page: () => const Scaffold(
      body: Center(
        child: Text('Check Route Name'),
      ),
    ),
  );
}
