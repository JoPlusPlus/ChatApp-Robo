import 'package:chatapp/features/data/chatservice.dart';
import 'package:chatapp/features/widget/chatbubbles.dart';
import 'package:chatapp/features/widget/messageinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';


class ChatScreen extends StatefulWidget {
  final String currentUserId;    
  final String receiverId;
  final String receiverName;
  final String? receiverImage;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
    this.receiverImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatCubit _chatCubit;
  List<String> tempRecordings = []; 
  bool isRecording = false;        


  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit(
      ChatService(),
      widget.currentUserId,      
      widget.receiverId,
    );

   
  }

  @override
  void dispose() {
    _chatCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>.value(
      value: _chatCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20, 
                  backgroundImage: widget.receiverImage != null
                      ? NetworkImage(widget.receiverImage!)
                      : null,
                  child: widget.receiverImage == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receiverName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                    
                      ),
                      BlocBuilder<ChatCubit, ChatState>(
                        builder: (context, state) {
                          if (state is ChatLoaded) {
                            return Text(
                              state.isTyping
                                  ? "typing..."
                                  : state.isOnline
                                      ? "Online"
                                      : "Offline", 
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
        ),

        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }

                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "No messages yet...",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(12),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[state.messages.length - 1 - index];
                        final isMe = message.senderId == widget.currentUserId;

                       return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment:
                                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              ChatBubble(
                                message: message,
                                isSender: isMe,
                              ),
                              const SizedBox(height: 2), 
                              Text(
                            
                                "${message.sentAt.hour.toString().padLeft(2, '0')}:${message.sentAt.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                        );
                      },
                    );

                                      }

                  return const SizedBox.shrink();
                },
              ),
            ),

            MessageInput(
              currentUserId: widget.currentUserId,
              receiverId: widget.receiverId,
            ),
          ],
        ),
      ),
    );
  }
}