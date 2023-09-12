import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zwc/model/certificate_model.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen(this.model, {super.key});
  final CertificateModel model;
  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  bool savingImage = false, savingPDF = false, savingToGallery = false;

  @override
  void initState() {
    super.initState();
  }

  shareWithOtherApp() async {
    var filePath = '${(await getTemporaryDirectory()).path}/my-image.jpg';
    File file = File(filePath);
    await file.writeAsBytes(widget.model.ImageBytes);
    Share.shareFiles(
      [filePath],
      text:
          r"Hey, I just earned this certificate for my contributions to the environment with Zero waste citizen app. Check out what I did to make a difference! Download the app here: https://play.google.com/store/apps/details?id=com.fctech.customer&hl=en_ZA&gl=US. Let's all do our part to make the world a better place.",
    );
  }

  Future<void> downloadPDF() async {
    setState(() {
      savingPDF = true;
    });
    final String fileName = "zwc certificate " +
        widget.model.pdfURL.split('/').last.split(".").first +
        "_" +
        DateTime.now().microsecondsSinceEpoch.toString() +
        ".pdf";
    final Directory? directory = await getExternalStorageDirectory();
    final String? directoryPath = directory?.path;
    final String? savePath =
        await FilePicker.platform.getDirectoryPath() ?? directoryPath;

    if (savePath == null) {
      setState(() {
        savingPDF = false;
      });
      return;
    }

    var filePath = '$savePath/$fileName';
    final response = await http.get(Uri.parse(widget.model.pdfURL));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      savingPDF = false;
    });
  }

  downloadImage() async {
    setState(() {
      savingImage = true;
    });
    final String fileName = "zwc certificate " +
        widget.model.imageURL.split('/').last.split(".").first +
        "_" +
        DateTime.now().microsecondsSinceEpoch.toString() +
        ".jpg";
    final Directory? directory = await getExternalStorageDirectory();
    final String? directoryPath = directory?.path;
    final String? savePath =
        await FilePicker.platform.getDirectoryPath() ?? directoryPath;

    if (savePath == null) {
      setState(() {
        savingImage = false;
      });
      return;
    }

    var filePath = '$savePath/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(widget.model.ImageBytes);
    setState(() {
      savingImage = false;
    });
    return;
  }

  saveToGallery() async {
    savingToGallery = true;
    setState(() {});
    var filePath = '${(await getTemporaryDirectory()).path}/my-image.jpg';
    File file = File(filePath);
    await file.writeAsBytes(widget.model.ImageBytes);
    await GallerySaver.saveImage(filePath);
    savingToGallery = false;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Certificate has been saved to your gallery!"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green.shade900],
                    ),
                  ),
                ),
              ),
              Expanded(child: SizedBox())
            ],
          )),
          Positioned.fill(
              child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: Icon(Icons.clear, color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5 * 0.05),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.certificate,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Great Job!",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "You have been certified for your impact on the environment",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5 * 0.1),
                  Image.memory(widget.model.ImageBytes),
                  SizedBox(height: 16),
                  Text(
                    "Share your impact with your friends",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ShareIconWidgets(
                            callBack: shareWithOtherApp,
                            iconData: FontAwesomeIcons.shareNodes,
                            color: Colors.green.shade600,
                            title: "Share",
                          ),
                          SizedBox(width: 16),
                          savingToGallery
                              ? Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ShareIconWidgets(
                                  iconData: FontAwesomeIcons.image,
                                  callBack: saveToGallery,
                                  color: Colors.blue,
                                  title: "Save to Gallery ",
                                ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          savingImage
                              ? Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ShareIconWidgets(
                                  iconData: FontAwesomeIcons.fileImage,
                                  callBack: downloadImage,
                                  color: Colors.black,
                                  title: "Download Image",
                                ),
                          SizedBox(width: 16),
                          savingPDF
                              ? Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ShareIconWidgets(
                                  iconData: FontAwesomeIcons.filePdf,
                                  callBack: downloadPDF,
                                  color: Colors.red,
                                  title: "Download PDF",
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class ShareIconWidgets extends StatelessWidget {
  const ShareIconWidgets({
    Key? key,
    required this.iconData,
    required this.color,
    required this.callBack,
    required this.title,
  }) : super(key: key);
  final IconData iconData;
  final Color color;
  final VoidCallback callBack;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
          onPressed: callBack,
          icon: Icon(iconData),
          label: FittedBox(child: Text(title)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color.withOpacity(0.2)),
            foregroundColor: MaterialStateProperty.all(color),
          )),
    );
  }
}
