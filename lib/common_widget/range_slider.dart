import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
  final String title;
  final double min;
  final double max;
  final double initialValue;
  final List<String> labels;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const CustomRangeSlider({
    super.key,
    required this.title,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.labels,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title aligned with slider
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.activeColor,
            inactiveTrackColor: widget.activeColor.withOpacity(0.2),
            thumbColor: widget.activeColor,
            overlayColor: widget.activeColor.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            trackHeight: 4,
          ),
          child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.labels
              .map(
                (label) => Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
