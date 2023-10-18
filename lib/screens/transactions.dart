import 'package:tuna/themes.dart';
import 'package:tuna/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tuna/api/scrollscan.dart';
import 'package:web3dart/web3dart.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String address = GetStorage().read("address");
  List transactions = [];
  bool loading = true;

  Future<void> gT() async {
    var t = await getTransactionsByAccount(address);
    if (!mounted) return;
    setState(() {
      transactions = t;
      loading = false;
    });
  }

  bool ownAddress(add) {
    return address == add;
  }

  @override
  void initState() {
    super.initState();
    gT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Transactions",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: primaryColor,
        color: Colors.white,
        onRefresh: () async {
          await gT();
          return;
        },
        child: loading
            ? const SizedBox(
                height: 4,
                child: LinearProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                child: transactions.isEmpty
                    ? const Center(
                        child: Text(
                        "You haven't made any transactions📥",
                        style: TextStyle(color: Colors.white),
                      ))
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: false,
                        itemCount: transactions.length,
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
                                  child: ownAddress(transactions[ind]['to'])
                                      ? const RotatedBox(
                                          quarterTurns: 2,
                                          child: Icon(Icons.arrow_outward_sharp,
                                              color: Colors.green))
                                      : const Icon(Icons.arrow_outward_sharp,
                                          color: Colors.red),
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
                                "${EtherAmount.fromBase10String(EtherUnit.wei, transactions[ind]['value']).getValueInUnit(EtherUnit.ether).toStringAsFixed(2)} eth",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ownAddress(transactions[ind]['to'])
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
      ),
    );
  }
}
