# Linux Studio

Linux Studio คือแอป Flutter สำหรับใช้งาน Terminal, จัดการไฟล์ และจัดการแพ็กเกจผ่านหน้าจอเดียวกัน โดยออกแบบ backend ให้รองรับ native shell, Container, QEMU และ SSH ได้ในอนาคต

> เวอร์ชันปัจจุบัน: `0.2.0+2`

## ฟีเจอร์ที่ใช้งานได้ในปัจจุบัน

- Terminal บน Windows ผ่าน ConPTY
- Terminal บน Linux และ macOS ผ่าน `/bin/bash`
- File Manager สำหรับเปิดโฟลเดอร์ อ่านไฟล์ สร้างโฟลเดอร์ และนำเข้าไฟล์
- Package Manager ผ่าน Winget บน Windows หรือ APK บนระบบอื่น
- Backend configuration สำหรับ native shell, Container, QEMU, SSH และ local runtime

ฟีเจอร์ iSH บน iOS, proot บน Android, VNC/X11, VM Manager และ Plugin UI ยังอยู่ระหว่างการเชื่อมต่อกับแอปหลัก

## ความต้องการของระบบ

- Flutter SDK ที่รองรับ Dart `>=3.3.0 <4.0.0`
- Git
- Windows: Visual Studio พร้อม workload **Desktop development with C++**
- Linux: toolchain สำหรับ Flutter desktop และ Bash
- macOS: Xcode และ toolchain สำหรับ Flutter
- Winget, Docker/Podman, QEMU หรือ SSH server ติดตั้งแยกตาม backend ที่ต้องการใช้

ตรวจสอบสภาพแวดล้อมด้วย:

```bash
flutter doctor
flutter devices
```

## ติดตั้งโปรเจกต์

แอป Flutter จริงอยู่ในโฟลเดอร์ `generated_app/` ไม่ใช่ repository root

### วิธีมาตรฐาน

```bash
./scripts/bootstrap.sh
flutter pub get
flutter pub get -C generated_app
```

หากใช้งาน Windows และไม่มี Bash ให้ติดตั้ง package จาก PowerShell:

```powershell
cd generated_app
flutter pub get
```

## เปิดโปรแกรม

เข้าไปยังโฟลเดอร์แอปก่อน:

```bash
cd generated_app
```

เปิดบนอุปกรณ์ที่ Flutter เลือกให้อัตโนมัติ:

```bash
flutter run
```

เปิดบน Windows โดยตรง:

```powershell
flutter run -d windows
```

เปิดบนเว็บเพื่อทดลอง UI:

```bash
flutter run -d chrome
```

Web ไม่สามารถเรียก native process ของเครื่องได้ จึงใช้ local fallback จนกว่าจะเชื่อมต่อ remote runtime

## วิธีใช้งานแอป

แถบนำทางด้านล่างมีสามหน้าหลัก

### Terminal

1. เลือก **Terminal**
2. รอข้อความ `Starting shell...`
3. คลิกพื้นที่ Terminal แล้วพิมพ์คำสั่ง
4. ใช้คำสั่งตาม shell ของระบบ เช่น `dir`/PowerShell บน Windows หรือ `ls` บน Linux และ macOS

หากขึ้น `Unable to start the terminal` ให้ตรวจว่า native library หรือ shell ของระบบถูก build และติดตั้งครบ

### File Manager

1. เลือก **File Manager**
2. แอปจะเปิด application documents directory เป็นค่าเริ่มต้น
3. แตะโฟลเดอร์เพื่อเข้าไปด้านใน หรือแตะไฟล์เพื่ออ่านข้อความ
4. ใช้ปุ่มลูกศรขึ้นเพื่อกลับไปโฟลเดอร์แม่
5. ใช้ปุ่มสร้างโฟลเดอร์เพื่อเพิ่มโฟลเดอร์ใหม่
6. ใช้ปุ่มอัปโหลดเพื่อนำไฟล์จากเครื่องเข้ามา
7. ใช้ปุ่ม Refresh เพื่อโหลดรายการใหม่

ไฟล์ binary จะแสดงเฉพาะขนาดไฟล์ ไม่แสดงเนื้อหาเป็นข้อความ

### Package Manager

1. เลือก **Package Manager**
2. บน Windows ให้กรอก Winget package ID เช่น `Git.Git`
3. บนระบบที่ใช้ Alpine ให้กรอกชื่อแพ็กเกจ APK เช่น `curl`
4. เลือก **Search**, **Install** หรือ **Remove**
5. อ่านผลคำสั่งในกล่องด้านล่าง

การติดตั้งหรือลบแพ็กเกจอาจต้องใช้สิทธิ์เพิ่มเติมจากระบบปฏิบัติการ

## Build สำหรับเผยแพร่

Windows:

```powershell
cd generated_app
flutter build windows --release
```

Linux:

```bash
cd generated_app
flutter build linux --release
```

macOS:

```bash
cd generated_app
flutter build macos --release
```

iOS แบบไม่ codesign:

```bash
cd generated_app
flutter build ios --release --no-codesign
```

## เลือก Runtime Backend ในโค้ด

การสร้าง Terminal แบบเดิมจะเลือก native backend ตามระบบอัตโนมัติ:

```dart
final backend = BackendFactory.create();
```

Container:

```dart
final backend = BackendFactory.create(
  BackendConfig.container(image: 'ubuntu:24.04'),
);
```

QEMU:

```dart
final backend = BackendFactory.create(
  BackendConfig.qemu(
    executable: 'qemu-system-x86_64',
    arguments: ['-m', '2048', '-hda', 'linux.img', '-nographic'],
  ),
);
```

SSH:

```dart
final backend = BackendFactory.create(
  BackendConfig.ssh(
    host: 'server.example.com',
    username: 'linuxstudio',
    password: 'password',
  ),
);
```

อย่าเก็บรหัสผ่านจริงไว้ใน source code ควรอ่านจาก secure storage หรือ secret provider

## ตรวจสอบโค้ด

```bash
cd generated_app
flutter analyze --no-pub
```

Windows native backend สามารถ build แยกได้ด้วย:

```powershell
generated_app\native\windows\conpty\build.ps1
```

## โครงสร้างสำคัญ

```text
generated_app/
  lib/core/backend/   Runtime backends และ factory
  lib/core/engine/    Terminal/VT engine
  lib/screens/        หน้าจอหลักของแอป
  native/windows/     ConPTY bridge
native/ish_core/      iSH fork สำหรับการพัฒนา iOS runtime
scripts/              Bootstrap และ generation scripts
project.yaml          รายการ platform และ module
```

## สถานะ Roadmap

- v0.1: Flutter UI, Terminal, File Manager และ Package Manager
- v0.2: Runtime abstraction, native Windows integration และพื้นฐาน remote/container/VM backend
- ขั้นถัดไป: Embedded iSH/proot runtime, VNC/X11 desktop, session profiles, image import/export และ Plugin System

## License

ดูรายละเอียดใน [LICENSE](LICENSE)
