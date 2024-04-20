import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clipboard_mgr/services/clipboard_service.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:super_clipboard/super_clipboard.dart';

class ClipboardItem extends StatefulWidget {
  const ClipboardItem(
      {super.key,
      required this.text,
      required this.removeClipboardItem,
      required this.copyToClipboard,
      this.image,
      this.uri});

  final void Function() copyToClipboard;
  final void Function() removeClipboardItem;
  final String text;
  final Uint8List? image;
  final NamedUri? uri;

  @override
  State<ClipboardItem> createState() => _ClipboardItemState();
}

class _ClipboardItemState extends State<ClipboardItem> {
  ClipboardService clipboardService = ClipboardService();

  bool _isExpanded = false;
  bool _isExpandable = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovering = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHovering = false;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    color: _isHovering ? Colors.grey[900] : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[900]!),
                    )),
                padding: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _isHovering ? 1.0 : 0.0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  hoverColor:
                                      _isExpandable ? null : Colors.transparent,
                                  icon: _isExpanded
                                      ? const Icon(Icons.expand_less)
                                      : const Icon(Icons.expand_more),
                                  color: _isExpandable
                                      ? Colors.grey[600]
                                      : Colors.transparent,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.image != null &&
                                    widget.image!.isNotEmpty)
                                  Image.memory(
                                    widget.image!,
                                    width: 100,
                                  )
                                else if (widget.uri != null)
                                  clipboardService.getLinkPreviewGenerator(
                                      widget.uri!.uri.toString())
                                else
                                  AnimatedCrossFade(
                                    firstChild: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final TextPainter textPainter =
                                            TextPainter(
                                          text: TextSpan(
                                              text: widget.text,
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                          maxLines: 3,
                                          textDirection: TextDirection.ltr,
                                        )..layout(
                                                maxWidth: constraints.maxWidth);

                                        if (textPainter.didExceedMaxLines) {
                                          _isExpandable = true;
                                        } else {
                                          _isExpandable = false;
                                        }

                                        return Text(
                                          maxLines: _isExpanded ? 10 : 3,
                                          widget.text,
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12),
                                          overflow: TextOverflow.fade,
                                        );
                                      },
                                    ),
                                    secondChild: Text(
                                      widget.text,
                                      style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 12),
                                    ),
                                    crossFadeState: _isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 300),
                                  )
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      widget.removeClipboardItem();
                                    },
                                    icon: Icon(CupertinoIcons.delete,
                                        color: Colors.grey[300]),
                                  ),
                                  const SizedBox(width: 20),
                                  IconButton(
                                      onPressed: () {
                                        widget.copyToClipboard();
                                      },
                                      icon: Icon(Icons.copy,
                                          color: Colors.grey[300])),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _isHovering ? 1.0 : 0.0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              hoverColor:
                                  _isExpandable ? null : Colors.transparent,
                              icon: _isExpanded
                                  ? const Icon(Icons.expand_less)
                                  : const Icon(Icons.expand_more),
                              color: _isExpandable
                                  ? Colors.grey[600]
                                  : Colors.transparent,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
