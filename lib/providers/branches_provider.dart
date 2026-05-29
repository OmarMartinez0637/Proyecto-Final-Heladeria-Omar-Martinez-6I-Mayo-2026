import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/branch_model.dart';

class BranchesProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<BranchModel> _branches = [];
  String _searchQuery = '';

  List<BranchModel> get branches => _branches;
  String get searchQuery => _searchQuery;

  void listenBranches() {
    _db.collection('branches').snapshots().listen((snapshot) {
      _branches = snapshot.docs.map((doc) => BranchModel.fromFirestore(doc.data(), doc.id)).toList();
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Obtener los estados únicos ordenados alfabéticamente e iniciales para las Cards
  Map<String, List<String>> get filteredStatesGroupedByLetter {
    // 1. Filtrar sucursales por búsqueda (nombre o estado)
    final filteredBranches = _branches.where((b) {
      final query = _searchQuery.toLowerCase();
      return b.name.toLowerCase().contains(query) || b.state.toLowerCase().contains(query);
    }).toList();

    // 2. Obtener lista de estados únicos
    final states = filteredBranches.map((b) => b.state).toSet().toList();
    states.sort((a, b) => a.compareTo(b));

    // 3. Agrupar estados por su letra inicial
    Map<String, List<String>> grouped = {};
    for (var state in states) {
      if (state.isEmpty) continue;
      String firstLetter = state.substring(0, 1).toUpperCase(); // Primera letra
      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(state);
    }
    return grouped;
  }

  // Obtener las sucursales específicas de un estado
  List<BranchModel> getBranchesByState(String state) {
    return _branches.where((b) => b.state.toLowerCase() == state.toLowerCase()).toList();
  }

  // CRUD Sucursales (Para gestión completa desde panel Admin si se requiere)
  Future<void> addBranch(BranchModel branch) async {
    await _db.collection('branches').add(branch.toFirestore());
  }
  
  Future<void> deleteBranch(String id) async {
    await _db.collection('branches').doc(id).delete();
  }
}

// Extensión rápida para capitalizar la primera letra de un string de forma segura
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}