import 'package:evolution/data_reader.dart';
import 'package:evolution/models/evolution.dart';
import 'package:evolution/services/capitalization_extension.dart';
import 'package:flutter/material.dart';
import 'package:evolution/evolution_tile.dart';

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  bool loading = false;
  double tilePaddingWeight = 0.01;
  int tilesPerRowDesktop = 5;
  int tilesPerRowMobile = 2;

  _search(String value) async {
    Set<String> searchInput = value.trim().split(' ').toSet();
    searchInput.removeWhere((word) => word.isEmpty);
    await DataReader.search(searchInput);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    var screenWidth = MediaQuery.of(context).size.width;
    var tilesPerRow = isMobile ? tilesPerRowMobile : tilesPerRowDesktop;
    var tilePadding = screenWidth * tilePaddingWeight;
    var tileWidth = (screenWidth - ((tilesPerRow + 1) * tilePadding)) / tilesPerRow;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / (isMobile ? 1 : 3),
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
                        child: Wrap(
                          spacing: tilePadding,
                          runSpacing: tilePadding,
                          children: [
                            for (Evolution evolution in DataReader.filter ?? DataReader.evolutions)
                              SizedBox(width: tileWidth, child: EvolutionTile(evolution: evolution, stageWidth: tileWidth / 2)),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
