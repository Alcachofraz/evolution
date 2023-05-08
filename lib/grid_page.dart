import 'dart:developer';

import 'package:evolution/data_reader.dart';
import 'package:evolution/models/evolution.dart';
import 'package:evolution/services/capitalization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:evolution/evolution_tile.dart';

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  bool loading = false;

  _search(String value) async {
    Set<String> searchInput = value.trim().split(' ').toSet();
    searchInput.removeWhere((word) => word.isEmpty);
    log(searchInput.toString());
    await DataReader.search(searchInput);
    log(DataReader.filter.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextField(
                  onSubmitted: (value) async {
                    setState(() {
                      loading = true;
                    });
                    await _search(value);
                    setState(() {
                      loading = false;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: DataReader.evolutions[0].keywords.elementAt(0).capitalize(),
                    border: const OutlineInputBorder(),
                    label: const Text(
                      'Procura a tua evolução',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: StaggeredGrid.extent(
                              maxCrossAxisExtent: 300,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              children: [
                                for (Evolution evolution in DataReader.filter ?? DataReader.evolutions) EvolutionTile(evolution: evolution),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
