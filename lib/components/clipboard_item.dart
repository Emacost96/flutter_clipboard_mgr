import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClipboardItem extends StatelessWidget {
  final String text;

  void Function() removeClipboardItem;
  ClipboardItem(
      {super.key, required this.text, required this.removeClipboardItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              color: Colors.grey[800],
              padding: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                                color: Colors.grey[300], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                removeClipboardItem();
                              },
                              icon: Icon(CupertinoIcons.delete,
                                  color: Colors.grey[300]),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                                onPressed: () {},
                                icon:
                                    Icon(Icons.copy, color: Colors.grey[300])),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
