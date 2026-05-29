import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminClientsScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Clientes"), backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final clients = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Rol')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: clients.map((c) {
                return DataRow(cells: [
                  DataCell(Text(c['email'])),
                  DataCell(Text(c['role'] ?? 'user')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditClientDialog(context, c),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async => await _db.collection('users').doc(c.id).delete(),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showEditClientDialog(BuildContext context, DocumentSnapshot doc) {
    final emailCtrl = TextEditingController(text: doc['email']);
    String selectedRole = doc['role'] ?? 'user';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Editar Cliente"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Correo Electrónico")),
              SizedBox(height: 15),
              DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                items: ['user', 'admin'].map((String role) {
                  return DropdownMenuItem<String>(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) => setDialogState(() => selectedRole = value!),
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
            TextButton(
              onPressed: () async {
                await _db.collection('users').doc(doc.id).update({
                  'email': emailCtrl.text,
                  'role': selectedRole,
                });
                Navigator.pop(context);
              },
              child: Text("Actualizar"),
            )
          ],
        ),
      ),
    );
  }
}