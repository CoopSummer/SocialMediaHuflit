import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/LandingPage/landingServices.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  late List<File> uploadPostImage;
  List<File> get getUploadPost => uploadPostImage;
  late List<String> uploadPostImageUrl;
  List<String> get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  late UploadTask imageUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    if (source == ImageSource.camera) {
      uploadPostImage = [];
      final uploadPostImageVal = await picker.getImage(source: source);
      uploadPostImageVal == null
          ? print('Select Image')
          : uploadPostImage.add(File(uploadPostImageVal.path));
    } else {
      final uploadPostImageVal = await picker.pickMultiImage();
      uploadPostImageVal == null
          ? print('Select Image')
          : {
              uploadPostImage =
                  uploadPostImageVal.map((e) => File(e.path)).toList()
            };
    }
    // print(uploadPostImage.path);

    uploadPostImage == null
        ? print('Image upload error')
        : showPostImage(context);
    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    uploadPostImageUrl = [];
    for (File e in uploadPostImage) {
      Reference imageReference = FirebaseStorage.instance
          .ref()
          .child('post/${e.path}/${Timeline.now}');
      imageUploadTask = imageReference.putFile(e);
      await imageUploadTask
          .whenComplete(() => {print('Post image uploaded to storage')});
      imageReference.getDownloadURL().then((imageUrl) {
        uploadPostImageUrl.add(imageUrl);
      });
    }

    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () => {
                        pickUploadPostImage(context, ImageSource.gallery)
                            .onError((error, stackTrace) => print(error))
                      },
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () =>
                          {pickUploadPostImage(context, ImageSource.camera)},
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.425,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider(
                        items: uploadPostImage
                            .map((e) => Image.file(e, fit: BoxFit.contain))
                            .toList(),
                        options: CarouselOptions(
                            autoPlay: false, enableInfiniteScroll: false),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          child: Text('Reselect',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {}),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text('Confirm Image',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            uploadPostImageToFirebase().whenComplete(() {
                              editPostSheet(context);
                              print("Image uploaded");
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom * 0.4),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.image_aspect_ratio,
                                    color: constantColors.greenColor,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.fit_screen,
                                    color: constantColors.yellowColor,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          width: 300,
                          child: CarouselSlider(
                              items: uploadPostImage
                                  .map((e) => Image.file(
                                        e,
                                        fit: BoxFit.contain,
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                  autoPlay: false,
                                  enableInfiniteScroll: false)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: Image.asset('assets/icons/sunflower.png'),
                        ),
                        Container(
                            height: 110,
                            width: 5.0,
                            color: constantColors.blueColor),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              maxLength: 100,
                              controller: captionController,
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                              decoration: InputDecoration(
                                  hintText: 'Add a caption ',
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    child: Text('Share',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                    onPressed: () async {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .uploadPostData(captionController.text, {
                        'postimage': getUploadPostImageUrl,
                        'caption': captionController.text,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserName,
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInItUserEmail,
                      }).whenComplete(() {
                        captionController.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    color: constantColors.blueColor,
                  )
                ],
              ),
            ),
          );
        });
  }
}
