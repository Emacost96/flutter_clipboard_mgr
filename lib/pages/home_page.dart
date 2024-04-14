import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clipboard_mgr/components/clipboard_item.dart';
import 'package:flutter_clipboard_mgr/services/clipboard_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchBarController;
  String clipboardLatestValue = '';

  @override
  void initState() {
    super.initState();
    _getClipboardLatesValue();
    _searchBarController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarController.dispose();
  }

  void _getClipboardLatesValue() async {
    String? data = await ClipboardService().getClipboardData();
    setState(() {
      clipboardLatestValue = data?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(121, 48, 48, 48),
      body: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: TextField(
              controller: _searchBarController,
              style: TextStyle(color: Colors.grey[300], fontSize: 25),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 8.5),
                      child:
                          Icon(CupertinoIcons.search, color: Colors.grey[300])),
                  hintText: 'Search in notes',
                  hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ))
          ],
        ),
        SizedBox(height: 20),
        ClipboardItem(text: clipboardLatestValue)
      ]),
    );
  }
}
