import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

double defaultHeight = 46.0;

class WindowsStatusBarWidget extends StatefulWidget {
  final List<Widget>? actions;
  final List<WindowsStatusBarButton>? windowsControlButtons;
  final Color? backgroundColor;
  final Border? border;
  final double? height;
  const WindowsStatusBarWidget({
    super.key,
    this.actions,
    this.backgroundColor,
    this.border,
    this.windowsControlButtons,
    this.height,
  });

  @override
  State<WindowsStatusBarWidget> createState() => _WindowsStatusBarWidgetState();
}

class _WindowsStatusBarWidgetState extends State<WindowsStatusBarWidget>
    with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _checkMaximized();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    setState(() {
      _isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      _isMaximized = false;
    });
  }

  Future<void> _checkMaximized() async {
    final maximized = await windowManager.isMaximized();
    if (mounted) {
      setState(() {
        _isMaximized = maximized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? defaultHeight,
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          border: widget.border ??
              const Border(bottom: BorderSide(width: .2, color: Colors.grey))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              windowManager.startDragging();
            },
            onDoubleTap: () async {
              bool isMaximized = await windowManager.isMaximized();
              if (!isMaximized) {
                windowManager.maximize();
              } else {
                windowManager.unmaximize();
              }
            },
            child: SizedBox(
                height: kToolbarHeight - 1,
                child: Row(
                  children: [
                    if (widget.actions != null) ...widget.actions!,
                    if (widget.actions == null) const Spacer(),
                    if (widget.windowsControlButtons == null) ...[
                      WindowsStatusBarButton(
                        mouseOver:
                            Theme.of(context).colorScheme.surfaceContainer,
                        icon: const Icon(
                          FluentIcons.line_horizontal_1_16_filled,
                          size: 14,
                        ),
                        onTap: () {
                          windowManager.minimize();
                        },
                      ),
                      WindowsStatusBarButton(
                        mouseOver:
                            Theme.of(context).colorScheme.surfaceContainer,
                        icon: Icon(
                          _isMaximized
                              ? FluentIcons.maximize_16_regular
                              : FluentIcons.maximize_16_regular,
                          size: 14,
                        ),
                        onTap: () async {
                          bool isMaximized = await windowManager.isMaximized();
                          if (!isMaximized) {
                            windowManager.maximize();
                          } else {
                            windowManager.unmaximize();
                          }
                        },
                      ),
                      WindowsStatusBarButton(
                        mouseOver: const Color(0xFFD32F2F),
                        icon: const Icon(
                          FluentIcons.dismiss_16_regular,
                          size: 14,
                        ),
                        onTap: () {
                          windowManager.close();
                        },
                      )
                    ],
                    if (widget.windowsControlButtons != null)
                      ...widget.windowsControlButtons!,
                  ],
                )),
          )),
        ],
      ),
    );
  }
}

class WindowsStatusBarButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback onTap;
  final Color iconNormal;
  final Color mouseOver;
  final Color mouseDown;
  final Color iconMouseOver;
  final Color iconMouseDown;
  const WindowsStatusBarButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconNormal = const Color(0x00000000),
    this.mouseOver = const Color(0xFF805306),
    this.mouseDown = const Color(0xFF805306),
    this.iconMouseOver = const Color(0xFF805306),
    this.iconMouseDown = const Color(0xFF805306),
  });

  @override
  State<WindowsStatusBarButton> createState() => _WindowsStatusBarButtonState();
}

class _WindowsStatusBarButtonState extends State<WindowsStatusBarButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            _isHovered = false;
          });
        },
        child: Container(
          width: defaultHeight,
          height: defaultHeight,
          decoration: BoxDecoration(
              color: _isHovered ? widget.mouseOver : Colors.transparent),
          child: widget.icon,
        ),
      ),
    );
  }
}
