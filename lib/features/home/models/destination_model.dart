class Destination {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final bool visited;

  Destination({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.visited,
  });

  factory Destination.fromMap(String id, Map<String, dynamic> data) {
    return Destination(
      id: id,
      name: data['name'],
      lat: data['lat'],
      lng: data['lng'],
      visited: data['visited'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
      'visited': visited,
    };
  }
}
