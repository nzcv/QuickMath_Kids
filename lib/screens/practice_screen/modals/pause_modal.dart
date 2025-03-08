import 'package:flutter/material.dart';

class PauseDialog extends StatelessWidget {
  final VoidCallback onResume; 

  const PauseDialog({super.key, required this.onResume});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Center(
        child: Text(
          'Quiz is Paused',
          style: TextStyle(color: Color(0xFF009DDC)), 
        ),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context); 
              onResume(); 
            },
            child: const Text(
              'Resume Quiz',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }
}
