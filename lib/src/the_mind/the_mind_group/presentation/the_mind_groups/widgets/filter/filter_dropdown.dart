import 'package:flutter/material.dart';

const _orange = Color(0xFFED6A2E);

class FilterDropdown extends StatefulWidget {
  final String hint;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  const FilterDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  bool get _isSelected =>
      widget.value != null && widget.items.containsKey(widget.value);

  void _openDropdown() {
    if (_isOpen) {
      _closeDropdown();
      return;
    }
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

OverlayEntry _buildOverlay() {
  // Получаем позицию кнопки чтобы знать ширину
  final renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;

  return OverlayEntry(
    builder: (_) => Stack(
      children: [
        // ── Фон для закрытия ──
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeDropdown,
            child: const SizedBox.expand(),
          ),
        ),

        // ── Список ──
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 6),
          child: Material(
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              // ✅ ФИКС: минимальная ширина = ширина кнопки, максимум 260
              constraints: BoxConstraints(
                minWidth: size.width,
                maxWidth: 260,
                maxHeight: 260,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    children: [
                      _DropdownItem(
                        label: 'Все',
                        isSelected: !_isSelected,
                        onTap: () {
                          widget.onChanged(null);
                          _closeDropdown();
                        },
                      ),
                      Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                      ...widget.items.entries.map(
                        (e) => _DropdownItem(
                          label: e.value,
                          isSelected: e.key == widget.value,
                          onTap: () {
                            widget.onChanged(e.key);
                            _closeDropdown();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label =
        _isSelected ? widget.items[widget.value]! : widget.hint;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _openDropdown,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color:
                _isSelected ? _orange.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isSelected
                  ? _orange
                  : _isOpen
                      ? Colors.grey.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: _isSelected ? _orange : Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              if (_isSelected)
                GestureDetector(
                  onTap: () {
                    widget.onChanged(null);
                    _closeDropdown();
                  },
                  child:
                      const Icon(Icons.close, size: 14, color: _orange),
                )
              else
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DropdownItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isSelected
        ? _orange.withOpacity(0.08)
        : _hovered
            ? _orange.withOpacity(0.06)
            : Colors.transparent;

    final textColor = widget.isSelected
        ? _orange
        : _hovered
            ? _orange
            : Colors.black87;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        if (!_hovered) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          color: bg,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: textColor,
                  ),
                ),
              ),
              if (widget.isSelected)
                const Icon(Icons.check, size: 14, color: _orange),
            ],
          ),
        ),
      ),
    );
  }
}