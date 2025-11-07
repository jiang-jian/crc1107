import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme/app_theme.dart';

class MenuItem {
  final String key;
  final String label;
  final IconData icon;
  final List<MenuItem>? children;

  const MenuItem({
    required this.key,
    required this.label,
    required this.icon,
    this.children,
  });

  bool get hasChildren => children != null && children!.isNotEmpty;
}

class CommonMenu extends StatefulWidget {
  final List<MenuItem> menuItems;
  final String selectedKey;
  final Function(String) onItemSelected;
  final Color? backgroundColor;
  final double? width;
  final EdgeInsets? padding;

  const CommonMenu({
    super.key,
    required this.menuItems,
    required this.selectedKey,
    required this.onItemSelected,
    this.backgroundColor,
    this.width,
    this.padding,
  });

  @override
  State<CommonMenu> createState() => _CommonMenuState();
}

class _CommonMenuState extends State<CommonMenu> {
  final Set<String> _expandedKeys = {};

  @override
  void initState() {
    super.initState();
    _initExpandedState();
  }

  void _initExpandedState() {
    for (var item in widget.menuItems) {
      if (item.hasChildren) {
        for (var child in item.children!) {
          if (child.key == widget.selectedKey) {
            _expandedKeys.add(item.key);
            break;
          }
        }
      }
    }
  }

  void _toggleExpanded(String key) {
    setState(() {
      if (_expandedKeys.contains(key)) {
        _expandedKeys.remove(key);
      } else {
        _expandedKeys.add(key);
      }
    });
  }

  bool _isChildSelected(MenuItem item) {
    if (!item.hasChildren) return false;
    return item.children!.any((child) => child.key == widget.selectedKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 160.w,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? const Color(0xFF2B2E3A),
      ),
      child: ListView(
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: 16.h),
        children: widget.menuItems.map((item) {
          return _buildMenuItem(item);
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final isExpanded = _expandedKeys.contains(item.key);
    final isSelected = widget.selectedKey == item.key;
    final hasSelectedChild = _isChildSelected(item);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (item.hasChildren) {
                _toggleExpanded(item.key);
              } else {
                widget.onItemSelected(item.key);
              }
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              decoration: isSelected && !item.hasChildren
                  ? BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    )
                  : null,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20.w,
                    color: isSelected || hasSelectedChild
                        ? Colors.white
                        : Colors.white70,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected || hasSelectedChild
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected || hasSelectedChild
                            ? Colors.white
                            : Colors.white70,
                      ),
                    ),
                  ),
                  if (item.hasChildren)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 18.w,
                      color: Colors.white70,
                    ),
                ],
              ),
            ),
          ),
          if (item.hasChildren)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      children: item.children!.map((child) {
                        final isChildSelected = widget.selectedKey == child.key;
                        return InkWell(
                          onTap: () => widget.onItemSelected(child.key),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            margin: EdgeInsets.only(
                              left: 12.w,
                              right: 12.w,
                              bottom: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isChildSelected
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              child.label,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isChildSelected
                                    ? Colors.white
                                    : Colors.white60,
                                fontWeight: isChildSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
