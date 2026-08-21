import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/glass_card.dart';
import 'bmr_calculator.dart';
import 'models/diet_enums.dart';
import 'models/macro_targets.dart';
import 'models/user_profile.dart';

class DietCalculatorScreen extends StatefulWidget {
  const DietCalculatorScreen({super.key});

  @override
  State<DietCalculatorScreen> createState() => _DietCalculatorScreenState();
}

class _DietCalculatorScreenState extends State<DietCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  BiologicalSex _sex = BiologicalSex.male;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  DietGoal _goal = DietGoal.maintain;
  MacroTargets? _result;

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final profile = UserProfile(
      sex: _sex,
      ageYears: int.parse(_ageController.text),
      heightCm: double.parse(_heightController.text),
      weightKg: double.parse(_weightController.text),
      activityLevel: _activityLevel,
      goal: _goal,
    );

    setState(() {
      _result = BmrCalculator.calculateMacroTargets(profile);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Diet calculator')),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily targets', style: textTheme.displayLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Based on your body and activity, not a generic plan.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About you', style: textTheme.titleLarge),
                        const SizedBox(height: 16),
                        _SexSelector(
                          value: _sex,
                          onChanged: (v) => setState(() => _sex = v),
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
                          decoration: const InputDecoration(
                            labelText: 'Activity level',
                          ),
                          dropdownColor: AppColors.backgroundAlt,
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
                          onChanged: (v) =>
                              setState(() => _activityLevel = v!),
                        ),
                        const SizedBox(height: 16),
                        Text('Goal', style: textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        _GoalSelector(
                          value: _goal,
                          onChanged: (v) => setState(() => _goal = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _calculate,
                    child: const Text('Calculate'),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    _ResultsCard(result: _result!),
                  ],
                ],
              ),
            ),
          ),
        ),
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

class _SexSelector extends StatelessWidget {
  const _SexSelector({required this.value, required this.onChanged});

  final BiologicalSex value;
  final ValueChanged<BiologicalSex> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<BiologicalSex>(
      segments: const [
        ButtonSegment(value: BiologicalSex.male, label: Text('Male')),
        ButtonSegment(value: BiologicalSex.female, label: Text('Female')),
        ButtonSegment(value: BiologicalSex.other, label: Text('Other')),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _GoalSelector extends StatelessWidget {
  const _GoalSelector({required this.value, required this.onChanged});

  final DietGoal value;
  final ValueChanged<DietGoal> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DietGoal>(
      segments: const [
        ButtonSegment(value: DietGoal.cut, label: Text('Cut')),
        ButtonSegment(value: DietGoal.maintain, label: Text('Maintain')),
        ButtonSegment(value: DietGoal.bulk, label: Text('Bulk')),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _ResultsCard extends StatelessWidget {
  const _ResultsCard({required this.result});

  final MacroTargets result;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your targets', style: textTheme.titleLarge),
          const SizedBox(height: 16),
          _StatRow(label: 'BMR', value: '${result.bmr.round()} kcal'),
          _StatRow(label: 'TDEE', value: '${result.tdee.round()} kcal'),
          _StatRow(
            label: 'Daily calorie target',
            value: '${result.calorieTarget.round()} kcal',
            emphasize: true,
          ),
          const SizedBox(height: 20),
          _MacroBar(result: result),
          const SizedBox(height: 16),
          _MacroLegendRow(
            color: AppColors.orange,
            label: 'Protein',
            grams: result.proteinG,
          ),
          const SizedBox(height: 8),
          _MacroLegendRow(
            color: AppColors.orangeSoft,
            label: 'Carbs',
            grams: result.carbsG,
          ),
          const SizedBox(height: 8),
          _MacroLegendRow(
            color: AppColors.textSecondary,
            label: 'Fat',
            grams: result.fatG,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyMedium),
          Text(
            value,
            style: emphasize
                ? textTheme.titleLarge?.copyWith(color: AppColors.orange)
                : textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({required this.result});

  final MacroTargets result;

  @override
  Widget build(BuildContext context) {
    final total = result.proteinKcal + result.carbsKcal + result.fatKcal;
    final proteinFlex = (result.proteinKcal / total * 1000).round();
    final carbsFlex = (result.carbsKcal / total * 1000).round();
    final fatFlex = (1000 - proteinFlex - carbsFlex).clamp(0, 1000);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 14,
        child: Row(
          children: [
            Expanded(
              flex: proteinFlex,
              child: Container(color: AppColors.orange),
            ),
            Expanded(
              flex: carbsFlex,
              child: Container(color: AppColors.orangeSoft),
            ),
            Expanded(
              flex: fatFlex,
              child: Container(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroLegendRow extends StatelessWidget {
  const _MacroLegendRow({
    required this.color,
    required this.label,
    required this.grams,
  });

  final Color color;
  final String label;
  final double grams;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: textTheme.bodyMedium)),
        Text('${grams.round()} g', style: textTheme.bodyLarge),
      ],
    );
  }
}
