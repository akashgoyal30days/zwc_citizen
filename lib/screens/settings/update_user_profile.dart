import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwc/controllers/settings_controller.dart';

class UpdateUserProfile extends StatefulWidget {
  const UpdateUserProfile({super.key});

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  final TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController();
  String? nameError, emailError;
  bool showLoading = false;

  @override
  void initState() {
    var controller = Get.find<SettingsController>();
    nameController.text = controller.name;
    emailController.text = controller.email;
    super.initState();
  }

  updateChanges() async {
    nameError = nameController.text.length < 2 ? "Full Name is Required" : null;
    emailError = !emailController.text.contains("@") ||
            !emailController.text.contains(".")
        ? "Enter valid email address"
        : null;
    setState(() {});
    if (nameError != null || emailError != null) return;
    setState(() {
      showLoading = true;
    });
    var controller = Get.find<SettingsController>();
    await controller.updatePersonalDetails(
        nameController.text, emailController.text);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(elevation: 0),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Full Name",
                        errorText: nameError),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.alternate_email),
                        hintText: "Email",
                        errorText: emailError),
                  ),
                ],
              ),
            ),
            showLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : GestureDetector(
                    onTap: updateChanges,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      color: Colors.green.shade400,
                      child: Text(
                        "UPDATE CHANGES",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
          ],
        ),
      );
    });
  }
}
