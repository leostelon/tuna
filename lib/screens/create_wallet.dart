import 'package:tuna/components/Button.dart';
import 'package:tuna/themes.dart';
import 'package:tuna/utils/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web3dart/credentials.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  late String seedPhrase;

  void generateEthKey() async {
    String mnemonic = generateMnemonic();
    setState(() {
      seedPhrase = mnemonic;
    });
    String privateKey = await getPrivateKey(mnemonic);
    Credentials credentials = EthPrivateKey.fromHex(privateKey);
    GetStorage().write("mnemonic", mnemonic);
    GetStorage().write("privateKey", privateKey);
    GetStorage().write("address", credentials.address.toString());
    // print(mnemonic);
    // print(privateKey);
    // print(credentials.address);
  }

  @override
  void initState() {
    generateEthKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Wallet",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Create seed phrase",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Write down or copy the phrase, or save it safely!",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: seedPhrase.split(" ").length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3,
                      ),
                      itemBuilder: (_, i) {
                        return Container(
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                              child: Text(
                            seedPhrase.split(" ")[i].toString(),
                            style: const TextStyle(color: Colors.black),
                          )),
                        );
                      }),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () =>
                        Clipboard.setData(ClipboardData(text: seedPhrase)),
                    child: const Center(
                      child: Text(
                        "Copy to clipboard",
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      title: "Next",
                      backgroundColor: primaryColor,
                      onClick: () => Get.toNamed("/index"),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
