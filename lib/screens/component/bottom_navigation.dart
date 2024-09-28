



import 'dart:io';

import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:test_task/screens/home_screen.dart';
import 'package:whatsapp_camera/camera/camera_whatsapp.dart';

import '../create_screen.dart';
import '../profile_view.dart';
import '../reminder_setup.dart';
import 'camera_preview.dart';


class CurvedBottomNavigation extends StatefulWidget {
  const CurvedBottomNavigation({super.key});

  @override
  State<CurvedBottomNavigation> createState() => _CurvedBottomNavigationState();
}

class _CurvedBottomNavigationState extends State<CurvedBottomNavigation> {

  int _currentIndex = 0;
  bool _isCreateMenuOpen = false;

  void _onItemTapped(int index) {
    if (index == 2) {
      _toggleCreateMenu();
    } else {
      setState(() {
        _isCreateMenuOpen = false;
      });
    }
  }

  void _toggleCreateMenu() {
    setState(() {
      _isCreateMenuOpen = !_isCreateMenuOpen;
    });
  }


  final List<Widget> _screens = [
    HomeScreen(),
    ReminderSetupScreen(),
    CreateScreen(),
    ProfileScreen(isOwnProfile: true,),

  ];

  void _openTextNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TextNoteScreen()),
    );
  }

  void _openVoiceNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VoiceNoteScreen()),
    );
  }





  void _openImageNote() async {
    // Check for camera permission
    PermissionStatus gallery = await Permission.storage.request();
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      // If permission is granted, open the camera
      List<File>? res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WhatsappCamera(),
        ),
      );
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // If permission is denied, show a dialog or a message
      print('Camera permission is denied.');
    }
  }

  void _openVideoNote() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      final cameras = await availableCameras();
      final firstCamera = cameras[1];
      // If permission is granted, navigate to the live camera screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  CameraPreviewScreen(camera: firstCamera),
        ),
      );
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // If permission is denied, show a message
      print('Camera permission is denied.');
    }
  }

  void closeCreateMenu() {
    setState(() {
      _isCreateMenuOpen = false;

        _currentIndex = 0;  // Change the screen based on the index

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            index: _currentIndex,
            color: Colors.black,
            backgroundColor: Colors.white,
            items: const <Widget>[
              Icon(Icons.home, size: 30,color: Colors.white,),        // Home
              Icon(Icons.timer_sharp, size: 30,color: Colors.white,),      // Profile
              Icon(Icons.create, size: 30,color: Colors.white,),      // Create (Pencil)
              Icon(Icons.person, size: 30,color: Colors.white,),       // Reminder
            ],
            onTap: (index) {
              _onItemTapped(index);
              setState(() {
                _currentIndex = index;  // Change the screen based on the index
              });
            },
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,  // Load the corresponding screen based on index
          ),
        ),
        if (_isCreateMenuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Close the menu if the background is tapped
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: CreateMenu(
                    onTextNote: _openTextNote,
                    onVoiceNote: _openVoiceNote,
                    onImageNote: _openImageNote,
                    onVideoNote: _openVideoNote,
                    onClose:closeCreateMenu,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}





/// Widget that replicates the centered circular buttons for creating a new note.
class CreateMenu extends StatelessWidget {
  final VoidCallback onTextNote;
  final VoidCallback onVoiceNote;
  final VoidCallback onImageNote;
  final VoidCallback onVideoNote;
  final VoidCallback onClose;

  const CreateMenu({
    required this.onTextNote,
    required this.onVoiceNote,
    required this.onImageNote,
    required this.onVideoNote, required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircularButton(
              icon: Icons.text_fields,
              color: Colors.pink,
              label: 'Text',
              onPressed: onTextNote,
            ),
            SizedBox(width: 20,),
            _buildCircularButton(
              icon: Icons.mic,
              color: Colors.purple,
              label: 'Voice',
              onPressed: onVoiceNote,
            ),
          ],
        ),
        SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircularButton(
              icon: Icons.camera_alt,
              color: Colors.pinkAccent,
              label: 'Image',
              onPressed: onImageNote,
            ),

            SizedBox(width: 40,),
            _buildCircularButton(
              icon: Icons.calendar_view_day,
              color: Colors.yellow,
              label: 'other day',
              onPressed: onVideoNote,
            ),
          ],
        ),

        Center(
          child:  _buildCircularButton(
            icon: Icons.cancel,
            color: Colors.pinkAccent,
            label: '',
            onPressed: onClose,
          ),
        )
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: color,
          onPressed: onPressed,
          child: Icon(icon),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white,fontSize: 12),
        ),
      ],
    );
  }
}

