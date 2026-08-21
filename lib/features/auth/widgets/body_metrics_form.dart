import 'package:flutter/material.dart';

import '../../diet/models/diet_enums.dart';
import '../../diet/models/user_profile.dart';

/// The sex/age/height/weight/activity/goal form shared by [RegisterScreen]
/// (step 2) and the Profile screen's "edit body metrics" flow, so there's
/// exactly one copy of this form instead of two drifting in parallel.
///
/// Access the entered values via a [GlobalKey]<[BodyMetricsFormState]> and
/// call [BodyMetricsFormState.validateAndBuild].
class BodyMetricsForm extends StatefulWidget {
  const BodyMetricsForm({super.key, this.initial});

  final UserProfile? initial;

  @override
  State<BodyMetricsForm> createState() => BodyMetricsFormState();
}

class BodyMetricsFormState extends State<BodyMetricsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late BiologicalSex _sex;
  late ActivityLevel _activityLevel;
  late DietGoal _goal;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _ageController = TextEditingController(
      text: initial?.ageYears.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: initial?.heightCm.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: initial?.weightKg.toString() ?? '',
    );
    _sex = initial?.sex ?? BiologicalSex.male;
    _activityLevel = initial?.activityLevel ?? ActivityLevel.moderate;
    _goal = initial?.goal ?? DietGoal.maintain;
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  /// Validates the fields and returns the built profile, or null (and shows
  /// validation errors) if anything is invalid.
  UserProfile? validateAndBuild() {
    if (!_formKey.currentState!.validate()) return null;
    return UserProfile(
      sex: _sex,
      ageYears: int.parse(_ageController.text),
      heightCm: double.parse(_heightController.text),
      weightKg: double.parse(_weightController.text),
      activityLevel: _activityLevel,
      goal: _goal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<BiologicalSex>(
            segments: const [
              ButtonSegment(value: BiologicalSex.male, label: Text('Male')),
              ButtonSegment(value: BiologicalSex.female, label: Text('Female')),
              ButtonSegment(value: BiologicalSex.other, label: Text('Other')),
            ],
            selected: {_sex},
            onSelectionChanged: (s) => setState(() => _sex = s.first),
          ),
          const SizedBox(height: 16),
          _NumberField(
            controller: _ageController,
            label: 'Age (years)',
            min: 1,
            max: 119,
          ),
          const SizedBox(height: 12),
          _NumberField(
            controller: _heightController,
            label: 'Height (cm)',
            min: 1,
            max: 299,
            allowDecimal: true,
          ),
          const SizedBox(height: 12),
          _NumberField(
            controller: _weightController,
            label: 'Weight (kg)',
            min: 1,
            max: 499,
            allowDecimal: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ActivityLevel>(
            initialValue: _activityLevel,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Activity level'),
            items: ActivityLevel.values
                .map(
                  (a) => DropdownMenuItem(
                    value: a,
                    child: Text(
                      a.label,
                      style: textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _activityLevel = v!),
          ),
          const SizedBox(height: 16),
          Text('Goal', style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          SegmentedButton<DietGoal>(
            segments: const [
              ButtonSegment(value: DietGoal.cut, label: Text('Cut')),
              ButtonSegment(value: DietGoal.maintain, label: Text('Maintain')),
              ButtonSegment(value: DietGoal.bulk, label: Text('Bulk')),
            ],
            selected: {_goal},
            onSelectionChanged: (s) => setState(() => _goal = s.first),
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.min,
    required this.max,
    this.allowDecimal = false,
  });

  final TextEditingController controller;
  final String label;
  final num min;
  final num max;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        final n = num.tryParse(value ?? '');
        if (n == null) return 'Enter a number';
        if (n < min || n > max) return 'Must be between $min and $max';
        return null;
      },
    );
  }
}
