import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../models/companion_reply.dart';
import '../models/intention.dart';
import '../models/purpose.dart';
import '../theme/o_theme.dart';

class ThreadTurn {
  const ThreadTurn({required this.fromUser, required this.text, this.stub = false});

  final bool fromUser;
  final String text;
  final bool stub;
}

Future<void> openCompanionSheet({
  required BuildContext context,
  required OAppState state,
  required Intention intention,
  Purpose? purpose,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: OColors.field,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.86,
          child: CompanionPanel(
            state: state,
            intention: intention,
            purpose: purpose,
          ),
        ),
      );
    },
  );
}

class CompanionPanel extends StatefulWidget {
  const CompanionPanel({
    super.key,
    required this.state,
    required this.intention,
    this.purpose,
  });

  final OAppState state;
  final Intention intention;
  final Purpose? purpose;

  @override
  State<CompanionPanel> createState() => _CompanionPanelState();
}

class _CompanionPanelState extends State<CompanionPanel> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _turns = <ThreadTurn>[];
  bool _busy = false;

  OAppState get state => widget.state;
  Intention get intention => widget.intention;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _ask('');
  }

  Future<void> _ask(String note) async {
    if (_busy) return;
    final from = state.session?.displayName ?? 'You';
    setState(() {
      _busy = true;
      if (note.trim().isNotEmpty) {
        _turns.add(ThreadTurn(fromUser: true, text: note.trim()));
      }
    });
    final CompanionReply reply = await state.companion.assist(
      intention: intention,
      purpose: widget.purpose,
      fromName: from,
      userNote: note,
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _turns.add(
        ThreadTurn(fromUser: false, text: reply.text, stub: reply.stub),
      );
      for (final move in reply.nextMoves) {
        _turns.add(
          ThreadTurn(
            fromUser: false,
            text: 'Next · $move',
            stub: reply.stub,
          ),
        );
      }
    });
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompts = state.companion.suggestedPrompts(intention);
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF3D3450),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text(
                'ō',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: OColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Coordinator',
                  style: TextStyle(color: OColors.muted, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OColors.stub.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: OColors.stub),
                ),
                child: Text(
                  state.companion.isStub ? 'STUB' : state.companion.id,
                  style: const TextStyle(
                    color: OColors.stub,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            'Mock replies, labeled stub. Live chat will be ${state.companion.liveChatLabel}. '
            'No API key. Not OpenAI.',
            style: const TextStyle(color: OColors.muted, fontSize: 13, height: 1.35),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: prompts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return ActionChip(
                label: Text(prompt),
                backgroundColor: OColors.ridge,
                side: BorderSide.none,
                labelStyle: const TextStyle(color: OColors.paper, fontSize: 13),
                onPressed: _busy ? null : () => _ask(prompt),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            itemCount: _turns.length + (_busy ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _turns.length) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'ō is drafting a stub…',
                    style: TextStyle(color: OColors.muted),
                  ),
                );
              }
              final turn = _turns[index];
              return Align(
                alignment: turn.fromUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  constraints: const BoxConstraints(maxWidth: 340),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  decoration: BoxDecoration(
                    color: turn.fromUser ? OColors.byzantineDeep : OColors.ridge,
                    borderRadius: BorderRadius.circular(16),
                    border: turn.stub
                        ? Border.all(color: OColors.stub.withValues(alpha: 0.45))
                        : null,
                  ),
                  child: Text(
                    turn.text,
                    style: const TextStyle(height: 1.4),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(
                    hintText: 'Ask ō to help you act…',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _busy ? null : _send,
                style: IconButton.styleFrom(
                  backgroundColor: OColors.gold,
                  foregroundColor: OColors.night,
                  minimumSize: const Size(52, 52),
                ),
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _send() {
    final text = _input.text;
    _input.clear();
    _ask(text);
  }
}
