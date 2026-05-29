import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCategoriesScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Gestionar Categorías"), backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var cat = docs[index];
              return ListTile(
                title: Text(cat['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(cat['description'] ?? 'Sin descripción'),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditDialog(context, cat),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, DocumentSnapshot doc) {
    final nameCtrl = TextEditingController(text: doc['name']);
    final descCtrl = TextEditingController(text: doc['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar Categoría"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Nombre")),
            TextField(controller: descCtrl, decoration: InputDecoration(labelText: "Información")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          TextButton(
            onPressed: () async {
              await _db.collection('categories').doc(doc.id).update({
                'name': nameCtrl.text,
                'description': descCtrl.text,
              });
              Navigator.pop(context);
            },
            child: Text("Guardar"),
          )
        ],
      ),
    );
  }
}