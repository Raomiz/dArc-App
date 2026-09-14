import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/field_backdrop.dart';

class ComposeActionScreen extends StatefulWidget {
  const ComposeActionScreen({super.key, required this.state});

  final OAppState state;

  @override
  State<ComposeActionScreen> createState() => _ComposeActionScreenState();
}

class _ComposeActionScreenState extends State<ComposeActionScreen> {
  final _title = TextEditingController();
  final _intent = TextEditingController();
  final _when = TextEditingController();
  final _people = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _intent.dispose();
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
      await widget.state.addAction(
        title: _title.text,
        intent: _intent.text,
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
    return FieldBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Start an action')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            const Text(
              'Name the thing you will do with other people. ō coordinates. It does not post.',
              style: TextStyle(color: OColors.muted, height: 1.45),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Action',
                hintText: 'Evening walk',
                labelStyle: TextStyle(color: OColors.muted),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _intent,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Intent',
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
                hintText: 'Sam, Rin',
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
                backgroundColor: OColors.gold,
                foregroundColor: OColors.night,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Put it in motion'),
            ),
          ],
        ),
      ),
    );
  }
}
