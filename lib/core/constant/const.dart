class AppConstants {

  static const String usersCollection      = "users";
  static const String chatsCollection      = "chats";
  static const String messagesCollection = "messages";
  static const String voiceNotesPath = "voice_notes";


  static const String errorVoiceNot = "Voice notes not supported on this platform yet";
  static const String NoMessages    = "No messages yet...";
  static const String Recording         = "Recording...";
  static const String Playing           = "Playing...";
  }

class StatusText {
  static const String typing   = "typing...";
  static const String online   = "Online";
  static const String offline  = "Offline";

  static String lastSeen(DateTime? time) {
    if (time == null) return "Offline";
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inHours < 1)   return "${diff.inMinutes}m ago";
    if (diff.inDays < 1)    return "${diff.inHours}h ago";
    return "Last seen ${time.day}/${time.month}";
  }
}