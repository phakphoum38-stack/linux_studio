import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef _CreateNative = Pointer<Void> Function(Int32 rows, Int32 cols);
typedef _CreateDart = Pointer<Void> Function(int rows, int cols);

typedef _WriteNative = Int32 Function(
  Pointer<Void> handle,
  Pointer<Utf8> data,
  Int32 length,
);
typedef _WriteDart = int Function(
  Pointer<Void> handle,
  Pointer<Utf8> data,
  int length,
);

typedef _ReadNative = Int32 Function(
  Pointer<Void> handle,
  Pointer<Uint8> buffer,
  Int32 size,
);
typedef _ReadDart = int Function(
  Pointer<Void> handle,
  Pointer<Uint8> buffer,
  int size,
);

typedef _ResizeNative = Int32 Function(
  Pointer<Void> handle,
  Int32 rows,
  Int32 cols,
);
typedef _ResizeDart = int Function(
  Pointer<Void> handle,
  int rows,
  int cols,
);

typedef _CloseNative = Void Function(Pointer<Void> handle);
typedef _CloseDart = void Function(Pointer<Void> handle);

class TerminalFFI {
  TerminalFFI._();

  static final TerminalFFI instance = TerminalFFI._();

  bool _loaded = false;

  late final _CreateDart _create;
  late final _WriteDart _write;
  late final _ReadDart _read;
  late final _ResizeDart _resize;
  late final _CloseDart _close;

  void load() {
    if (_loaded) return;
    if (!Platform.isWindows) {
      throw UnsupportedError('ConPTY is only available on Windows.');
    }

    final library = DynamicLibrary.open('terminal_api.dll');
    _create = library.lookupFunction<_CreateNative, _CreateDart>('terminal_create');
    _write = library.lookupFunction<_WriteNative, _WriteDart>('terminal_write');
    _read = library.lookupFunction<_ReadNative, _ReadDart>('terminal_read');
    _resize = library.lookupFunction<_ResizeNative, _ResizeDart>('terminal_resize');
    _close = library.lookupFunction<_CloseNative, _CloseDart>('terminal_close');
    _loaded = true;
  }

  Pointer<Void> create(int rows, int cols) {
    load();
    return _create(rows, cols);
  }

  bool write(Pointer<Void> handle, String text) {
    load();
    final bytes = utf8.encode(text);
    final pointer = calloc<Uint8>(bytes.length + 1);
    try {
      pointer.asTypedList(bytes.length).setAll(0, bytes);
      return _write(handle, pointer.cast<Utf8>(), bytes.length) != 0;
    } finally {
      calloc.free(pointer);
    }
  }

  String read(Pointer<Void> handle, [int size = 8192]) {
    load();
    final buffer = calloc<Uint8>(size);
    try {
      final length = _read(handle, buffer, size);
      if (length <= 0) return '';
      return utf8.decode(buffer.asTypedList(length), allowMalformed: true);
    } finally {
      calloc.free(buffer);
    }
  }

  bool resize(Pointer<Void> handle, int rows, int cols) {
    load();
    return _resize(handle, rows, cols) != 0;
  }

  void close(Pointer<Void> handle) {
    load();
    _close(handle);
  }
}
