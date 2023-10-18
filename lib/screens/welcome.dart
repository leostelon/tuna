import 'package:tuna/components/Button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFDBB0),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: context.height / 6),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/logo.png"),
                  ),
                  const Text(
                    "Welcome to Tuna🐟",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "All things on Scroll in a powerful wallet⚡",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(children: [
                      Button(
                        title: "Import Wallet",
                        onClick: () => Get.toNamed("/importwallet"),
                      ),
                      const SizedBox(height: 8),
                      Button(
                        title: "Create Wallet",
                        backgroundColor: Colors.black87,
                        fontColor: Colors.white,
                        onClick: () => Get.toNamed("/createwallet"),
                      )
                    ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
