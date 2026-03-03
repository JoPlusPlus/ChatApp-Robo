import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

 Future<bool> init() async {
  if (!_isRecorderInitialized) {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }
  return true;
}

  Future<String?> startRecording() async {
    if (!_isRecorderInitialized) await init();

    try {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      return path;
    } catch (e) {
      print("Error starting recording: $e");
      return null;
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecorderInitialized) return;
    try {
      await _recorder.stopRecorder();
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Future<File?> getRecorded(String filePath) async {
    try {
      if (filePath.isNotEmpty && await File(filePath).exists()) {
        return File(filePath);
      }
      return null;
    } catch (e) {
      print("Error getting recorded file: $e");
      return null;
    }
  }
Future<String?> getFilePath() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';
  } catch (e) {
    print("Error getting file path: $e");
    return null;
  }
}
  void dispose() {
    _recorder.closeRecorder();
    _isRecorderInitialized = false;
  }
}