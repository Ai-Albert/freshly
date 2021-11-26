import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshly/custom_widgets/show_alert_dialog.dart';
import 'package:freshly/sign_in/validators.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> with
    EmailAndPasswordValidator, SingleTickerProviderStateMixin {

  /********** TEXT EDITING STUFF **********/

  final TextEditingController _emailController = TextEditingController();
  String get _email => _emailController.text;

  void _updateState() {
    setState(() {});
  }

  /********** UI STUFF **********/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width),
                Text(
                  'Password Reset',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 32.0,
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                TextField(
                  style: GoogleFonts.montserrat(),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.montserrat(textStyle: const TextStyle(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(15)),
                  ),
                  cursorColor: Colors.black,
                  controller: _emailController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_email) => _updateState(),
                ),
                const SizedBox(height: 30.0),
                _sendButton(),
                _backButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sendButton() {
    return AnimatedButton(
      height: 53,
      width: 250,
      text: "Send recovery email",
      isReverse: true,
      selectedTextColor: Colors.white,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      selectedBackgroundColor: Colors.red,
      //textStyle: submitTextStyle,
      backgroundColor: Colors.black,
      borderColor: Colors.white,
      borderRadius: 15,
      borderWidth: 2,
      onPress: () async {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        Navigator.pop(context);
        showAlertDialog(
          context,
          title: "Email Sent",
          content: "Check your inbox to make a new password",
          defaultActionText: "OK",
        );
      },
    );
  }

  Widget _backButton() {
    return TextButton(
      child: const Text(
        "Back",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
      onPressed: () => Navigator.pop(context),
    );
  }
}
