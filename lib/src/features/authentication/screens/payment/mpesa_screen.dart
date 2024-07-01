import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';

class MpesaScreen extends StatefulWidget {
  const MpesaScreen({Key? key}) : super(key: key);

  @override
  _MpesaScreenState createState() => _MpesaScreenState();
}

class _MpesaScreenState extends State<MpesaScreen> {
  late DocumentReference paymentsRef;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    initializeFlutterFire().then((_) {
      initializeMpesa();
    });
  }

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          setState(() {
            _error = true;
          });
          print("User not logged in.");
        } else {
          setState(() {
            _initialized = true;
          });
        }
      });
    } catch (e) {
      print("Firebase initialization error: ${e.toString()}");
      setState(() {
        _error = true;
      });
    }
  }

  void initializeMpesa() {
    MpesaFlutterPlugin.setConsumerKey("XHW9duCtZuAAdNVqzzdFlnjGdWYk8Y5hnxush9i7AvF8mfeF");
    MpesaFlutterPlugin.setConsumerSecret("1EwFX4wDlxDAlO5G3LF8XFtciaor7Czj7o2vyhWcaTyiWadyjAVPLQXMED6ttiOi");
  }

  Future<void> startTransaction({required double amount, required String userPhoneInput}) async {
    if (_error) {
      print("Error initializing transaction: Firebase not initialized or user not logged in.");
      return;
    }
 
    try {
      dynamic transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: "174379",
        transactionType: TransactionType.CustomerPayBillOnline,
        amount: amount,
        partyA:userPhoneInput,
        partyB: "174379",
        callBackURL: Uri(
          scheme: "https",
          host: "us-central1-nigel-da5d1.cloudfunctions.net",
          path: "paymentCallback",
        ),
        accountReference: "Children's home",
        phoneNumber: userPhoneInput,
        baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
        transactionDesc: "purc",
        passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
      );

      var result = transactionInitialisation as Map<String, dynamic>;

      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result["ResponseCode"];
        print("Resulting Code: $mResponseCode");
        if (mResponseCode == '0') {
          await updateAccount(result["CheckoutRequestID"], amount, userPhoneInput);
        }
      }
      print("RESULT: $transactionInitialisation");
    } catch (e) {
      print("Exception Caught: ${e.toString()}");
    }
  }

  Future<void> updateAccount(String mCheckoutRequestID, double amount, String userPhoneInput) async {
    try {
      await FirebaseFirestore.instance.collection('donations').add({
        'amount': amount,
        'phoneNumber': userPhoneInput,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Donation added to collection.");
    } catch (error) {
      print("Failed to add donation: $error");
    }
  }

  Future<void> lipaNaMpesa() async {
    try {
      dynamic transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: "174379",
        transactionType: TransactionType.CustomerPayBillOnline,
        amount: 1.0,
        partyA: "", // You can leave this blank or use a default value if needed
        partyB: "174379",
        callBackURL: Uri(
          scheme: "https",
          host: "mpesa-requestbin.herokuapp.com",
          path: "/1hhy6391",
        ),
        accountReference: "Hisani",
        phoneNumber: "", // You can leave this blank or use a default value if needed
        baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
        transactionDesc: "purchase",
        passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
      );
      print("TRANSACTION RESULT: $transactionInitialisation");
    } catch (e) {
      print("CAUGHT EXCEPTION: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Mpesa Payment', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
     
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                buildCustomButton(
                  text: "Lipa na Mpesa",
                  icon: Icons.payment,
                  onPressed: lipaNaMpesa,
                ),
                const SizedBox(height: 20),
                buildCustomButton(
                  text: "Send Money",
                  icon: Icons.send,
                  onPressed: () {},
                ),
          
        const SizedBox(height: 20),
              buildCustomButton(
                text: "Send Prompt",
                icon: Icons.payment,
        onPressed: () async {
          Map<String, dynamic>? userInput = await showDialog(
            context: context,
            builder: (BuildContext context) {
              String? phoneInput;
              String? amountInput;
              return AlertDialog(
                title: Text("Enter Details"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      TextField(
                        onChanged: (value) {
                          phoneInput = value;
                        },
                        decoration: InputDecoration(hintText: "Phone Number"),
                      ),
                      TextField(
                        onChanged: (value) {
                          amountInput = value;
                        },
                        decoration: InputDecoration(hintText: "Amount"),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                  TextButton(
                    child: Text("Confirm"),
                    onPressed: () {
                      Navigator.of(context).pop({
                        'phone': phoneInput,
                        'amount': amountInput,
                      });
                    },
                  ),
                ],
              );
            },
          );

          if (userInput != null && userInput['phone'] != null && userInput['amount'] != null) {
            double? amount = double.tryParse(userInput['amount']);
            if (amount != null && amount > 0) {
              startTransaction(amount: amount, userPhoneInput: userInput['phone']);
            } else {
              print("Invalid amount entered.");
            }
          } else {
            print("Phone number or amount input is empty or null.");
          }
         },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
    
  Widget buildCustomButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: tPrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.5),
        ),
        icon: Icon(icon, color: Colors.black),
        label: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ),
    );
  }
}



