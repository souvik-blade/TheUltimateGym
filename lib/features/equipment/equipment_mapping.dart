/// One entry per rendered 3D equipment image in
/// assets/images/3d/gym-equipment/renders/. `equipmentTags` maps each
/// render to the `equipment` string value(s) used by exercises.json, so we
/// can list "exercises that use this" without inventing new content — see
/// REQUIREMENTS.md / ASSET_ATTRIBUTION.md for why this mapping isn't 1:1
/// (many renders share one equipment tag, and cardio machines don't map
/// cleanly onto exercises.json's mostly-strength vocabulary).
///
/// The distinct `equipment` values actually present in exercises.json
/// (verified by scanning the dataset, not guessed) are: bands, barbell,
/// body only, cable, dumbbell, e-z curl bar, exercise ball, foam roll,
/// kettlebells, machine, medicine ball, other, and null (no equipment).
class EquipmentItem {
  const EquipmentItem({
    required this.id,
    required this.displayName,
    required this.equipmentTags,
  });

  /// Matches the PNG filename (without extension) in
  /// assets/images/3d/gym-equipment/renders/.
  final String id;
  final String displayName;
  final List<String> equipmentTags;

  String get imagePath => 'assets/images/3d/gym-equipment/renders/$id.png';
}

const List<EquipmentItem> equipmentCatalog = [
  EquipmentItem(id: 'Barbell_1', displayName: 'Barbell', equipmentTags: ['barbell']),
  EquipmentItem(id: 'Barbell_Stand_1', displayName: 'Barbell Rack', equipmentTags: ['barbell']),
  EquipmentItem(id: 'Bench_A', displayName: 'Adjustable Bench', equipmentTags: ['barbell', 'dumbbell']),
  EquipmentItem(id: 'Bench_Press', displayName: 'Bench Press Station', equipmentTags: ['barbell']),
  EquipmentItem(id: 'Dumbbells_1', displayName: 'Dumbbells', equipmentTags: ['dumbbell']),
  EquipmentItem(id: 'Dumbbells_2', displayName: 'Dumbbells (Fixed Set)', equipmentTags: ['dumbbell']),
  EquipmentItem(id: 'E_Machine_1', displayName: 'Cable Machine', equipmentTags: ['cable', 'machine']),
  EquipmentItem(id: 'Exercise_Bike', displayName: 'Exercise Bike', equipmentTags: ['other']),
  EquipmentItem(id: 'EzBar', displayName: 'EZ Curl Bar', equipmentTags: ['e-z curl bar']),
  EquipmentItem(id: 'Flat_Bench', displayName: 'Flat Bench', equipmentTags: ['barbell', 'dumbbell']),
  EquipmentItem(id: 'Kettlebell', displayName: 'Kettlebell', equipmentTags: ['kettlebells']),
  EquipmentItem(id: 'PecDeck_Ac_1', displayName: 'Pec Deck', equipmentTags: ['machine']),
  EquipmentItem(id: 'PullDown_Ac_1', displayName: 'Lat Pulldown Machine', equipmentTags: ['cable', 'machine']),
  EquipmentItem(id: 'Pullup_Bar', displayName: 'Pull-Up Bar', equipmentTags: ['body only']),
  EquipmentItem(id: 'Pullup_Stand', displayName: 'Pull-Up Stand', equipmentTags: ['body only']),
  EquipmentItem(id: 'Sm_Machine', displayName: 'Smith Machine', equipmentTags: ['machine']),
  EquipmentItem(id: 'Stationary_Rowing_Machine', displayName: 'Rowing Machine', equipmentTags: ['other']),
  EquipmentItem(id: 'Treadmill_1_Main', displayName: 'Treadmill', equipmentTags: ['other']),
  EquipmentItem(id: 'Treadmill_2_Main', displayName: 'Treadmill (Alt.)', equipmentTags: ['other']),
  EquipmentItem(id: 'Weight_A', displayName: 'Weight Plates', equipmentTags: ['barbell']),
  EquipmentItem(id: 'Weight_Stand_1', displayName: 'Weight Plate Stand', equipmentTags: ['barbell']),
];
