import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fooddelieveryapp/service/database.dart';
import 'package:fooddelieveryapp/service/shared_pref.dart';
import 'package:fooddelieveryapp/widget/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}
class _WalletState extends State<Wallet> {
  String? wallet, id;
  int? add;
  TextEditingController amountcontroller = TextEditingController(); // Declare the controller

  // This method fetches user data (wallet balance and user ID)
  getthesharedpref() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  void dispose() {
    amountcontroller.dispose(); // Dispose of the controller when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Center(
                        child: Text(
                          "Wallet",
                          style: AppWidget.HeadlineTextFeildStyle(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/wallet.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 40.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Wallet",
                              style: AppWidget.LightTextFeildStyle(),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "\₹" + wallet!,
                              style: AppWidget.boldTextFeildStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Add money",
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          addMoneyToWallet('100');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE9E2E2)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "\₹100",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addMoneyToWallet('500');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE9E2E2)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "\₹500",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addMoneyToWallet('1000');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE9E2E2)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "\₹1000",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addMoneyToWallet('2000');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE9E2E2)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "\₹2000",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      openEdit();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFF008080),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Method to add money to the wallet
  void addMoneyToWallet(String amount) async {
    int currentBalance = int.parse(wallet!);
    int addedAmount = int.parse(amount);
    int newBalance = currentBalance + addedAmount;

    // Update the wallet in shared preferences
    await SharedPreferenceHelper().saveUserWallet(newBalance.toString());

    // Update the wallet in the database
    await DatabaseMethods().UpdateUserwallet(id!, newBalance.toString());

    // Update the wallet balance in the state
    setState(() {
      wallet = newBalance.toString();
    });

    // Show success dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                Text("Amount Added Successfully"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to open the edit dialog for custom amount input
  Future openEdit() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel),
                  ),
                  SizedBox(width: 60.0),
                  Center(
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Text("Amount"),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 2.0),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: amountcontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Amount',
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    addMoneyToWallet(amountcontroller.text);
                  },
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFF008080),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Pay",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
