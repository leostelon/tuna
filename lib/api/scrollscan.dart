import 'dart:convert';

import 'package:http/http.dart' as http;

Future getTransactionsByAccount(String add) async {
  try {
    http.Response response = await http.get(
      Uri.parse(
          "https://sepolia-blockscout.scroll.io/api?module=account&action=txlist&address=$add&sort=desc"),
    );
    var fR = jsonDecode(response.body);
    return fR["result"];
  } catch (e) {
    //
  }
}

Future getBalanceByAddress(String add) async {
  try {
    http.Response response = await http.get(
      Uri.parse(
          "https://sepolia-blockscout.scroll.io/api?module=account&action=balance&address=$add&tag=latest"),
    );
    var fR = jsonDecode(response.body);
    return fR["result"];
  } catch (e) {
    //
  }
}
