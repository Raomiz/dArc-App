/// House presence — session name only until someone real is named.
///
/// Never invent a cast. Known demo names (Rin, Ade, generic "You")
/// are stripped so the vault / field stays personal.
const placeholderCast = {'rin', 'ade'};

bool isPlaceholderHuman(String name) {
  final trimmed = name.trim().toLowerCase();
  if (trimmed.isEmpty) return true;
  if (trimmed == 'you') return true;
  return placeholderCast.contains(trimmed);
}

/// Session name first, then any real names the user typed.
/// Placeholder cast never survives.
List<String> housePresence({
  required Iterable<String> people,
  String? sessionName,
}) {
  final session = sessionName?.trim() ?? '';
  final others = <String>[];
  final seen = <String>{if (session.isNotEmpty) session.toLowerCase()};

  for (final person in people) {
    final trimmed = person.trim();
    if (isPlaceholderHuman(trimmed)) continue;
    final key = trimmed.toLowerCase();
    if (seen.contains(key)) continue;
    seen.add(key);
    others.add(trimmed);
  }

  if (session.isEmpty) return others;
  return [session, ...others];
}
