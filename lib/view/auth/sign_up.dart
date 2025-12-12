import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/auth/signup_controller.dart';
import '/core/constants/constants.dart';
import '/view/auth/login.dart';
import '/view/home/home_page.dart';
import '/view/widgets/background.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpController signUpController = Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Restaurant Owner',
                            style: TextStyle(
                                color: mainBTNColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Radio(
                          value: 1,
                          groupValue: signUpController.type.value,
                          onChanged: (int? value) {
                            signUpController.type(value);
                          },
                        ),
                        Text(
                          'Customer',
                          style: TextStyle(
                              color: mainBTNColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Radio(
                          value: 2,
                          groupValue: signUpController.type.value,
                          onChanged: (int? value) {
                            signUpController.type(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: signUpController.name,
                          validator: (value) {
                            if (value!.trim().isEmpty) return "Can't be empty";
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Name",
                            contentPadding: const EdgeInsets.all(8),
                            labelText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: signUpController.email,
                          validator: (value) {
                            RegExp regex = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
                          controller: signUpController.password,
                          obscureText: signUpController.hidePassword.value,
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
                                onPressed: () => signUpController.hidePassword(!signUpController.hidePassword.value),
                                icon: Icon(signUpController.hidePassword.value
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
                              if (formKey.currentState!.validate()) {
                                signUpController.createAccount();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 4,
                                  right: MediaQuery.of(context).size.width / 4),
                              child: signUpController.loading.value
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
                            onPressed: () => Get.off(()=> const Login()),
                            child: const Text("Already registered?")),
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
