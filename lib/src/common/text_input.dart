import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    required this.txtController,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController txtController;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.txtController,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        prefixIcon: Icon(widget.icon),
      ),
    );
  }
}
