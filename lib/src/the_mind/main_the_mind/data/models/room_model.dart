class RoomModel {
  final int id;
  final String? name;
  final int? capacity;

  const RoomModel({
    required this.id,
    this.name,
    this.capacity,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String?,
        capacity: json['capacity'] as int?,
      );
}