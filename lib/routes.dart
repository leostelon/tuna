import 'package:tuna/screens/bridge.dart';
import 'package:tuna/screens/create_wallet.dart';
import 'package:tuna/screens/home.dart';
import 'package:tuna/screens/qr_scanner.dart';
import 'package:tuna/screens/recieve.dart';
import 'package:tuna/screens/send.dart';
import 'package:tuna/screens/settings.dart';
import 'package:tuna/screens/splash.dart';
import 'package:tuna/screens/transactions.dart';
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
      page: () => const HomeScreen(),
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
      name: '/recieve',
      page: () => const RecieveScreen(),
    ),
    GetPage(
      name: '/send',
      page: () => const SendScreen(),
    ),
    GetPage(
      name: '/transactions',
      page: () => const TransactionsScreen(),
    ),
    GetPage(
      name: '/scanner',
      page: () => const QrScanner(),
    ),
    GetPage(
      name: '/bridge',
      page: () => const Bridge(),
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
