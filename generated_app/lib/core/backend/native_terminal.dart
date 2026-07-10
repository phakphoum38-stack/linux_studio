import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'terminal_ffi.dart';

class NativeTerminal {
  NativeTerminal({
    this.rows = 24,
    this.cols = 80,
  });

  final int rows;
  final int cols;

  Pointer<Void>? _handle;

  bool get isOpen =>
      _handle != null &&
      _handle != nullptr;

  bool open() {
    if (isOpen) {
      return true;
    }

    _handle = TerminalFFI.instance.create(
      rows,
      cols,
    );

    return isOpen;
  }

  bool write(
    String text,
  ) {
    if (!isOpen) {
      return false;
    }

    final ptr =
        text.toNativeUtf8();

    try {
      return TerminalFFI.instance.write(
            _handle!,
            ptr,
            utf8.encode(text).length,
          ) !=
          0;
    } finally {
      malloc.free(ptr);
    }
  }

  String read([
    int bufferSize = 8192,
  ]) {
    if (!isOpen) {
      return '';
    }

    final buffer =
        calloc<Uint8>(
      bufferSize,
    );

    try {
      final length =
          TerminalFFI.instance.read(
        _handle!,
        buffer,
        bufferSize,
      );

      if (length <= 0) {
        return '';
      }

      return utf8.decode(
        buffer.asTypedList(
          length,
        ),
      );
    } finally {
      calloc.free(buffer);
    }
  }

  bool resize({
    required int cols,
    required int rows,
  }) {
    if (!isOpen) {
      return false;
    }

    return TerminalFFI.instance.resize(
          _handle!,
          rows,
          cols,
        ) !=
        0;
  }

  void close() {
    if (!isOpen) {
      return;
    }

    TerminalFFI.instance.close(
      _handle!,
    );

    _handle = nullptr;
  }
}
