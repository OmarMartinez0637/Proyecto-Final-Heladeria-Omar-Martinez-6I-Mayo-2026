import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/constants.dart';

class AdminBranchesScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sucursales", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle, color: AppColors.dqRed, size: 30),
              onPressed: () => _showBranchForm(context, null), // null significa "Nueva Sucursal"
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('branches').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text("No hay sucursales registradas."));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Dirección')),
                  DataColumn(label: Text('Horario')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: docs.map((doc) {
                  return DataRow(cells: [
                    DataCell(Text(doc['name'] ?? '')),
                    DataCell(Text(doc['state'] ?? '')),
                    DataCell(Text(doc['address'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
                    DataCell(Text(doc['schedule'] ?? '')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showBranchForm(context, doc),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _db.collection('branches').doc(doc.id).delete();
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBranchForm(BuildContext context, DocumentSnapshot? doc) {
    final isEdit = doc != null;
    
    // Controladores cargados con datos existentes si es edición, o vacíos si es creación
    final nameCtrl = TextEditingController(text: isEdit ? doc['name'] : '');
    final stateCtrl = TextEditingController(text: isEdit ? doc['state'] : '');
    final addressCtrl = TextEditingController(text: isEdit ? doc['address'] : '');
    final scheduleCtrl = TextEditingController(text: isEdit ? doc['schedule'] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Editar Sucursal" : "Agregar Sucursal"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl, 
                decoration: InputDecoration(labelText: "Nombre de la Sucursal (ej. DQ Centro)"),
              ),
              TextField(
                controller: stateCtrl, 
                decoration: InputDecoration(labelText: "Estado (ej. Chihuahua)"),
              ),
              TextField(
                controller: addressCtrl, 
                decoration: InputDecoration(labelText: "Dirección completa"),
              ),
              TextField(
                controller: scheduleCtrl, 
                decoration: InputDecoration(labelText: "Horario (ej. 11:00 AM - 9:00 PM)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final data = {
                'name': nameCtrl.text.trim(),
                'state': stateCtrl.text.trim(),
                'address': addressCtrl.text.trim(),
                'schedule': scheduleCtrl.text.trim(),
              };

              if (isEdit) {
                // Modo Edición: Actualiza el documento existente
                await _db.collection('branches').doc(doc.id).update(data);
              } else {
                // Modo Creación: Añade un nuevo documento
                await _db.collection('branches').add(data);
              }
              
              Navigator.pop(context);
            },
            child: Text("Guardar", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}