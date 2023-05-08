import 'package:evolution/models/evolution_stage.dart';
import 'package:flutter/material.dart';

class Evolution {
  final int id;
  final List<EvolutionStage> stages;
  final Set<String> keywords;
  final Color color;

  Evolution(this.id, this.stages, this.keywords, this.color);

  @override
  String toString() {
    return stages[0].name;
  }

  @override
  bool operator ==(other) => other is Evolution && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
