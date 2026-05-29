import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/branches_provider.dart';
import '../utils/constants.dart';
import 'branch_grid_screen.dart';

class BranchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final branchesProv = context.watch<BranchesProvider>();
    final groupedData = branchesProv.filteredStatesGroupedByLetter;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text("Sucursales", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            onChanged: (val) => branchesProv.setSearchQuery(val),
            decoration: InputDecoration(
              hintText: "Buscar sucursal...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: groupedData.entries.map((entry) {
              return Card(
                margin: EdgeInsets.all(15),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    // Parte de arriba roja con la letra
                    Container(
                      width: double.infinity,
                      color: AppColors.dqRed,
                      padding: EdgeInsets.all(10),
                      child: Text(entry.key, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    // Lista de estados con esa letra
                    ...entry.value.map((state) => ListTile(
                          title: Text(state),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BranchGridScreen(stateName: state),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}