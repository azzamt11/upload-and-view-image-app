import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:typed_data';

import '../Helper/Functions.dart';
import '../NetworkHandler/ApiClient.dart';

class ShowPage extends StatefulWidget {
  const ShowPage({Key? key}) : super(key: key);

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  int imageState= 0;
  bool imageHasBeenLoaded= false;
  final colorArray= [Colors.grey, Colors.blueAccent];
  late Uint8List finalDecodedImage;
  final idController= TextEditingController();
  bool loadingState= false;
  late String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
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
                        child: imageHasBeenLoaded? Container(
                          decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(finalDecodedImage))),
                        ) : const Center(
                            child: Text('No Image', style: TextStyle(fontSize: 15),)
                        )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              if (imageState==0) {
                                print('condition type 1 : $imageState');
                                ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('You have not enter any id'));
                              } else if (loadingState==false) {
                                print('condition type 2 : $imageState');
                                setState(() {
                                  loadingState= true;
                                  id= idController.text;
                                });
                                String imageString= await ApiClient().getImage(id);
                                setState(() {
                                  finalDecodedImage= Functions().convertStringToUin8List(imageString);
                                  loadingState= false;
                                  imageHasBeenLoaded=true;
                                  imageState==0;
                                });
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 105,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: colorArray[imageState]),
                              child: Center(
                                child: Text(!loadingState? 'View Image': 'Loading...', style: TextStyle(fontSize: 15),),
                              ),
                            ),
                          ),
                          inputTextField('id', idController),
                        ]
                    )
                  ]
              )
          )
      ),
    );
  }

  Widget inputTextField(String string, controller) {
    return(
        Container(
          height: 60,
          width: 90,
          decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1), borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: TextField(
                onChanged: (text) {
                  if (idController.text.length>0) {
                    setState(() {
                      imageState= 1;
                    });
                  } else {
                    setState(() {
                      imageState= 0;
                    });
                  }
                },
                controller: controller,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  isDense: true,
                  hintText: string,
                  border: InputBorder.none,
                )
            ),
          ),
        )
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
