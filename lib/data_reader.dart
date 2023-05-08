import 'package:csv/csv.dart';
import 'package:evolution/models/evolution.dart';
import 'package:evolution/models/evolution_stage.dart';
import 'package:evolution/services/accentuation_extension.dart';
import 'package:evolution/services/capitalization_extension.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';

class DataReader {
  static List<Evolution> evolutions = [];
  static List<Evolution>? filter;

  /// Remove accentuation, set to lowercase and translate to portuguese
  static Future<Set<String>> _normalizeInputWithTranslation(Set<String> input, [translate = true]) async {
    var translator = GoogleTranslator();
    return (await Future.wait(
      input.map(
        (word) async {
          if (translate) {
            word = (await translator.translate(word, from: 'auto', to: 'pt')).text;
          }
          return word.toLowerCase().removeAccentuation();
        },
      ),
    ))
        .toList()
        .toSet();
  }

  /// Remove accentuation, set to lowercase and translate to portuguese
  static Set<String> _normalizeInput(Set<String> input) {
    return input
        .map(
          (word) => word.toLowerCase().removeAccentuation(),
        )
        .toList()
        .toSet();
  }

  static Future<void> search(Set<String> input) async {
    input = await _normalizeInputWithTranslation(input);
    if (input.isEmpty) {
      filter = null;
    } else {
      filter = evolutions
          .where(
            (evolution) => _normalizeInput(evolution.keywords).intersection(input).isNotEmpty,
          )
          .toSet()
          .toList();
    }
  }

  static Future<bool> readEvolutions() async {
    try {
      final data = await rootBundle.loadString('assets/data/evolution_data.csv');
      List<List<dynamic>> rows = const CsvToListConverter().convert(data);
      rows.removeAt(0);
      for (List<dynamic> row in rows) {
        int id = row[0];
        List<String> names = row[1].split(' ');
        Set<String> keywords = row[2].split(' ').toSet();
        String colorCode = 'FF${row[3]}';
        Color color = Color(int.parse(colorCode, radix: 16));
        List<EvolutionStage> stages = [];
        for (int i = 0; i < names.length; i++) {
          stages.add(
            EvolutionStage(
              id,
              String.fromCharCode(i),
              'assets/images/$id${String.fromCharCode(97 + i)}.png',
              names[i].replaceAll('_', ' ').capitalize(),
            ),
          );
        }
        evolutions.add(Evolution(id, stages, keywords, color));
      }
      shuffleEvolutions();
      return true;
    } catch (e) {
      return false;
    }
  }

  static void shuffleEvolutions() {
    evolutions.shuffle();
  }
}
