import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clipboard_mgr/components/clipboard_item.dart';
import 'package:flutter_clipboard_mgr/services/clipboard_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ClipboardListener {
  late TextEditingController _searchBarController;
  late ScrollController _scrollController;
  String clipboardLatestValue = '';
  ClipboardService clipboardService = ClipboardService();
  List<ExtendedClipboardData> filteredClipboardData = [];
  bool isInternalCopy = false;

  @override
  void initState() {
    super.initState();
    _searchBarController = TextEditingController();
    filteredClipboardData = clipboardService.getClipboardData();
    _searchBarController.addListener(_onSearchBarChange);
    _scrollController = ScrollController();

    clipboardWatcher.addListener(this);
    // start watch
    clipboardWatcher.start();
  }

  @override
  void dispose() {
    super.dispose();
    clipboardWatcher.removeListener(this);

    clipboardWatcher.stop();

    _searchBarController.dispose();
  }

  void _onSearchBarChange() {
    if (_searchBarController.text.isEmpty) {
      setState(() {
        filteredClipboardData = clipboardService.getClipboardData();
      });
    } else {
      setState(() {
        filteredClipboardData = clipboardService
            .getFilteredClipboardData(_searchBarController.text);
      });
    }
  }

  void removeClipboardItem(ExtendedClipboardData data) {
    clipboardService.removeFromClipboardData(data);

    setState(() {});
  }

  void clearClipboardData() {
    clipboardService.clearClipboardData();
    setState(() {});
  }

  Future<void> copyToClipboard(ExtendedClipboardData data) async {
    await clipboardService.copyToClipboard(data);
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
    setState(() {});
  }

  @override
  void onClipboardChanged() async {
    ExtendedClipboardData? newClipboardData =
        await clipboardService.getCurrentClipboardData();

    setState(() {
      clipboardLatestValue = newClipboardData?.clipboardData.text ?? '';
    });

    if (newClipboardData == null) return;

    clipboardService.addToClipboardData(newClipboardData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(121, 48, 48, 48),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (e) {
                  if (e.logicalKey == LogicalKeyboardKey.enter &&
                      _searchBarController.text == '!clear') {
                    clearClipboardData();
                    _searchBarController.clear();
                  }
                },
                child: TextField(
                  controller: _searchBarController,
                  style: TextStyle(color: Colors.grey[300], fontSize: 25),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Padding(
                          padding: const EdgeInsets.only(top: 8.5),
                          child: Icon(CupertinoIcons.search,
                              color: Colors.grey[300])),
                      hintText: 'Search in notes',
                      hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 25,
                          fontWeight: FontWeight.w400)),
                ),
              ))
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: filteredClipboardData.length,
            itemBuilder: (context, index) {
              ExtendedClipboardData data =
                  filteredClipboardData.reversed.toList()[index];
              return Listener(
                child: ClipboardItem(
                  image: data.image,
                  text: data.clipboardData.text!,
                  removeClipboardItem: () {
                    removeClipboardItem(data);
                  },
                  copyToClipboard: () {
                    copyToClipboard(data);
                  },
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
