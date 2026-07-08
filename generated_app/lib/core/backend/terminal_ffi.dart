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

    final ok =
        TerminalFFI.instance.write(
              _handle!,
              ptr,
              text.length,
            ) !=
            0;

    malloc.free(ptr);

    return ok;
  }

  String read([
    int size = 4096,
  ]) {
    if (!isOpen) {
      return '';
    }

    final buffer =
        malloc<Utf8>(size);

    final length =
        TerminalFFI.instance.read(
      _handle!,
      buffer,
      size,
    );

    if (length <= 0) {
      malloc.free(buffer);
      return '';
    }

    final result =
        buffer.cast<Utf8>().toDartString(
              length: length,
            );

    malloc.free(buffer);

    return result;
  }

  bool resize({
    required int rows,
    required int cols,
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
