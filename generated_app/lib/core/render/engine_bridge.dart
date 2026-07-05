class EngineBridge {
  Function()? onUpdate;

  void notify() {
    onUpdate?.call();
  }
}
