import 'package:flutter/material.dart';

class CustomDropdownAttached extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const CustomDropdownAttached({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CustomDropdownAttached> createState() => _CustomDropdownAttachedState();
}

class _CustomDropdownAttachedState extends State<CustomDropdownAttached> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  final GlobalKey _fieldKey = GlobalKey();
  Size _fieldSize = Size.zero;

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (!mounted) return;

    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    _fieldSize = box.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeOverlay,
            ),
          ),
          Positioned(
            width: _fieldSize.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, _fieldSize.height + 4),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  // Assuming each ListTile is about 56 pixels high (default)
                  height:
                      (widget.items.length > 4 ? 4 : widget.items.length) *
                      56.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.items
                        .map(
                          (item) => ListTile(
                            title: Text(item),
                            onTap: () {
                              widget.onChanged(item);
                              _removeOverlay();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final overlay = Overlay.of(
      context,
      rootOverlay: true,
    ); // always get rootOverlay
    // ignore: unnecessary_null_comparison
    if (overlay != null && mounted && _overlayEntry != null) {
      try {
        overlay.insert(_overlayEntry!);
        setState(() => _isDropdownOpen = true);
      } catch (e) {
        // overlay might already be disposed
        _overlayEntry = null;
      }
    }
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry?.remove();
      } catch (_) {}
      _overlayEntry = null;
    }
    if (mounted) {
      setState(() => _isDropdownOpen = false);
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          key: _fieldKey,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFF5F5F5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.selectedValue ?? 'Select',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
