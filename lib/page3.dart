import 'package:flutter/material.dart';
import 'user.dart';

class Page3 extends StatelessWidget {
  final List<User> users;

  Page3({required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q-Z'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].username),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(users[index].avatarUrl),
            ),
            subtitle: Text('${users[index].followers} followers'),
          );
        },
      ),
    );
  }
}