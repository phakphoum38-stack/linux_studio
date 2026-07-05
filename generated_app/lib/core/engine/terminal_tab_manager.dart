import 'terminal_core.dart';

class TerminalTab {
  final String id;
  final TerminalCore core;

  TerminalTab(this.id, this.core);
}

class TerminalTabManager {
  final List<TerminalTab> tabs = [];

  int activeIndex = 0;

  void addTab(TerminalTab tab) {
    tabs.add(tab);
  }

  void closeTab(int index) {
    tabs.removeAt(index);

    if (activeIndex >= tabs.length) {
      activeIndex = tabs.length - 1;
    }
  }

  TerminalTab get active => tabs[activeIndex];

  void switchTo(int index) {
    if (index < 0 || index >= tabs.length) return;
    activeIndex = index;
  }
}
