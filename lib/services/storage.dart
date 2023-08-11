import 'package:file_picker/file_picker.dart';

import 'auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as i;
import 'dart:developer' as d;



class StorageService{

  PlatformFile? pickedFile;

  String? img;
  Future<String?> selectFile() async{
    try{
      d.log('selectfile function');
      final result = await FilePicker.platform.pickFiles(type: FileType.image,);
      if(result == null) return "";

      pickedFile = result.files.first;

      final file = i.File(pickedFile!.path!);
      final path = 'pfp/${AuthService().user?.uid}';
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file); //upload to firebase storage

      img = await ref.getDownloadURL(); //retrieve that image's url
      d.log(img!);
      await AuthService().user?.updatePhotoURL(img!); // set users pfp
      // await FirestoreSevice().addPFP(img!); // store in user document
      return img;
    }
    catch (e){
      d.log(e.toString());
    }
    return "";
  }

  // Future<String> getImage() async{

  //   //also upload from here
  //   final path = 'pfp/${AuthService().user?.uid}';
  //   final ref = FirebaseStorage.instance.ref().child(path);
  //   String x = await ref.getDownloadURL();
  //   return x;
  // }
}