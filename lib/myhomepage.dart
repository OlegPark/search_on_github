import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'topnavigationbar.dart';
import 'user.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<User> _users = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
  const int pageSize = 100;
  int pageCount = 1;
  Set<User> users = {};

  while (true) {
    final response = await http.get(Uri.parse('https://api.github.com/users?page=$pageCount&per_page=$pageSize'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      for (var jsonUser in jsonData) {
        final userResponse = await http.get(Uri.parse('https://api.github.com/users/${jsonUser['login']}'));
        if (userResponse.statusCode == 200) {
          final userJson = jsonDecode(userResponse.body);
          User user = User.fromJson(userJson);
          users.add(user); 
        }
      }
      pageCount++;
    } else {
      break;
    }

    if (users.length >= 100) {
      break;
    }
  }

  final userList = users.toList();
  userList.sort((a, b) => a.username.compareTo(b.username));

  setState(() {
    _users = userList;
    _loading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchBar();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TopNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Expanded(
            child: _loading
              ? Center(child: CircularProgressIndicator())
                : _getPage(_currentIndex),
          ),
        ],
      ),
    );
  }

  void _showSearchBar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          actions: [
            ElevatedButton(
              child: Text('Search'),
              onPressed: () {
                _searchUsers();
              },
            ),
          ],
        );
      },
    );
  }

  void _searchUsers() {
    List<User> searchResults = _users.where((user) {
      return user.username.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    _displaySearchResults(searchResults);
  }

  void _displaySearchResults(List<User> searchResults) {
  Widget searchPage;
  if (searchResults.every((user) => user.username.startsWith(RegExp(r'[A-H]')))) {
    searchPage = Page1(users: searchResults);
  } else if (searchResults.every((user) => user.username.startsWith(RegExp(r'[I-P]')))) {
    searchPage = Page2(users: searchResults);
  } else {
    searchPage = Page3(users: searchResults);
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => searchPage),
  );
}

  Widget _getPage(int index) {
    List<User> users;
    switch (index) {
      case 0:
        users = _users.where((user) => user.username.startsWith(RegExp(r'[A-Ha-h]'))).toList();
        break;
      case 1:
        users = _users.where((user) => user.username.startsWith(RegExp(r'[I-Pi-p]'))).toList();
        break;
      case 2:
        users = _users.where((user) => user.username.startsWith(RegExp(r'[Q-Zq-z]'))).toList();
        break;
      default:
        throw Exception('Invalid page index');
    }
    return [
      Page1(users: users),
      Page2(users: users),
      Page3(users: users),
    ][index];
  }
}