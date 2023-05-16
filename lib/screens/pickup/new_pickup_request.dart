import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:zwc/controllers/pickup_controller.dart';
import 'package:zwc/widgets/custom_text_field.dart';

class NewPickupRequest extends StatefulWidget {
  const NewPickupRequest({super.key});

  @override
  State<NewPickupRequest> createState() => _NewPickupRequestState();
}

class _NewPickupRequestState extends State<NewPickupRequest> {
  final weightController = TextEditingController(),
      timeController = TextEditingController();
  DateTimeRange? dateTimeRange;

  String selectedFilePath = "", selectedFileName = "";
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
  }

  datePicker() async {
    dateTimeRange = await showDateRangePicker(
          builder: (context, child) => Theme(
            data: ThemeData(primarySwatch: Colors.green),
            child: child!,
          ),
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2024),
        ) ??
        dateTimeRange;
    setState(() {});
  }

  attachImage() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["png", "jpeg", "jpg"],
    );
    if (result == null) return;
    selectedFileName = result.files.first.name;
    selectedFilePath = result.files.first.path ?? "";
    setState(() {});
  }

  captureImage(bool isCamera) async {
    var result = await ImagePicker().pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear);
    if (result == null) return;
    selectedFileName = result.name;
    selectedFilePath = result.path;
    setState(() {});
  }

  submit() async {
    var controller = Get.find<PickupController>();
    if (weightController.text.isEmpty ||
        dateTimeRange == null ||
        timeController.text.isEmpty ||
        selectedFilePath.isEmpty) {
      controller.newRequestErrorText = "Please attempt all fields";
      setState(() {});
      return;
    }
    showLoading = true;
    setState(() {});
    if (await controller.newRequest(
      weightController.text,
      timeController.text,
      "${dateTimeRange!.start.day}-${dateTimeRange!.start.month}-${dateTimeRange!.start.year}",
      "${dateTimeRange!.end.day}-${dateTimeRange!.end.month}-${dateTimeRange!.end.year}",
      selectedFilePath,
    )) {
      Get.back(result: true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("New Request Succesfull"),
        backgroundColor: Colors.green,
      ));
      return;
    }
    showLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PickupController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "New Request",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            showLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white))
                : IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: submit,
                  )
          ],
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (controller.newRequestErrorText.isNotEmpty)
              Column(
                children: [
                  Text(
                    controller.newRequestErrorText,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Select Pickup Date",
                  style: GoogleFonts.montserrat(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(height: 8),
                dateTimeRange != null
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${DateFormat("d MMMM").format(dateTimeRange!.start)} - ${DateFormat("d MMMM").format(dateTimeRange!.end)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: datePicker,
                              icon: const Icon(Icons.calendar_month),
                              label: const Text("Change"),
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.green.shade100,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : TextButton.icon(
                        onPressed: datePicker,
                        icon: const Icon(Icons.calendar_month),
                        label: dateTimeRange == null
                            ? const Text("Select Date")
                            : Text(
                                "${DateFormat("d MMMM").format(dateTimeRange!.start)} - ${DateFormat("d MMMM").format(dateTimeRange!.end)}"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.green),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green.shade100),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Attach an Image",
                  style: GoogleFonts.montserrat(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(height: 8),
                if (selectedFilePath.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        selectedFileName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(width: 16),
                      Expanded(
                          child: TextButton.icon(
                        onPressed: () {
                          selectedFileName = selectedFilePath = "";
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.red),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade100),
                        ),
                      )),
                    ],
                  ),
                if (selectedFilePath.isEmpty)
                  Row(
                    children: [
                      Expanded(
                          child: TextButton.icon(
                        onPressed: () => captureImage(true),
                        icon: const Icon(Icons.camera),
                        label: const Text("Camera"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue.shade100),
                        ),
                      )),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => captureImage(false),
                          icon: const Icon(Icons.image),
                          label: const Text("Gallery"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.green),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade100),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Tenative Weight",
              style: GoogleFonts.montserrat(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            CustomTextField(
              controller: weightController,
              inputType: TextInputType.phone,
              suffix: const TextButton(onPressed: null, child: Text("KG")),
            ),
            SizedBox(height: 16),
            Text(
              "Time slot",
              style: GoogleFonts.montserrat(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            DropdownButtonFormField<String>(
              onChanged: (_) {
                timeController.text = _ ?? "";
              },
              items: const ["9AM - 12PM", "1PM - 4PM", "4PM - 8PM"]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}
