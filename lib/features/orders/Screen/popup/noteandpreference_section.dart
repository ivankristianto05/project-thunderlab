import 'package:flutter/material.dart';
import 'package:kontena_pos/constants.dart';
import 'package:kontena_pos/data/addons_preference.dart';

class NotesAndPreferenceSection extends StatefulWidget {
  final String type;
  final int selectedPreferenceIndex;
  final Function(int, String) onPreferenceSelected;
  final Function(String) onNotesChanged;
  final String initialNotes;

  NotesAndPreferenceSection({
    required this.type,
    required this.selectedPreferenceIndex,
    required this.onPreferenceSelected,
    required this.onNotesChanged,
    this.initialNotes = '', // Set default value if not provided
  });

  @override
  _NotesAndPreferenceSectionState createState() => _NotesAndPreferenceSectionState();
}

class _NotesAndPreferenceSectionState extends State<NotesAndPreferenceSection> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialNotes);
    _notesController.addListener(() {
      widget.onNotesChanged(_notesController.text);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan data dari preference_data.dart
    List<String> preferences = preferencesByType[widget.type] ?? [];
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: 'Input Here',
            ),
          ),
          SizedBox(height: 8.0),
          Text('Preference:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(preferences.length, (index) {
                  final preference = preferences[index];
                  final isSelected = widget.selectedPreferenceIndex == index;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            // Deselect if the same preference is selected
                            widget.onPreferenceSelected(-1, '');
                          } else {
                            // Select the new preference
                            widget.onPreferenceSelected(index, preference);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? buttonselectedcolor : Colors.white,
                            border: Border.all(
                                color: isSelected ? buttonselectedcolor : Colors.grey),
                          ),
                          child: ListTile(
                            title: Text(
                              preference,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0), // Add spacing between ListTiles
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
