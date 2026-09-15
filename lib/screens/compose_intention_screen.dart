import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../nav/o_paces.dart';
import '../theme/o_theme.dart';
import '../widgets/commit_button.dart';

Future<void> openComposeIntentionSheet({
  required BuildContext context,
  required OAppState state,
  required String purposeId,
}) {
  return showOSheet(
    context: context,
    child: ComposeIntentionPanel(state: state, purposeId: purposeId),
  );
}

class ComposeIntentionPanel extends StatefulWidget {
  const ComposeIntentionPanel({
    super.key,
    required this.state,
    required this.purposeId,
  });

  final OAppState state;
  final String purposeId;

  @override
  State<ComposeIntentionPanel> createState() => _ComposeIntentionPanelState();
}

class _ComposeIntentionPanelState extends State<ComposeIntentionPanel> {
  final _title = TextEditingController();
  final _statement = TextEditingController();
  final _when = TextEditingController();
  final _people = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _statement.dispose();
    _when.dispose();
    _people.dispose();
    super.dispose();
  }

  Future<void> _save({required bool commit}) async {
    try {
      final people = _people.text
          .split(RegExp(r'[,/]'))
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList();
      await widget.state.addIntention(
        purposeId: widget.purposeId,
        title: _title.text,
        statement: _statement.text,
        whenLabel: _when.text,
        people: people,
        commit: commit,
      );
      if (mounted) Navigator.of(context).pop();
    } on ArgumentError catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final purpose = widget.state.purposeById(widget.purposeId);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: OColors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'INTENTION',
          style: OType.whisper.copyWith(color: OColors.intention),
        ),
        const SizedBox(height: 8),
        Text(
          purpose == null
              ? 'Name the move you will do.'
              : 'Under “${purpose.title}”. Name the move, then Commit.',
          style: const TextStyle(color: OColors.muted, height: 1.45),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _title,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Intention',
            hintText: 'Evening walk',
            labelStyle: TextStyle(color: OColors.intention),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _statement,
          minLines: 3,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'What has to happen',
            hintText: 'What has to happen for this to be real?',
            labelStyle: TextStyle(color: OColors.muted),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _when,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'When (optional)',
            hintText: 'Tonight after 18:00',
            labelStyle: TextStyle(color: OColors.muted),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _people,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Who else (optional)',
            hintText: 'Leave empty until someone is real',
            labelStyle: TextStyle(color: OColors.muted),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: Color(0xFFCF6679))),
        ],
        const SizedBox(height: 24),
        CommitButton(
          label: 'Commit this intention',
          onPressed: () => _save(commit: true),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => _save(commit: false),
          style: OutlinedButton.styleFrom(
            foregroundColor: OColors.ink,
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: OColors.outline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Hold this intention'),
        ),
      ],
    );
  }
}
