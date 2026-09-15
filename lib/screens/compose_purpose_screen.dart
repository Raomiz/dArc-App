import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../nav/o_paces.dart';
import '../theme/o_theme.dart';

Future<void> openComposePurposeSheet({
  required BuildContext context,
  required OAppState state,
}) {
  return showOSheet(
    context: context,
    heightFactor: 0.72,
    child: ComposePurposePanel(state: state),
  );
}

class ComposePurposePanel extends StatefulWidget {
  const ComposePurposePanel({super.key, required this.state});

  final OAppState state;

  @override
  State<ComposePurposePanel> createState() => _ComposePurposePanelState();
}

class _ComposePurposePanelState extends State<ComposePurposePanel> {
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
          'PURPOSE',
          style: OType.whisper.copyWith(color: OColors.purpose),
        ),
        const SizedBox(height: 8),
        const Text(
          'A quiet north star. Intentions come after — what you commit to do.',
          style: TextStyle(color: OColors.muted, height: 1.45),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _title,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Purpose',
            hintText: 'Get outside this week',
            labelStyle: TextStyle(color: OColors.purpose),
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
            backgroundColor: OColors.purpose,
            foregroundColor: OColors.paper,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Hold this purpose'),
        ),
      ],
    );
  }
}
