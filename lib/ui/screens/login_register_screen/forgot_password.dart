import 'package:exam4/services/firebase_auth_http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailText = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final authHttpServices = AuthHttpServices();
  bool isLoading = false;

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
    }
    try {
      await authHttpServices.resetPassword(email: emailText.text);

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Parolni tiklash"),
            content: const Text("Emailingizga xabar yuborildi"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } on Exception catch (e) {
      // ignore: unused_local_variable
      String message = e.toString();

      if (e.toString().contains("INVALID_LOGIN_CREDENTIALS")) {
        message = "Bunday email hali ro'yhatdan o'tmagan";
      }
      if (e.toString().contains("Null check operator used on a null value")) {
        message = "Iltimos Emailingizni kiriting";
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icons/healthpal.svg"),
                ],
              ),
              const Gap(15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "HealthPal",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff111928),
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              const Gap(15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff111928),
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              const Gap(10),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      "Enter your Email, we will send you a verification code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 50,
                  bottom: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: emailText,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        labelText: "name@gmail.com",
                        labelStyle: const TextStyle(color: Colors.grey),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input Email";
                        }
                        if (!value.contains("@")) {
                          return "Input --> @";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: submit,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.amber.shade900,
                            ),
                            child: const Center(
                              child: Text(
                                "Send Code",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                ),
                              ),
                            ),
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
}
