import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_task/screens/reminder_setup.dart';

class ProfileScreen extends StatefulWidget {
  final bool isOwnProfile;

  const ProfileScreen({Key? key, required this.isOwnProfile}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileScreen> {
  final String lastNoteDate = "10/9/20";
  final int timeRemindersCount = 5;
  final int locationRemindersCount = 2;
  List<Notes> notesList = [
    Notes(
      title: 'Hiking',
      description: 'Hiking in the mountains',
      date: '12 Sept 2024',
      url: 'https://plus.unsplash.com/premium_photo-1663036994694-a8d86b8466d8?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Notes(
      title: 'Beach Walk',
      description: 'Morning walk along the beach',
      date: '15 Sept 2024',
      url: 'https://plus.unsplash.com/premium_photo-1667667720309-54108681d0e0?q=80&w=1888&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Notes(
      title: 'City Tour',
      description: 'Exploring the city landmarks',
      date: '18 Sept 2024',
      url: 'https://plus.unsplash.com/premium_photo-1694475148756-c19a66f66548?q=80&w=1886&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Notes(
      title: 'Food Tasting',
      description: 'Tasting various local cuisines',
      date: '20 Sept 2024',
      url: 'https://images.unsplash.com/photo-1566995541428-f2246c17cda1?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Notes(
      title: 'Art Exhibition',
      description: 'Visit to the contemporary art museum',
      date: '22 Sept 2024',
      url: 'https://images.unsplash.com/photo-1619524808512-9648764356f4?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
  ];

  final List<String> userNotes = ["Public Note 1", "Public Note 2"];
  final List<String> sortOptions = ["Most Liked", "Earliest", "Latest"];
  String selectedSortOption = "Latest";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF6FF),
        title: Text(widget.isOwnProfile ? "Your Profile" : "User's Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildReminderSection(),
            const SizedBox(height: 20),
            _buildLikedNotesSection(),
            const SizedBox(height: 20),
            _buildNotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderSetupScreen()));
            },
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), // Placeholder image
            ),
          ),
          const SizedBox(height: 18),
          Text(
            widget.isOwnProfile ? "John Doe" : "Other User",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Krub',
              fontWeight: FontWeight.w700,

            ),
          ),

        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildReminderTile(Icons.note_alt_outlined, 'Last Note', lastNoteDate),
            _buildReminderTile(Icons.timer_sharp, 'Reminders', '$timeRemindersCount'),

            _buildReminderTile(Icons.location_on_outlined, 'Locations', '$locationRemindersCount'),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTile(IconData icon, String title, String value) {
    return Container(

      width: 100,
      child: Column(
        children: [
          Icon(icon, size: 30,color:  Color(0xFF454545), ),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontFamily: 'Hauora',
              fontWeight: FontWeight.w700,

            ),
          )
        ],
      ),
    );
  }


  Widget _buildLikedNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Liked Notes:", style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showNoteBottomSheet(notesList[index].title),
                child: Stack(
                  children: [
                    // The background image with caching
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(notesList[index].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // The semi-transparent black overlay
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    // The white text at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Text(
                          notesList[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showNoteBottomSheet(String note) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note, style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10),
              Text("Detailed information about $note."),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isOwnProfile) _buildSortOptions(),
        const SizedBox(height: 10),
        _buildUserNotesList(),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Sort by:", style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(

          value: selectedSortOption,
          items: sortOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedSortOption = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildUserNotesList() {
    final notes = widget.isOwnProfile ? notesList : userNotes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.88, -0.47),
                  end: Alignment(-0.88, 0.47),
                  colors: [Color(0xFF2B57F8), Color(0xFF4A7EE2), Color(0xFF8ED6B3)],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            SizedBox(width: 10,),
            Text("User Notes:", style: Theme.of(context).textTheme.subtitle1),
          ],
        ),

        const SizedBox(height: 10),
        ...notes.reversed.map((note) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(note.toString()),
            leading: const Icon(Icons.note),
            onTap: () => _showNoteBottomSheet(note.toString()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            tileColor: Colors.white,
          ),
        )),
      ],
    );
  }
}



class Notes{
  final String title;
  final String description;
  final String date;
  final String url;
  Notes({required this.title, required this.description, required this.date, required this.url});
}