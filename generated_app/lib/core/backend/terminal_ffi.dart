import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef _TerminalCreateNative = Pointer<Void> Function(
  Int32 rows,
  Int32 cols,
);

typedef _TerminalCreate = Pointer<Void> Function(
  int rows,
  int cols,
);

typedef _TerminalWriteNative = Uint8 Function(
  Pointer<Void> handle,
  Pointer<Utf8> data,
  Int32 length,
);

typedef _TerminalWrite = int Function(
  Pointer<Void> handle,
  Pointer<Utf8> data,
  int length,
);

typedef _TerminalReadNative = Int32 Function(
  Pointer<Void> handle,
  Pointer<Uint8> buffer,
  Int32 size,
);

typedef _TerminalRead = int Function(
  Pointer<Void> handle,
  Pointer<Uint8> buffer,
  int size,
);

typedef _TerminalResizeNative = Uint8 Function(
  Pointer<Void> handle,
  Int32 rows,
  Int32 cols,
);

typedef _TerminalResize = int Function(
  Pointer<Void> handle,
  int rows,
  int cols,
);

typedef _TerminalCloseNative = Void Function(
  Pointer<Void> handle,
);

typedef _TerminalClose = void Function(
  Pointer<Void> handle,
);

class TerminalFFI {
  TerminalFFI._() {
    _load();
  }

  static final TerminalFFI instance = TerminalFFI._();

  late final DynamicLibrary _library;

  late final _TerminalCreate create;
  late final _TerminalWrite write;
  late final _TerminalRead read;
  late final _TerminalResize resize;
  late final _TerminalClose close;

  void _load() {
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'ConPTY backend is only available on Windows.',
      );
    }

    _library = DynamicLibrary.open(
      'terminal_api.dll',
    );

    create = _library.lookupFunction<
        _TerminalCreateNative,
        _TerminalCreate>(
      'terminal_create',
    );

    write = _library.lookupFunction<
        _TerminalWriteNative,
        _TerminalWrite>(
      'terminal_write',
    );

    read = _library.lookupFunction<
        _TerminalReadNative,
        _TerminalRead>(
      'terminal_read',
    );

    resize = _library.lookupFunction<
        _TerminalResizeNative,
        _TerminalResize>(
      'terminal_resize',
    );

    close = _library.lookupFunction<
        _TerminalCloseNative,
        _TerminalClose>(
      'terminal_close',
    );
  }
}
