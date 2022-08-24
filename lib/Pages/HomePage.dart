import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

import '../Helper/Functions.dart';
import '../NetworkHandler/ApiClient.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final colorArray= [Colors.blueAccent, Colors.red];
  final stringArray= ['Chose Image', 'Remove Image'];
  final uploadStringArray= ['Upload Image', 'Loading...'];
  int pickState1= 0;
  int pickState2= 0;
  late Uint8List finalDecodedImage;
  late String imagePath;
  String responseString= 'no-response';
  bool loadingState= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  void openFile(PlatformFile finalFile) {
    OpenFile.open(finalFile.path!);
  }

  void changeColor() {
    print('state is changed');
    setState(() {
      pickState1= 1;
    });
  }

  Widget getBody() {
    var size= MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.all(20),
      child: Center(
          child: SizedBox(
              height: 340,
              width: size.width,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      color: const Color.fromRGBO(230, 230, 230, 1),
                      child: pickState1==1? Container(
                        decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(finalDecodedImage))),
                      ) : const Center(
                        child: Text('No Image Chosen', style: TextStyle(fontSize: 15),)
                      )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (pickState1==0) {
                                final image= await ImagePicker().pickImage(source: ImageSource.gallery);
                                if (image!= null) {
                                  imagePath = image.path;
                                  final decodedImage= File(imagePath);
                                  final decodedImageReadAsBytes= await decodedImage.readAsBytes();
                                  setState(() {
                                    pickState1= 1;
                                    finalDecodedImage= decodedImageReadAsBytes;
                                  });
                                } else {
                                  imagePath = '';
                                }
                              } else {
                                setState(() {
                                  pickState1= 0;
                                });
                              }
                            },
                            child: Container(
                                height: 60,
                                width: 100,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: colorArray[pickState1]),
                                child: Center(
                                  child: Text(stringArray[pickState1], style: const TextStyle(fontSize: 15)),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () async{
                              print('loadingState : $loadingState');
                              if (loadingState== false) {
                                setState(() {
                                  loadingState= true;
                                  pickState2= 1;
                                });
                                String imageString= Functions().convertUin8ListToString(finalDecodedImage);
                                String response= await ApiClient().postImage(imageString);
                                ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(responseString==''? 'Uploaded Successfully' : responseString));
                                setState(() {
                                  responseString= response;
                                  pickState2=0;
                                  loadingState= false;
                                });
                              }

                            },
                            child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: colorArray[pickState2]),
                                child: Center(
                                  child: Text(uploadStringArray[pickState2], style: TextStyle(fontSize: 15)),
                                )
                            ),
                          )
                        ]
                    )
                  ]
              )
          )
      ),
    );
  }

  SnackBar snackBarWidget(String message) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          setState(() {loadingState=false;});
        },
      ),
    );
    return snackBar;
  }
}
