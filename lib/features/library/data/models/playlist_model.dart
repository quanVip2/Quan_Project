class PlaylistModel {
  final int id;
  final String name;
  final String description;
  final String userId;
  final String? imageUrl;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    this.imageUrl,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      userId: json['userId'].toString(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }
} 