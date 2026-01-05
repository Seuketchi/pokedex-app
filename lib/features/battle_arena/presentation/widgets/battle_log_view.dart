import 'package:flutter/material.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_log.dart';

class BattleLogView extends StatelessWidget {
  const BattleLogView({
    required this.logs,
    super.key,
  });

  final List<BattleLog> logs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.grey[900],
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        reverse: true,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[logs.length - 1 - index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '> ${log.message}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Courier',
              ),
            ),
          );
        },
      ),
    );
  }
}
