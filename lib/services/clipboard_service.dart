import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:super_clipboard/super_clipboard.dart';

/// A service for managing clipboard data.
class ClipboardService {
  // Clipboard data
  List<ExtendedClipboardData> _clipboardData = [];

  final Map<String, LinkPreviewGenerator> _linkPreviewCache = {};

  /// Get the current clipboard data.
  List<ExtendedClipboardData> get clipboardData => _clipboardData;

  /// Get the current clipboard data asynchronously.
  ///
  /// Returns the current clipboard data as an [ExtendedClipboardData] object.
  /// If the clipboard API is not supported on this platform, returns `null`.
  Future<ExtendedClipboardData?> getCurrentClipboardData() async {
    // Get current clipboard data
    final clipboard = SystemClipboard.instance;
    ExtendedClipboardData? data = ExtendedClipboardData(
      clipboardData: const ClipboardData(text: ''),
      date: DateTime.now(),
      image: Uint8List(0),
      format: '',
      uri: NamedUri(Uri()),
    );

    if (clipboard == null) {
      return null; // Clipboard API is not supported on this platform.
    }
    final reader = await clipboard.read();

    if (reader.canProvide(Formats.png)) {
      data.format = 'png';
      reader.getFile(Formats.png, (file) {
        final stream = file.readAll();
        stream.then((value) {
          data.image = value;
        });
      });
    }

    if (reader.canProvide(Formats.jpeg)) {
      data.format = 'jpeg';
      reader.getFile(Formats.jpeg, (file) {
        final stream = file.readAll();
        stream.then((value) {
          data.image = value;
        });
      });
    }

    if (reader.canProvide(Formats.webp)) {
      data.format = 'webp';
      reader.getFile(Formats.webp, (file) {
        final stream = file.readAll();
        stream.then((value) {
          data.image = value;
        });
      });
    }

    if (reader.canProvide(Formats.plainText)) {
      final text = await reader.readValue(Formats.plainText);
      data.clipboardData = ClipboardData(text: text ?? '');
    }

    if (reader.canProvide(Formats.uri)) {
      final uri = await reader.readValue(Formats.uri);
      data.uri = uri;
    }
    return data;
  }

  /// Get the clipboard data.
  ///
  /// Returns a list of [ExtendedClipboardData] objects representing the clipboard data.
  List<ExtendedClipboardData> getClipboardData() {
    // Get clipboard data
    return _clipboardData;
  }

  /// Add a [ExtendedClipboardData] object to the clipboard data.
  void addToClipboardData(ExtendedClipboardData data) {
    // Add to clipboard data
    _clipboardData.add(data);
  }

  /// Remove a [ExtendedClipboardData] object from the clipboard data.
  void removeFromClipboardData(ExtendedClipboardData data) {
    // Remove from clipboard data
    _clipboardData.remove(data);
  }

  /// Clear the clipboard data.
  void clearClipboardData() {
    // Clear clipboard data
    _clipboardData.clear();
  }

  /// Copy text to clipboard.
  ///
  /// Removes the specified [ExtendedClipboardData] object from the clipboard data.
  Future<void> copyToClipboard(ExtendedClipboardData data) async {
    final clipboard = SystemClipboard.instance;

    if (clipboard == null) {
      return; // Clipboard API is not supported on this platform.
    }

    final item = DataWriterItem();
    item.add(Formats.plainText(data.clipboardData.text!));
    if (data.format == 'png') {
      item.add(Formats.png(data.image!));
    } else if (data.format == 'jpeg') {
      item.add(Formats.jpeg(data.image!));
    } else if (data.format == 'webp') {
      item.add(Formats.webp(data.image!));
    }
    await clipboard.write([item]);
    removeFromClipboardData(data);
  }

  /// Get filtered clipboard data based on a query.
  ///
  /// Returns a list of [ExtendedClipboardData] objects that match the given query.
  List<ExtendedClipboardData> getFilteredClipboardData(String query) {
    return _clipboardData
        .where((item) => item.clipboardData.text!
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  LinkPreviewGenerator getLinkPreviewGenerator(String url) {
    if (_linkPreviewCache.containsKey(url)) {
      return _linkPreviewCache[url]!;
    } else {
      final generator = LinkPreviewGenerator(
        key: Key(url),
        link: url,
        backgroundColor: Colors.black,
        removeElevation: true,
        errorBody: 'Click to open link',
        linkPreviewStyle: LinkPreviewStyle.small,
        placeholderWidget: Text(
          'Loading...',
          style: TextStyle(color: Colors.grey[300]),
        ),
        borderRadius: 6,
      );
      _linkPreviewCache[url] = generator;
      return generator;
    }
  }
}

/// Represents extended clipboard data.
class ExtendedClipboardData {
  ExtendedClipboardData({
    required this.clipboardData,
    this.date,
    this.image,
    this.uri,
    required this.format,
  });

  /// The clipboard data.
  ClipboardData clipboardData;

  /// The date and time when the clipboard data was captured.
  DateTime? date;

  String format;

  /// The image data, if available.
  Uint8List? image;

  NamedUri? uri;
}
