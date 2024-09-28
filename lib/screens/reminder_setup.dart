import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';

class ReminderSetupScreen extends StatefulWidget {
  const ReminderSetupScreen({super.key});

  @override
  _ReminderSetupScreenState createState() => _ReminderSetupScreenState();
}

class _ReminderSetupScreenState extends State<ReminderSetupScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final MapController _mapController = MapController();
  LatLng _selectedLocation = LatLng(41.8781, -87.6298);
  double _radius = 3.0; // Default radius for location-based reminder
  DateTime? _selectedDate;
  String _taskTitle = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminder Setup"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Time-based Reminder"),
            Tab(text: "Location-based Reminder"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTimeBasedReminderUI(),
          _buildLocationBasedReminderUI(),
        ],
      ),
    );
  }

  // Time-based reminder screen
  Widget _buildTimeBasedReminderUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(  // Wrap the column in SingleChildScrollView to avoid overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title", style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Enter reminder title",
              ),
              onChanged: (value) {
                setState(() {
                  _taskTitle = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text("Date and Time", style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 8),
            _buildCalendar(),
            const SizedBox(height: 20),
            Text("Recurrence", style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: "Daily",
              items: <String>["Daily", "Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
            const SizedBox(height: 20),
            Text("My Tasks", style: Theme.of(context).textTheme.subtitle1),
            SizedBox(
              height: 200,  // Specify a height for the task list
              child: _buildTaskList(),
            ),
          ],
        ),
      ),
    );
  }


  // Calendar widget (replaces popup)
  Widget _buildCalendar() {
    return Column(
      children: [
        TableCalendar(
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
          },
          focusedDay: _selectedDate ?? DateTime.now(),
          firstDay: DateTime(2021),
          lastDay: DateTime(2025),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (selectedTime != null) {
              // Use selectedTime for the reminder
            }
          },
          child: const Text("Select Time"),
        ),
      ],
    );
  }

  // Task list widget (for My Tasks section)
  Widget _buildTaskList() {
    return ListView(
      children: [
        _buildTaskCard("Task 1", "2024-09-27 10:00 AM"),
        _buildTaskCard("Task 2", "2024-09-28 2:00 PM"),
        _buildTaskCard("Task 3", "2024-09-29 6:00 PM"),
      ],
    );
  }

  Widget _buildTaskCard(String title, String dateTime) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(dateTime),
      ),
    );
  }

  // Location-based reminder screen with flutter_map
  Widget _buildLocationBasedReminderUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Title", style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Enter reminder title",
            ),
          ),
          const SizedBox(height: 20),
          Text("Location", style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(height: 8),
          Expanded(  // Use Expanded to make the map take up available space
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _selectedLocation,
                  minZoom: 10.0,
                  maxZoom: 800,
                  onTap: (tapPosition, LatLng latlng) {
                    setState(() {
                      _selectedLocation = latlng;
                    });
                  },
                ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        point: _selectedLocation,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ]),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: LatLng(_selectedLocation.latitude - 0.001, _selectedLocation.longitude), // Adjusting the position slightly upwards
                          color: Colors.blue.withOpacity(0.5),
                          radius: _radius * 10, // Radius in meters
                        ),
                      ],
                    ),
                  ],

                ),

                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("Select Radius", style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(height: 8),
          Slider(
            value: _radius,
            min: 0,
            max: 10,
            divisions: 10,
            label: "${_radius.toStringAsFixed(1)} mi",
            onChanged: (double value) {
              setState(() {
                _radius = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            "Selected Location: (${_selectedLocation.latitude.toStringAsFixed(4)}, ${_selectedLocation.longitude.toStringAsFixed(4)})",
          ),
        ],
      ),
    );
  }

}
