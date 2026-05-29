class BranchModel {
  final String id;
  final String name;
  final String state; // Estado (ej. Chihuahua, Jalisco)
  final String address;
  final String schedule;

  BranchModel({
    required this.id,
    required this.name,
    required this.state,
    required this.address,
    required this.schedule,
  });

  factory BranchModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return BranchModel(
      id: documentId,
      name: data['name'] ?? '',
      state: data['state'] ?? '',
      address: data['address'] ?? '',
      schedule: data['schedule'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'state': state,
      'address': address,
      'schedule': schedule,
    };
  }
}