import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatsScreen extends StatefulWidget {
  final Contact contact;

  ChatsScreen({required this.contact});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  bool isTyping = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = []; // Store text and image messages

  Future<void> _openGallery() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        for (var image in images) {
          messages.add({"type": "image", "content": image.path});
        }
      });
    }
  }

  Future<void> _showAudioFiles() async {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Get device storage path
      Directory? directory = await getExternalStorageDirectory();

      if (directory != null) {
        List<FileSystemEntity> files =
        directory.listSync(recursive: true, followLinks: false);

        // Filter audio files
        List<FileSystemEntity> audioFiles = files.where((file) {
          final path = file.path.toLowerCase();
          return path.endsWith('.mp3') ||
              path.endsWith('.wav') ||
              path.endsWith('.aac') ||
              path.endsWith('.ogg') ||
              path.endsWith('.m4a');
        }).toList();

        // Display the audio files
        if (audioFiles.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioFilesScreen(audioFiles: audioFiles),
            ),
          );
        } else {
          _showNoAudioFoundMessage();
        }
      }
    } else {
      _showPermissionDeniedMessage();
    }
  }

  void _showPermissionDeniedMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text("Storage permission is required to access audio files."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showNoAudioFoundMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Audio Files"),
        content: Text("No audio files were found on your device."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({"type": "text", "content": _messageController.text});
        _messageController.clear();
        isTyping = false;
      });
    }
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    if (message["type"] == "text") {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message["content"],
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    } else if (message["type"] == "image") {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(message["content"]),
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildAttachmentOption(Icons.insert_drive_file, 'Document', Colors.deepPurple),
                  _buildAttachmentOption(Icons.camera_alt, 'Camera', Colors.pink, () {}),
                  _buildAttachmentOption(Icons.photo, 'Gallery', Colors.purpleAccent, _openGallery),
                  _buildAttachmentOption(Icons.headset, 'Audio', Colors.orange, _showAudioFiles),
                  _buildAttachmentOption(Icons.location_on, 'Location', Colors.green),
                  _buildAttachmentOption(Icons.currency_rupee, 'Payment', Colors.teal),
                  _buildAttachmentOption(Icons.person, 'Contact', Colors.blue),
                  _buildAttachmentOption(Icons.poll, 'Poll', Colors.teal),
                  _buildAttachmentOption(Icons.image, 'Imagine', Colors.blueAccent),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 30,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 8),
            widget.contact.avatar != null && widget.contact.avatar!.isNotEmpty
                ? CircleAvatar(
              backgroundImage: MemoryImage(widget.contact.avatar!),
              radius: 16,
            )
                : CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 16,
              child: Icon(Icons.person, color: Colors.grey),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.contact.displayName ?? 'No Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.videocam, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.call, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_emotions, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Message",
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              setState(() {
                                isTyping = text.isNotEmpty;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_file, color: Colors.grey),
                          onPressed: _showAttachmentOptions,
                        ),
                        IconButton(
                          icon: Icon(Icons.currency_rupee, color: Colors.grey),
                          onPressed: _showAttachmentOptions,
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.grey),
                          onPressed: _showAttachmentOptions,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade800,
                    child: Icon(
                      isTyping ? Icons.send : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AudioFilesScreen extends StatelessWidget {
  final List<FileSystemEntity> audioFiles;

  AudioFilesScreen({required this.audioFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Files"),
      ),
      body: ListView.builder(
        itemCount: audioFiles.length,
        itemBuilder: (context, index) {
          FileSystemEntity file = audioFiles[index];
          return ListTile(
            title: Text(file.path.split('/').last),
            onTap: () {
              Navigator.pop(context, file.path); // Return the selected audio path
            },
          );
        },
      ),
    );
  }
}
