import 'package:flutter/material.dart';

import '../constants/font_constants.dart';

class DropDown extends StatelessWidget {

  final List<DropdownMenuItem<String>> items;
  final Function(String?)? onChanged;
  final String hintText;
  final String? initialValue;

  const DropDown({
    super.key, required this.items, this.onChanged, required this.hintText, this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            // value: LocationType.kVirtual,
            // isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            items: items,
            onChanged: onChanged,
            style: kFourteenMediumTextStyle.copyWith(color: Colors.white),
            icon: const SizedBox(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset('assets/images/drop-down.png'),
        ),
      ],
    );
  }
}