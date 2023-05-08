class EvolutionStage {
  final int evolutionId;
  final String stageId;
  final String fileName;
  final String name;

  EvolutionStage(this.evolutionId, this.stageId, this.fileName, this.name);

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(other) => other is EvolutionStage && evolutionId == other.evolutionId && stageId == other.stageId;

  @override
  int get hashCode => evolutionId.hashCode + stageId.hashCode;
}
