import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class BranchGridScreen extends StatelessWidget {
  final String stateName;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  BranchGridScreen({required this.stateName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Sucursales en $stateName",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Filtramos directamente en Firestore las sucursales de este estado
        stream: _db.collection('branches').where('state', isEqualTo: stateName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.dqRed));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No hay sucursales registradas en este estado.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final branchDocs = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(15),
            itemCount: branchDocs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,          // 2 columnas de tarjetas
              childAspectRatio: 0.85,     // Proporción de tamaño de la card
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final branch = branchDocs[index];

              return Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encabezado de la Tarjeta con icono de tienda
                      Row(
                        children: [
                          Text("🏢", style: TextStyle(fontSize: 22)),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              branch['name'] ?? 'DQ Sucursal',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 15, color: Colors.grey[300]),
                      
                      // Dirección
                      Text(
                        "📍 Dirección:",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.dqBlue),
                      ),
                      SizedBox(height: 2),
                      Expanded(
                        child: Text(
                          branch['address'] ?? 'Dirección no disponible',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 5),

                      // Horario
                      Text(
                        "🕒 Horario:",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.dqRed),
                      ),
                      SizedBox(height: 2),
                      Text(
                        branch['schedule'] ?? 'No especificado',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}