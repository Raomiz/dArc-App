import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/night_backdrop.dart';

class ComposePurposeScreen extends StatefulWidget {
  const ComposePurposeScreen({super.key, required this.state});

  final OAppState state;

  @override
  State<ComposePurposeScreen> createState() => _ComposePurposeScreenState();
}

class _ComposePurposeScreenState extends State<ComposePurposeScreen> {
  final _title = TextEditingController();
  final _why = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _why.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await widget.state.addPurpose(title: _title.text, why: _why.text);
      if (mounted) Navigator.of(context).pop();
    } on ArgumentError catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NightBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Name a purpose')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            const Text(
              'Purpose is why you act with other people. '
              'Intentions come after. ō does not post.',
              style: TextStyle(color: OColors.muted, height: 1.45),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                hintText: 'Get outside this week',
                labelStyle: TextStyle(color: OColors.byzantine),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _why,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Why',
                hintText: 'What has to be true for this to matter?',
                labelStyle: TextStyle(color: OColors.muted),
                alignLabelWithHint: true,
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
                backgroundColor: OColors.byzantine,
                foregroundColor: OColors.paper,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Hold this purpose'),
            ),
          ],
        ),
      ),
    );
  }
}
