import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/night_backdrop.dart';

class ComposeIntentionScreen extends StatefulWidget {
  const ComposeIntentionScreen({
    super.key,
    required this.state,
    required this.purposeId,
  });

  final OAppState state;
  final String purposeId;

  @override
  State<ComposeIntentionScreen> createState() => _ComposeIntentionScreenState();
}

class _ComposeIntentionScreenState extends State<ComposeIntentionScreen> {
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

  Future<void> _save() async {
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
      );
      if (mounted) Navigator.of(context).pop();
    } on ArgumentError catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final purpose = widget.state.purposeById(widget.purposeId);
    return NightBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Commit an intention')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              purpose == null
                  ? 'Name the move you will do with other people.'
                  : 'Under “${purpose.title}”. Name the move. ō coordinates. It does not post.',
              style: const TextStyle(color: OColors.muted, height: 1.45),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Intention',
                hintText: 'Evening walk',
                labelStyle: TextStyle(color: OColors.jadeSoft),
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
                hintText: 'Rin, Ade',
                labelStyle: TextStyle(color: OColors.muted),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Color(0xFFCF6679))),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: OColors.jade,
                foregroundColor: OColors.night,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Hold this intention'),
            ),
          ],
        ),
      ),
    );
  }
}
