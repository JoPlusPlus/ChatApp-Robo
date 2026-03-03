
import 'dart:io';

import 'package:chatapp/core/constant/const.dart';
import 'package:firebase_storage/firebase_storage.dart';


class UploadService {
  Future<String?> uploadVoiceNote({
    required File audioFile,
    required String senderId,
  }) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${AppConstants.voiceNotesPath}/$senderId/${DateTime.now().millisecondsSinceEpoch}.m4a');

      await ref.putFile(audioFile);
      return await ref.getDownloadURL();
    } catch (e) {
        print("Error uploading voice note: $e");
      
      return null;
    }
  }
}