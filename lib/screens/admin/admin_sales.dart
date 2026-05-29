import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSalesScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Control de Ventas"), backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('sales').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final sales = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID Orden')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: sales.map((s) {
                return DataRow(cells: [
                  DataCell(Text(s.id.substring(0, 5) + "...")),
                  DataCell(Text("\$${s['total'].toString()}")),
                  DataCell(Text(s['status'], style: TextStyle(fontWeight: FontWeight.bold, color: s['status'] == 'Entregado' ? Colors.green : Colors.orange))),
                  DataCell(IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showStatusDialog(context, s),
                  )),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showStatusDialog(BuildContext context, DocumentSnapshot doc) {
    String currentStatus = doc['status'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Cambiar Estado de Venta"),
          content: DropdownButton<String>(
            value: currentStatus,
            isExpanded: true,
            items: ['Pendiente', 'Preparando', 'Entregado'].map((String status) {
              return DropdownMenuItem<String>(value: status, child: Text(status));
            }).toList(),
            onChanged: (value) => setDialogState(() => currentStatus = value!),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
            TextButton(
              onPressed: () async {
                await _db.collection('sales').doc(doc.id).update({'status': currentStatus});
                Navigator.pop(context);
              },
              child: Text("Cambiar"),
            )
          ],
        ),
      ),
    );
  }
}