import 'package:flutter/material.dart';
import 'package:propmeet/model/user_model/property_detail_model.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class PropertyDetailsSection extends StatefulWidget {
  final PropertyDetails details;
  final Function(String field, String value) onUpdate; // callback to update Firestore/UI

  const PropertyDetailsSection({
    super.key,
    required this.details,
    required this.onUpdate,
  });

  @override
  State<PropertyDetailsSection> createState() => _PropertyDetailsSectionState();
}

class _PropertyDetailsSectionState extends State<PropertyDetailsSection> {

  final Map<String, List<String>> fieldOptions = {
    "Value": ["<\$500K", "\$500K - \$1M", "\$1M - \$2M", "\$2M+"],
    "Bedrooms": ["1-2", "3-4", "5-6", "6+"],
    "Bathrooms": ["1-2", "3-4", "4+"],
    "Car Spaces": ["0", "1-2", "3-4", "4+"],
    "Land Size": ["<300 sqm", "300 - 600 sqm", "600 - 900 sqm", "900+ sqm"],
  };

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: RoundedRectangleBorder(),
      title: const Text(
        "More Information",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            spacing: 3,
            runSpacing: 2,
            children: [
              _buildChip("Value", widget.details.value),
              _buildChip("Bedrooms", widget.details.bedrooms),
              _buildChip("Bathrooms", widget.details.bathrooms),
              _buildChip("Car Spaces", widget.details.carSpaces),
              _buildChip("Land Size", widget.details.landSize),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, String value) {
    return InputChip(
      label: Text(
        "$label: ${value.isEmpty ? "Not set" : value}",
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      //backgroundColor: Colors.blue.shade50,
      onPressed: () => _showOptionsDialog(label, value),
    );
  }

  void _showOptionsDialog(String field, String currentValue) {
    final options = fieldOptions[field] ?? [];
    String? selected = currentValue.isNotEmpty ? currentValue : null;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("$field", style: TextStyle(fontSize: Responsive.fontSize(4)),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((opt) {
              return RadioListTile<String>(
                activeColor: AppColors.goldenBackgroundColor,
                title: Text(opt, style:  TextStyle(fontSize: Responsive.fontSize(3.5)),),
                value: opt,
                groupValue: selected,
                onChanged: (val) {
                  setState(() {
                    selected = val;
                  });
                  widget.onUpdate(field, val!); // notify parent to update Firestore
                  Navigator.pop(ctx); // close dialog
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
