import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuna/components/button.dart';
import 'package:tuna/components/select_address_modal.dart';
import 'package:tuna/themes.dart';
import 'package:tuna/utils/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3dart/web3dart.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  dynamic argumentData = Get.arguments;
  bool loading = false;
  late TextEditingController controller;
  String balance = "0";
  late String? address;
  late Map token;

  void gB() async {
    EtherAmount b = await ethClient
        .getBalance(EthereumAddress.fromHex(GetStorage().read("address")));
    setState(() {
      balance = b.getValueInUnit(EtherUnit.ether).toStringAsFixed(3).toString();
    });
  }

  Future sendEth() async {
    var credentials = EthPrivateKey.fromHex(GetStorage().read("privateKey"));
    await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(address!),
        value: EtherAmount.fromBigInt(
            EtherUnit.wei,
            BigInt.from(double.parse(
                    controller.text.replaceAll(" ${token['symbol']}", "")) *
                (pow(10, 18)))),
      ),
      chainId: 534351,
    );
  }

  Future<void> sc() async {
    if (address == null) {
      Get.snackbar("Enter Address", "Please select and add address",
          backgroundColor: primaryColor, snackPosition: SnackPosition.BOTTOM);
    } else {
      setState(() {
        loading = true;
      });
      await sendEth();
      setState(() {
        loading = false;
      });
      Get.offNamed("/transactions");
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar("Successfully submitted.",
          "${controller.text} has been submitted successfully.",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: primaryColor);
    }
  }

  @override
  void initState() {
    super.initState();
    token = argumentData;
    controller = TextEditingController(text: "0 ${token['symbol']}");
    gB();
    address = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Send Crypto",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/qrcode-solid.svg",
              semanticsLabel: 'Send logo',
              height: 20,
            ),
            onPressed: () => Get.toNamed("/scanner"),
          ),
        ],
      ),
      body: Column(children: [
        const Text("send"),
        ListTile(
          title: Text(address != null ? "Sending to" : "Select address"),
          subtitle: Text(address ?? "Tap to select or paste address"),
          leading: RandomAvatar("146", height: 50, width: 50),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          onTap: () async {
            String add = await showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                context: context,
                builder: (_) => const SelectAddressModal());
            setState(() {
              address = add.toString();
            });
          },
        ),
        const SizedBox(height: 32),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: controller,
                    onChanged: (v) {
                      controller.value = controller.value.copyWith(
                        text: "${controller.text} ${token['symbol']}",
                        selection: TextSelection.collapsed(
                          offset: "${controller.text} FTX".length - 4,
                        ),
                      );
                    },
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 40,
                      decoration: TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,6}')),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    cursorColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Eth balance: $balance ETH",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                title: "Send",
                backgroundColor: primaryColor,
                fontColor: Colors.white,
                onClick: () {
                  sc();
                },
                loading: loading,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
