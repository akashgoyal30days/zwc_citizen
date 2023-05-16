import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zwc/api/urls.dart';
import 'package:zwc/controllers/settings_controller.dart';
import 'package:zwc/screens/settings/update_user_profile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool showPictureLoading = false;

  updateProfilePicture() async {
    try {
      bool? isCamera = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => ImageSourceSelector(),
      );
      var result = await ImagePicker().pickImage(
          source: isCamera! ? ImageSource.camera : ImageSource.gallery);
      setState(() {
        showPictureLoading = true;
      });
      await Get.find<SettingsController>().updateProfilePicture(result!.path);
    } catch (e) {}
    setState(() {
      showPictureLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.green,
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      backgroundImage:
                          showPictureLoading || controller.image.isEmpty
                              ? null
                              : CachedNetworkImageProvider(
                                  URLS.baseURL + controller.image,
                                ),
                      child: showPictureLoading
                          ? CircularProgressIndicator()
                          : controller.image.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: MediaQuery.of(context).size.width *
                                      0.15,
                                  color: Colors.green,
                                )
                              : SizedBox(),
                      minRadius: MediaQuery.of(context).size.width * 0.15,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: updateProfilePicture,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Card(
              elevation: 10,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Personal details",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        )),
                        IconButton(
                          onPressed: () {
                            Get.to(() => UpdateUserProfile());
                          },
                          icon: Icon(Icons.edit, size: 16),
                        ),
                      ],
                    ),
                    Text(
                      controller.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.email,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 16,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.phone,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ImageSourceSelector extends StatelessWidget {
  const ImageSourceSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Cancel",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size:
                                MediaQuery.of(context).size.height * 0.3 * 0.3,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo,
                            color: Colors.green,
                            size:
                                MediaQuery.of(context).size.height * 0.3 * 0.3,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
