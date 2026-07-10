import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef TerminalCreateNative = Pointer<Void> Function(
  Int32 rows,
  Int32 cols,
);

typedef TerminalCreate = Pointer<Void> Function(
  int rows,
  int cols,
);

typedef TerminalWriteNative = Uint8 Function(
  Pointer<Void>,
  Pointer<Utf8>,
  Int32,
);

typedef TerminalWrite = int Function(
  Pointer<Void>,
  Pointer<Utf8>,
  int,
);

typedef TerminalReadNative = Int32 Function(
  Pointer<Void>,
  Pointer<Uint8>,
  Int32,
);

typedef TerminalRead = int Function(
  Pointer<Void>,
  Pointer<Uint8>,
  int,
);

typedef TerminalResizeNative = Uint8 Function(
  Pointer<Void>,
  Int32,
  Int32,
);

typedef TerminalResize = int Function(
  Pointer<Void>,
  int,
  int,
);

typedef TerminalCloseNative = Void Function(
  Pointer<Void>,
);

typedef TerminalClose = void Function(
  Pointer<Void>,
);

class TerminalFFI {
  TerminalFFI._() {
    _load();
  }

  static final TerminalFFI instance =
      TerminalFFI._();

  late final DynamicLibrary _dll;

  late final TerminalCreate create;

  late final TerminalWrite write;

  late final TerminalRead read;

  late final TerminalResize resize;

  late final TerminalClose close;

  void _load() {
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'Windows only',
      );
    }

    _dll = DynamicLibrary.open(
      'terminal_api.dll',
    );

    create = _dll.lookupFunction<
        TerminalCreateNative,
        TerminalCreate>(
      'terminal_create',
    );

    write = _dll.lookupFunction<
        TerminalWriteNative,
        TerminalWrite>(
      'terminal_write',
    );

    read = _dll.lookupFunction<
        TerminalReadNative,
        TerminalRead>(
      'terminal_read',
    );

    resize = _dll.lookupFunction<
        TerminalResizeNative,
        TerminalResize>(
      'terminal_resize',
    );

    close = _dll.lookupFunction<
        TerminalCloseNative,
        TerminalClose>(
      'terminal_close',
    );
  }
}
