
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenchargehub/auth/otpscreen.dart';
import 'package:greenchargehub/constants/index.dart';
import 'package:greenchargehub/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  User? _user;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding28,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kPadding28,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText("Create your Profile",
                          MediaQuery.of(context).size.width, 28, kWhiteFF),
                      BuildText(
                          "Green Charge Hub will set up your Profile using your profile name and photo",
                          MediaQuery.of(context).size.width,
                          16,
                          kWhiteFF),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        _signInWithGoogle();
                      },
                      child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width *
                              0.95, // Adjust the percentage as needed
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: kBlackRich12,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(28.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              isLoading
                                  ? const CircularProgressIndicator(
                                      color: kWhite,
                                      backgroundColor: kBlack,
                                    )
                                  : const Icon(
                                      CupertinoIcons.mail_solid,
                                      size: 40,
                                      color: kWhite,
                                    ),
                              isLoading
                                  ? Row(
                                      children: [
                                        BuildText(
                                          "Loading...",
                                          MediaQuery.of(context).size.width,
                                          22,
                                          kWhiteFF,
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        const CircularProgressIndicator(
                                          color: kWhite,
                                          backgroundColor: kBlack,
                                        ),
                                      ],
                                    )
                                  : //
                                  BuildText(
                                      "Continue with Google",
                                      MediaQuery.of(context).size.width,
                                      22,
                                      kWhiteFF,
                                    ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        const String token = "ya29.a0Ad52N3_iNR33aAncCsIp6QQizoZegDotIbdshjoLGciW6ZpLbSUjI4CwshDEkiTz6X8hvdbDnYDSOXD5e_wF1RwVtViAknv1-4ZnlDPcUuAPnmW4M9ViddhZ5U3YW3IHfl3_WnK2dpAdylw5TYcLX6RJyB3jrui-gQaCgYKAToSARISFQHGX2MibOWCP0kRierOQi8cP1b2LQ016";
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: token);
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        preferences.setString(
            'user_name', googleSignInAccount.displayName ?? "");
        preferences.setString('user_email', googleSignInAccount.email ?? "");
        preferences.setString(
            'user_photo_url',
            googleSignInAccount.photoUrl ??
                "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg");
        await auth.signInWithCredential(credential);
        setState(() {
          isLoading = false;
        });
        Get.to(
          () => const Register(),
          curve: Curves.easeInOutSine,
          transition: Transition.zoom,
          duration: const Duration(milliseconds: 500),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = true ;
      });
      print(e);
    }
  }
}