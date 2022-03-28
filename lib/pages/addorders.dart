import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:goapp/main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:goapp/GoogleDrive.dart';


class AddOrders extends StatefulWidget {

  const AddOrders({
    Key? key,
  }) : super(key: key);


  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  String title = '';
  String des = '';
  //late AnimationController loadingController;
  final drive = GoogleDrive();
  File? _file;
  PlatformFile? _platformFile;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']

    );

    if (file != null) {
      setState(() {
        _file = File(file.files.single.path!);
       // drive.uploadFileToGoogleDrive(_file!);
        _platformFile = file.files.first;
      });
    }
   // loadingController.forward();
  }
    @override
    void initState() {
     // loadingController = AnimationController(
     //   vsync: this,
     //   duration: const Duration(seconds: 10),
   //   )..addListener(() { setState(() {}); });

      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: Icon(Icons.arrow_back),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () => {add()},
                      child: Text("Save"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey)),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: selectFile,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.blue.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.folder_open, color: Colors.blue, size: 40,),
                          const SizedBox(height: 15,),
                          Text('Select your file', style: TextStyle(fontSize: 15, color: Colors.grey.shade400),),
                        ],
                      ),
                    ),
                  )
              ),
            ),
           // _platformFile != null
            Form(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        InputDecoration.collapsed(hintText: "Add Title"),
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'lato',
                        fontWeight: FontWeight.bold),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration.collapsed(hintText: "Add Note"),
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'lato',
                        fontWeight: FontWeight.bold),
                    onChanged: (val) {
                      des = val;
                    },
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }

  void add() async {
    
    String filelink='';
    String filename='';
    if (_file != null) {
      filelink= await drive.uploadFileToGoogleDrive(_file!);
      filename = _file!.path.split('/').last;

      print (filename);
    }
    CollectionReference ref = FirebaseFirestore.instance
        .collection('orders')
        .doc('go')
        .collection('notes');

   // var data = {'title': title, 'des': des, 'created': DateTime.now()};
    var data = {'title': title, 'des': des, 'filelink': filelink, 'filename': filename, 'created': DateTime.now()};
    ref.add(data);

    Navigator.pop(context);
  }
}
