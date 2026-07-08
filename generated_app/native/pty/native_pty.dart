import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final DynamicLibrary _lib =
    Platform.isWindows
        ? DynamicLibrary.open("pty.dll")
        : DynamicLibrary.process();

class NativePty {
  late final int Function(Pointer<Utf8>)
      spawn;

  late final int Function(
    Pointer<Utf8>,
    int,
  ) writeData;

  late final int Function(
    Pointer<Uint8>,
    int,
  ) read;

  late final void Function(
    int,
    int,
  ) resize;

  late final void Function()
      close;

  NativePty() {
    spawn = _lib.lookupFunction<
        Int32 Function(Pointer<Utf8>),
        int Function(Pointer<Utf8>)>("pty_spawn");

    writeData = _lib.lookupFunction<
        Int32 Function(
            Pointer<Utf8>,
            Int32),
        int Function(
            Pointer<Utf8>,
            int)>("pty_write");

    read = _lib.lookupFunction<
        Int32 Function(
            Pointer<Uint8>,
            Int32),
        int Function(
            Pointer<Uint8>,
            int)>("pty_read");

    resize = _lib.lookupFunction<
        Void Function(
            Int32,
            Int32),
        void Function(
            int,
            int)>("pty_resize");

    close = _lib.lookupFunction<
        Void Function(),
        void Function()>("pty_close");
  }
}
