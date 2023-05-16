// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen(this.localUserDataObject, {Key? key})
//       : super(key: key);
//   final Map localUserDataObject;
//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final currentPasswordController = TextEditingController(),
//       newPasswordController = TextEditingController(),
//       reEnterPasswordController = TextEditingController();
//   bool hideCurrentPassword = true,
//       hideNewPassword = true,
//       hideReNewPassword = true;
//   bool passwordDontMatchError = false,
//       passwordLengthError = false,
//       alphanumericError = false,
//       characterCheckError = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<bool> validateNewPassword(String password) async {
//     passwordLengthError = password.length < 8 || password.length > 12;
//     alphanumericError = !isAlphanumeric(password[0]);
//     characterCheckError = !(contains(password, "#") ||
//         contains(password, "!") ||
//         contains(password, "@"));
//     if (!characterCheckError) {
//       bool oneLowerCase = false, oneUpperCase = false, oneNumber = false;
//       for (var i = 0; i < password.length; ++i) {
//         oneLowerCase =
//             (isAlpha(password[i]) && isLowercase(password[i])) || oneLowerCase;
//         oneUpperCase =
//             (isAlpha(password[i]) && isUppercase(password[i])) || oneUpperCase;
//         oneNumber = isNumeric(password[i]) || oneNumber;
//       }
//       characterCheckError = !(oneLowerCase && oneUpperCase && oneNumber);
//     }
//     return !(passwordLengthError || characterCheckError || alphanumericError);
//   }

//   submit() async {
//     passwordLengthError = false;
//     alphanumericError = false;
//     characterCheckError = false;
//     passwordDontMatchError = false;
//     setState(() {});

//     if (newPasswordController.text.isEmpty ||
//         currentPasswordController.text.isEmpty) {
//       return;
//     }

//     if (newPasswordController.text != reEnterPasswordController.text) {
//       passwordDontMatchError = true;
//       setState(() {});
//       return;
//     }

//     if (!await validateNewPassword(newPasswordController.text)) {
//       setState(() {});
//       return;
//     }

//     Get.find<ChangePasswordController>()
//         .submit(currentPasswordController.text, newPasswordController.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Change Password"),
//       ),
//       body: GetBuilder<ChangePasswordController>(
//           builder: (changePasswordController) {
//         return ListView(
//           padding: const EdgeInsets.all(14.0),
//           children: [
//             const SizedBox(height: 10),
//             const Text(
//               "Current Password",
//               style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFieldWidget(
//                     margin: 0,
//                     hintText: "Enter your current password",
//                     obscureText: hideCurrentPassword,
//                     contentPadding: const EdgeInsets.only(left: 10),
//                     controller: currentPasswordController,
//                     isEnable: !changePasswordController.loading,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                     onTap: () => setState(() {
//                           hideCurrentPassword = !hideCurrentPassword;
//                         }),
//                     child: hideCurrentPassword
//                         ? const Icon(
//                             Icons.visibility,
//                             color: Colors.green,
//                           )
//                         : const Icon(Icons.visibility_off, color: Colors.green))
//               ],
//             ),
//             if (changePasswordController.wrongCurrentPassword)
//               const Padding(
//                 padding: EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   "Wrong Password, Re-enter your current password",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             const Text(
//               "New Password",
//               style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFieldWidget(
//                     hintText: "Enter new password",
//                     obscureText: hideNewPassword,
//                     margin: 0,
//                     contentPadding: const EdgeInsets.only(left: 10),
//                     controller: newPasswordController,
//                     isEnable: !changePasswordController.loading,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 GestureDetector(
//                     onTap: () => setState(() {
//                           hideNewPassword = !hideNewPassword;
//                         }),
//                     child: hideNewPassword
//                         ? const Icon(
//                             Icons.visibility,
//                             color: Colors.green,
//                           )
//                         : const Icon(Icons.visibility_off, color: Colors.green))
//               ],
//             ),
            // _PasswordInformation(
            //   passwordLengthError: passwordLengthError,
            //   alphanumericError: alphanumericError,
            //   characterCheckError: characterCheckError,
            // ),
//             const Text(
//               "Re-enter New Password",
//               style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFieldWidget(
//                     margin: 0,
//                     hintText: "Re-enter new password",
//                     obscureText: hideReNewPassword,
//                     contentPadding: const EdgeInsets.only(left: 10),
//                     controller: reEnterPasswordController,
//                     isEnable: !changePasswordController.loading,
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 GestureDetector(
//                   onTap: () =>
//                       setState(() => hideReNewPassword = !hideReNewPassword),
//                   child: hideReNewPassword
//                       ? const Icon(Icons.visibility, color: Colors.green)
//                       : const Icon(Icons.visibility_off, color: Colors.green),
//                 )
//               ],
//             ),
//             if (passwordDontMatchError)
//               const Padding(
//                 padding: EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   "Passwords don't match",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             changePasswordController.loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Center(
//                     child: ElevatedButton(
//                       onPressed: submit,
//                       child: const Text("Change Password"),
//                     ),
//                   )
//           ],
//         );
//       }),
//     );
//   }
// }

// class _PasswordInformation extends StatelessWidget {
//   const _PasswordInformation({
//     Key? key,
//     required this.passwordLengthError,
//     required this.alphanumericError,
//     required this.characterCheckError,
//   }) : super(key: key);

//   final bool passwordLengthError, alphanumericError, characterCheckError;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(
//         children: [
//           _PasswordInformationWidgets(
//             "Password should be 8 to 12 characters long",
//             color: passwordLengthError ? Colors.red : Colors.grey,
//           ),
//           _PasswordInformationWidgets(
//             "Password should should start with Alphanumeric Character",
//             color: alphanumericError ? Colors.red : Colors.grey,
//           ),
//           _PasswordInformationWidgets(
//             "Password should contain atleast one Upper Case, one Lower Case, one Numeric and one either of '#@!' Characters",
//             color: characterCheckError ? Colors.red : Colors.grey,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PasswordInformationWidgets extends StatelessWidget {
//   const _PasswordInformationWidgets(
//     this.data, {
//     Key? key,
//     this.color = Colors.grey,
//   }) : super(key: key);
//   final String data;
//   final Color color;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.do_disturb_on_rounded, color: color, size: 12),
//           const SizedBox(width: 6),
//           Expanded(
//             child: Text(
//               data,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: color,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
