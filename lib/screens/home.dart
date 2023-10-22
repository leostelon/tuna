import 'dart:convert';
import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuna/api/scrollscan.dart';
import 'package:tuna/components/add_contact_modal.dart';
import 'package:tuna/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tuna/utils/wallet.dart';
import 'package:web3dart/web3dart.dart';
import "../utils/time.dart";

// import '../components/add_contact_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = GetStorage().read("address");
  String balance = "0";
  List contacts = [];
  List transactions = [];

  Future gB() async {
    EtherAmount b = await ethClient
        .getBalance(EthereumAddress.fromHex(GetStorage().read("address")));
    setState(() {
      balance = b.getValueInUnit(EtherUnit.ether).toStringAsFixed(3).toString();
    });
    return;
  }

  void gC() {
    String? c = GetStorage().read("contacts");
    if (c == null || c == "") c = jsonEncode({'contacts': []});
    Map pC = jsonDecode(c);
    if (!mounted) return;
    setState(() {
      contacts = pC["contacts"];
    });
  }

  Future<void> gT() async {
    var t = await getTransactionsByAccount(address);
    if (!mounted) return;
    setState(() {
      transactions = t;
    });
  }

  Future<void> addContact() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (_) {
          return const AddContactModal();
          // return const AddContactModal();
        });
    gC();
  }

  bool ownAddress(add) {
    return address == add;
  }

  @override
  void initState() {
    super.initState();
    gB();
    gC();
    gT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          "assets/paper-plane-solid.svg",
                          semanticsLabel: 'Send logo',
                          color: const Color.fromRGBO(240, 240, 240, 1),
                          height: 20,
                        ),
                        onPressed: () => Get.toNamed("/send",
                            arguments: {"symbol": "ETH", "address": "0x0"}),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.grey.shade600.withOpacity(0.5),
                      child: SvgPicture.asset(
                        "assets/house-solid.svg",
                        semanticsLabel: 'Home',
                        color: const Color.fromRGBO(240, 240, 240, 1),
                        height: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          "assets/repeat-solid.svg",
                          semanticsLabel: 'transactions logo',
                          color: const Color.fromRGBO(240, 240, 240, 1),
                          height: 20,
                        ),
                        onPressed: () => Get.toNamed("/transactions"),
                      ),
                    )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        backgroundColor: primaryColor,
        color: Colors.white,
        onRefresh: () async {
          gC();
          await gT();
          await gB();
          return;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    // Navbar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/profile.png"),
                                radius: 30),
                            SizedBox(width: 16),
                            Text(
                              "Morning, Ser!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed("/settings"),
                          child: CircleAvatar(
                            backgroundColor: Colors.black87.withOpacity(0.3),
                            radius: 28,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/gear-solid.svg",
                                semanticsLabel: 'Settings',
                                color: Color.fromARGB(255, 255, 255, 255),
                                height: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // Balance Tile
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      height: (MediaQuery.of(context).size.height / 100) * 22.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: const Color.fromRGBO(255, 219, 176, 1),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Your Balance",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${balance}eth",
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/eth.png",
                                    height: 28,
                                    color: Colors.black,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: address));
                                      Get.snackbar("Copied!",
                                          "Address copied to clipboard.",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: primaryColor);
                                    },
                                    child: Text(
                                      "${address.substring(0, 6)} **** **** ${address.substring(38, 42)}",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(height: 24),
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 104, 75, 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/send", arguments: {
                                "symbol": "ETH",
                                "address": "0x0"
                              }),
                              child: const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.arrow_outward_sharp,
                                      size: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Send",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 104, 75, 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/recieve"),
                              child: const Row(
                                children: [
                                  CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white,
                                      child: RotatedBox(
                                        quarterTurns: 2,
                                        child: Icon(
                                          Icons.arrow_outward_sharp,
                                          size: 26,
                                          color: Colors.black,
                                        ),
                                      )),
                                  SizedBox(width: 12),
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Quick Send
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick Send",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => addContact(),
                          child: const Text(
                            "Add new",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 110,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: contacts.length + 1,
                        itemBuilder: (_, ind) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                if (ind == contacts.length) {
                                  addContact();
                                } else {
                                  Get.toNamed("/send",
                                      arguments: contacts[ind]['address']);
                                }
                              },
                              child: Column(
                                children: [
                                  (ind == contacts.length
                                      ? CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              Colors.black87.withOpacity(0.3),
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        )
                                      : const CircleAvatar(
                                          backgroundImage:
                                              AssetImage("assets/profile.png"),
                                          radius: 30)),
                                  const SizedBox(height: 8),
                                  Text(
                                    ind == contacts.length
                                        ? "Add contact"
                                        : contacts[ind]['name'],
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Recent Activity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed("/transactions"),
                          child: const Text(
                            "See all",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: transactions.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("You haven't made any transactions📥",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: transactions.isNotEmpty
                                    ? transactions.length >= 4
                                        ? 4
                                        : transactions.length
                                    : 0,
                                itemBuilder: (_, ind) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.black12,
                                        child: Center(
                                          child: ownAddress(
                                                  transactions[ind]['to'])
                                              ? RotatedBox(
                                                  quarterTurns: 2,
                                                  child: Icon(
                                                      Icons.arrow_outward_sharp,
                                                      color: Colors
                                                          .green.shade400))
                                              : Icon(Icons.arrow_outward_sharp,
                                                  color: Colors.red.shade400),
                                        ),
                                      ),
                                      title: Text(
                                        "${ownAddress(transactions[ind]['to']) ? "Recieved from" : "Sent to"} ${(ownAddress(transactions[ind]['to']) ? transactions[ind]['from'] : transactions[ind]['to'])?.substring(37, 42)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      subtitle: Text(
                                        TimeFormatter.formattTime(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(transactions[ind]
                                                        ['timeStamp']) *
                                                    1000)),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${!ownAddress(transactions[ind]['to']) ? "-" : ""}${EtherAmount.fromBase10String(EtherUnit.wei, transactions[ind]['value']).getValueInUnit(EtherUnit.ether).toStringAsFixed(2)} ETH",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ownAddress(
                                                  transactions[ind]['to'])
                                              ? Colors.green.shade400
                                              : Colors.red.shade400,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
