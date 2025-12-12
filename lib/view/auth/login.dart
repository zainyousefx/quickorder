import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/auth/login_controller.dart';
import '/core/constants/constants.dart';
import '/view/auth/sign_up.dart';
import '/view/home/home_page.dart';
import '/view/widgets/background.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginController loginController = Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGround(
        widget: Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            color: Colors.white54,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Welcome again!",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: loginController.email,
                          validator: (value) {
                            RegExp regex =
                            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                            if (value!.trim().isEmpty) return "Can't be empty";
                            if (!regex.hasMatch(value)) {
                              return "Invalid email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Email",
                              labelText: "Email",
                              contentPadding: const EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(()=> TextFormField(
                          controller: loginController.password,
                          obscureText: loginController.hidePassword.value,
                          validator: (value) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            if (value!.trim().isEmpty) return "Can't be empty";
                            if (!regex.hasMatch(value)) {
                              return "should contain at least one upper/lower case/ digit/Special character";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Password",
                              labelText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () => loginController.hidePassword(!loginController.hidePassword.value),
                                icon: Icon(loginController.hidePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                              ),
                              contentPadding: const EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        )),
                        const SizedBox(
                          height: 30,
                        ),
                        Obx(
                          () => TextButton(
                            style:
                                TextButton.styleFrom(backgroundColor: mainBTNColor),
                            onPressed: () {
                              // Get.to(() => const HomePage());
                              if (formKey.currentState!.validate()) {
                                loginController.login();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 4,
                                  right: MediaQuery.of(context).size.width / 4),
                              child: loginController.loading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () => Get.off(()=> const SignUp()),
                            child: const Text("Don't have an account?")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
