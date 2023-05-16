import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwc/controllers/settings_controller.dart';
import 'package:zwc/controllers/update_profile_controller.dart';
import 'package:zwc/data/shared_preference.dart';
import 'package:zwc/widgets/text_field.dart';

import '../../model/locaiton_models.dart';

class UpdateLocationDetails extends StatefulWidget {
  const UpdateLocationDetails({super.key});

  @override
  State<UpdateLocationDetails> createState() => _UpdateLocationDetailsState();
}

class _UpdateLocationDetailsState extends State<UpdateLocationDetails> {
  final addressController = TextEditingController(
      text: SharedPreferenceFunctions.getUserData("address"));
  bool errorMessage = false, showLoading = false;
  @override
  void initState() {
    Get.put(UpdateLocationController());
    super.initState();
  }

  submit() async {
    var controller = Get.find<UpdateLocationController>();
    errorMessage =
        addressController.text.isEmpty || controller.selectedBranch == null;
    setState(() {});
    if (errorMessage) return;
    showLoading = true;
    setState(() {});
    await Get.find<SettingsController>().updateLocationDetails(
      addressController.text,
      controller.selectedArea,
      controller.selectedBranch!,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateLocationController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(title: const Text("Update Profile")),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  UpdateProfileWidgets(
                    title: "Address",
                    hintText: "XYZ Street, ABC City 123456",
                    textController: addressController,
                  ),
                  CustomWidget(
                    title: "State",
                    widget: controller.loadingStates
                        ? const Center(
                            child: ColorfulCircularProgressIndicator(colors: [
                              Colors.green,
                              Colors.lightGreen,
                            ]),
                          )
                        : Material(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<StateModel>(
                                icon: const SizedBox(),
                                underline: const SizedBox(),
                                items: controller.states
                                    .map<DropdownMenuItem<StateModel>>(
                                        (e) => DropdownMenuItem<StateModel>(
                                              value: e,
                                              child: Text(e.name),
                                            ))
                                    .toList(),
                                value: controller.selectedState,
                                onChanged: controller.selectState,
                                hint: Text(
                                  "Select State",
                                  style: TextStyle(
                                    fontWeight: controller.states.isNotEmpty
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  CustomWidget(
                    title: "District",
                    widget: controller.loadingDistricts
                        ? const Center(
                            child: ColorfulCircularProgressIndicator(colors: [
                              Colors.green,
                              Colors.lightGreen,
                            ]),
                          )
                        : Material(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<DistrictModel>(
                                icon: const SizedBox(),
                                underline: const SizedBox(),
                                items: controller.districts
                                    .map<DropdownMenuItem<DistrictModel>>(
                                        (e) => DropdownMenuItem<DistrictModel>(
                                              value: e,
                                              child: Text(e.name),
                                            ))
                                    .toList(),
                                value: controller.selectedDistrict,
                                onChanged: controller.selectDistrict,
                                hint: Text(
                                  "Select District",
                                  style: TextStyle(
                                    fontWeight: controller.districts.isNotEmpty
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  CustomWidget(
                    title: "City",
                    widget: controller.loadingCities
                        ? const Center(
                            child: ColorfulCircularProgressIndicator(colors: [
                              Colors.green,
                              Colors.lightGreen,
                            ]),
                          )
                        : Material(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<CityModel>(
                                icon: const SizedBox(),
                                underline: const SizedBox(),
                                items: controller.cities
                                    .map<DropdownMenuItem<CityModel>>(
                                        (e) => DropdownMenuItem<CityModel>(
                                              value: e,
                                              child: Text(e.name),
                                            ))
                                    .toList(),
                                value: controller.selectedCity,
                                onChanged: controller.selectCity,
                                hint: Text(
                                  "Select City",
                                  style: TextStyle(
                                    fontWeight: controller.cities.isNotEmpty
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  CustomWidget(
                    title: "Area",
                    widget: controller.loadingAreas
                        ? const Center(
                            child: ColorfulCircularProgressIndicator(colors: [
                              Colors.green,
                              Colors.lightGreen,
                            ]),
                          )
                        : Material(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<AreaModel>(
                                icon: const SizedBox(),
                                underline: const SizedBox(),
                                items: controller.areas
                                    .map<DropdownMenuItem<AreaModel>>(
                                        (e) => DropdownMenuItem<AreaModel>(
                                              value: e,
                                              child: Text(e.name),
                                            ))
                                    .toList(),
                                value: controller.selectedArea,
                                onChanged: controller.selectArea,
                                hint: Text(
                                  "Select Area",
                                  style: TextStyle(
                                    fontWeight: controller.areas.isNotEmpty
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  CustomWidget(
                    title: "Branch",
                    widget: controller.loadingBranches
                        ? const Center(
                            child: ColorfulCircularProgressIndicator(colors: [
                              Colors.green,
                              Colors.lightGreen,
                            ]),
                          )
                        : Material(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<BranchModel>(
                                icon: const SizedBox(),
                                underline: const SizedBox(),
                                items: controller.branches
                                    .map<DropdownMenuItem<BranchModel>>(
                                        (e) => DropdownMenuItem<BranchModel>(
                                              value: e,
                                              child: Text(e.name),
                                            ))
                                    .toList(),
                                value: controller.selectedBranch,
                                onChanged: controller.selectBranch,
                                hint: Text(
                                  "Select Branch",
                                  style: TextStyle(
                                    fontWeight: controller.branches.isNotEmpty
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            showLoading
                ? Container(
                    height: 50,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (errorMessage)
                        Text(
                          "All fileds are required",
                          style: TextStyle(color: Colors.red),
                        ),
                      GestureDetector(
                        onTap: submit,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          color: Colors.green,
                          child: Text(
                            "UPDATE CHANGES",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      );
    });
  }
}

class CustomWidget extends StatelessWidget {
  const CustomWidget({
    super.key,
    required this.title,
    required this.widget,
  });
  final String title;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          widget,
        ],
      ),
    );
  }
}

class UpdateProfileWidgets extends StatelessWidget {
  const UpdateProfileWidgets({
    super.key,
    required this.title,
    this.hintText = "",
    this.inputType,
    required this.textController,
  });
  final String title, hintText;
  final TextEditingController textController;
  final TextInputType? inputType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          LoginTextField(
            hintText: hintText,
            inputType: inputType,
            controller: textController,
          )
        ],
      ),
    );
  }
}
