import 'package:flutter/material.dart';

class AddMedsHeader extends StatelessWidget {
  const AddMedsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
