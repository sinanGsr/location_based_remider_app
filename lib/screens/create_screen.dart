import 'dart:async';

import 'package:flutter/material.dart';



class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.grey.shade300,Colors.white,Colors.white], // Black to dark white
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              )
          
            ]
          
              ),
        )
      ),
    );
  }
}



class TextNoteScreen extends StatelessWidget {
  const TextNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Note")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Write your note here...',
          ),
        ),
      ),
    );
  }
}

class VoiceNoteScreen extends StatefulWidget {
  const VoiceNoteScreen({super.key});

  @override
  State<VoiceNoteScreen> createState() => _VoiceNoteScreenState();
}

class _VoiceNoteScreenState extends State<VoiceNoteScreen> {

  bool _isRecording = false;


  void toggleRecorder() {
    setState(() {
      _isRecording = !_isRecording;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Note"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle recording an entry
                  },
                  child: Text('Record an entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    textStyle: TextStyle(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    // Handle ask entries action
                  },
                  child: Text('Ask your entries'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              "Tap to record",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                toggleRecorder();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade600,
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

            SizedBox(height: 20),
            if(_isRecording)
            CustomRecordingWaveWidget(),
            SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TextNoteScreen()),
                );
              },
              icon: Icon(Icons.edit),
              label: Text("Write instead"),
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "What are you looking forward to in the next month?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.brown),
                    onPressed: () {
                      // handle mic input
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor:
                    index == 0 ? Colors.brown : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}



// class CameraWithGalleryScreen extends StatelessWidget {
//   const CameraWithGalleryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             flex: 8,
//             child: CameraView(), // WhatsApp Camera view to show the live camera
//           ),
//           Expanded(
//             flex: 2,
//             child: Container(
//               color: Colors.black.withOpacity(0.7),
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 10, // For demo purposes, you can load the actual gallery images
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(child: Text('Image $index')),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




class CustomRecordingWaveWidget extends StatefulWidget {
  const CustomRecordingWaveWidget({super.key});

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  final List<double> _heights = [0.05, 0.07, 0.1, 0.07, 0.05];
  Timer? _timer;

  @override
  void initState() {
    _startAnimating();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimating() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        // This is a simple way to rotate the list, creating a wave effect.
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: MediaQuery.sizeOf(context).height * height,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
          );
        }).toList(),
      ),
    );
  }
}