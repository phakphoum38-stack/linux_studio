import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef _CreateNative = Pointer<Void> Function(
  Int32 rows,
  Int32 cols,
);

typedef _Create = Pointer<Void> Function(
  int rows,
  int cols,
);

typedef _WriteNative = Uint8 Function(
  Pointer<Void>,
  Pointer<Utf8>,
  Int32,
);

typedef _Write = int Function(
  Pointer<Void>,
  Pointer<Utf8>,
  int,
);

typedef _ReadNative = Int32 Function(
  Pointer<Void>,
  Pointer<Utf8>,
  Int32,
);

typedef _Read = int Function(
  Pointer<Void>,
  Pointer<Utf8>,
  int,
);

typedef _ResizeNative = Uint8 Function(
  Pointer<Void>,
  Int32,
  Int32,
);

typedef _Resize = int Function(
  Pointer<Void>,
  int,
  int,
);

typedef _CloseNative = Void Function(
  Pointer<Void>,
);

typedef _Close = void Function(
  Pointer<Void>,
);

class TerminalFFI {
  TerminalFFI._() {
    _load();
  }

  static final TerminalFFI instance = TerminalFFI._();

  late final DynamicLibrary library;

  late final _Create create;

  late final _Write write;

  late final _Read read;

  late final _Resize resize;

  late final _Close close;

  void _load() {
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'ConPTY backend is only supported on Windows.',
      );
    }

    library = DynamicLibrary.open(
      'terminal_api.dll',
    );

    create = library.lookupFunction<
        _CreateNative,
        _Create>(
      'terminal_create',
    );

    write = library.lookupFunction<
        _WriteNative,
        _Write>(
      'terminal_write',
    );

    read = library.lookupFunction<
        _ReadNative,
        _Read>(
      'terminal_read',
    );

    resize = library.lookupFunction<
        _ResizeNative,
        _Resize>(
      'terminal_resize',
    );

    close = library.lookupFunction<
        _CloseNative,
        _Close>(
      'terminal_close',
    );
  }
}
