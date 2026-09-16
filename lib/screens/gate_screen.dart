import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/commit_button.dart';
import '../widgets/field_backdrop.dart';
import '../widgets/o_mark.dart';

class GateScreen extends StatefulWidget {
  const GateScreen({super.key, required this.state});

  final OAppState state;

  @override
  State<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends State<GateScreen> {
  final _name = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _enter() async {
    if (_busy) return;
    setState(() => _busy = true);
    await widget.state.enterLocal(displayName: _name.text);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return FieldBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OMark(size: 72),
                        const SizedBox(height: 22),
                        Text(
                          'ō',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: OColors.commit,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Act with others.',
                          style: OType.purposeTitle.copyWith(
                            fontWeight: FontWeight.w500,
                            color: OColors.ink,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Name a purpose. Commit an intention. '
                          'ō coordinating: lock a time, gather people, move.',
                          style: OType.bodyMist,
                        ),
                        const Spacer(),
                        const SizedBox(height: 28),
                        Text(
                          'On this device',
                          style: OType.whisper.copyWith(color: OColors.purpose),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No accounts. No server. A name stays here.',
                          style: TextStyle(color: OColors.muted, fontSize: 13),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _enter(),
                          decoration: const InputDecoration(
                            hintText: 'What should ō call you?',
                          ),
                        ),
                        const SizedBox(height: 14),
                        CommitButton(
                          key: const Key('gate-enter'),
                          label: _busy ? 'Entering…' : 'Enter ō locally',
                          onPressed: _busy ? null : _enter,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'd’ Arc house · Android first · Raz is a sibling product, not this app.',
                          style: TextStyle(color: Color(0xFF5A6B74), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
