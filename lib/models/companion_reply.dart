class CompanionReply {
  const CompanionReply({
    required this.text,
    required this.nextMoves,
    required this.source,
    required this.stub,
  });

  final String text;
  final List<String> nextMoves;

  /// Implementation id, e.g. `stub`. Never a live model name unless wired.
  final String source;
  final bool stub;
}
