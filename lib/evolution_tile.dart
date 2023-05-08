import 'package:evolution/models/evolution.dart';
import 'package:evolution/models/evolution_stage.dart';
import 'package:evolution/widgets/hoverable_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EvolutionTile extends StatefulWidget {
  final Evolution evolution;
  const EvolutionTile({super.key, required this.evolution});

  @override
  State<EvolutionTile> createState() => _EvolutionTileState();
}

class _EvolutionTileState extends State<EvolutionTile> {
  int currentStage = 0;
  bool holding = false;
  bool hovering = false;

  void _nextStage() {
    setState(() {
      currentStage = currentStage + 1 >= widget.evolution.stages.length ? 0 : currentStage + 1;
    });
  }

  Widget _singleStage() {
    return Stack(
      children: [
        Image.asset(widget.evolution.stages[currentStage].fileName),
        Align(
          alignment: Alignment.topLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: hovering
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.evolution.color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (currentStage + 1).toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _allStages() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: [
        for (EvolutionStage stage in widget.evolution.stages) Image.asset(stage.fileName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: holding ? _allStages() : _singleStage(),
      ),
      onTap: () {
        _nextStage();
      },
      onHold: (value) {
        setState(() {
          holding = value;
        });
      },
      onHover: (value) {
        setState(() {
          hovering = value;
        });
      },
    );
  }
}
