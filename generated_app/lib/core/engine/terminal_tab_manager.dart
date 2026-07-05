class TerminalTab {
  final int id;
  final String title;

  TerminalTab(this.id, this.title);
}

class TerminalTabManager {
  final List<TerminalTab> tabs = [];
  int activeIndex = 0;

  void addTab(TerminalTab tab) {
    tabs.add(tab);
    activeIndex = tabs.length - 1;
  }

  void closeTab(int index) {
    if (tabs.isEmpty) return;
    tabs.removeAt(index);
    activeIndex = activeIndex.clamp(0, tabs.length - 1);
  }

  TerminalTab get active => tabs[activeIndex];
}
