import 'package:flutter/material.dart';

class RoundBtn extends StatelessWidget {
  final bool loading;
  final String title;
  final VoidCallback onTap;
  const RoundBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 40,
          // width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue[400],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: loading
                ? const CircularProgressIndicator()
                : Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                  ),
          ),
        ),
      ),
    );
  }
}
