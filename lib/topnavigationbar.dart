import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  TopNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              onTap(0);
            },
            child: Text(
              'A-H',
              style: TextStyle(
              color: currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTap(1);
            },
            child: Text(
              'I-P',
              style: TextStyle(
                color: currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTap(2);
            },
            child: Text(
              'Q-Z',
              style: TextStyle(
                color: currentIndex == 2 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}