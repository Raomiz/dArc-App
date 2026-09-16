import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../models/intention.dart';
import '../models/purpose.dart';
import '../nav/o_paces.dart';
import '../theme/o_theme.dart';
import '../widgets/field_backdrop.dart';
import '../widgets/o_navigator.dart';
import '../widgets/purpose_stage.dart';
import 'compose_intention_screen.dart';
import 'compose_purpose_screen.dart';
import 'intention_detail_screen.dart';

/// Home lands on **New Purpose**. Purpose is the stage.
///
/// Selected Purpose sits at centre, expanded, and holds Intentions,
/// Commit / Coordinate / More, and the other manners inside it.
/// Unselected Purposes stay as satellites — one pace to switch.
/// One New Purpose control: the gold/Byzantine FAB. No text twin.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.state});

  final OAppState state;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PurposeManner _manner = PurposeManner.intentions;
  String? _boundPurposeId;

  OAppState get state => widget.state;

  PurposeManner _mannerFor(String? purposeId) {
    if (purposeId != _boundPurposeId) {
      _boundPurposeId = purposeId;
      _manner = PurposeManner.intentions;
    }
    return _manner;
  }

  void _openNewPurpose() {
    openComposePurposeSheet(context: context, state: state);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final name = state.sessionName ?? 'You';
        final purpose = state.focusedPurpose;
        return FieldBackdrop(
          deepened: purpose != null,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'ō',
                style: TextStyle(
                  color: OColors.commit,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: OType.uiSans,
                ),
              ),
              actions: [
                const ONavigatorButton(),
                TextButton(
                  onPressed: () => state.leave(),
                  child: const Text(
                    'Leave',
                    style: TextStyle(color: OColors.muted),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              key: const Key('new-purpose-fab'),
              onPressed: _openNewPurpose,
              tooltip: 'New Purpose',
              backgroundColor: OColors.commit,
              foregroundColor: OColors.purposeDeep,
              icon: const Icon(Icons.add),
              label: const Text(
                'New Purpose',
                style: TextStyle(
                  fontFamily: OType.uiSans,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            body: purpose == null
                ? const _EmptyField()
                : _ExpandedField(
                    name: name,
                    purpose: purpose,
                    manner: _mannerFor(purpose.id),
                    satellites: state.purposes
                        .where((item) => item.id != purpose.id)
                        .toList(),
                    intentions: state.intentionsFor(purpose.id),
                    onSelectSatellite: (item) {
                      state.focusPurpose(item.id);
                      setState(() {
                        _boundPurposeId = item.id;
                        _manner = PurposeManner.intentions;
                      });
                    },
                    onManner: (next) => setState(() => _manner = next),
                    onCommitIntention: () => openComposeIntentionSheet(
                      context: context,
                      state: state,
                      purposeId: purpose.id,
                    ),
                    onCommit: (intention) =>
                        state.commitIntention(intention.id),
                    onCoordinate: (intention) => openCompanionFromStage(
                      context: context,
                      state: state,
                      intention: intention,
                    ),
                    onMore: (intention) => openIntentionMoreSheet(
                      context: context,
                      state: state,
                      intentionId: intention.id,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

/// First-open field after the local-name gate.
///
/// Living wash + ō wisp + one FAB. No demo copy. No twin CTA.
class _EmptyField extends StatelessWidget {
  const _EmptyField();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: SizedBox.shrink(key: Key('empty-field')),
    );
  }
}

class _ExpandedField extends StatelessWidget {
  const _ExpandedField({
    required this.name,
    required this.purpose,
    required this.manner,
    required this.satellites,
    required this.intentions,
    required this.onSelectSatellite,
    required this.onManner,
    required this.onCommitIntention,
    required this.onCommit,
    required this.onCoordinate,
    required this.onMore,
  });

  final String name;
  final Purpose purpose;
  final PurposeManner manner;
  final List<Purpose> satellites;
  final List<Intention> intentions;
  final ValueChanged<Purpose> onSelectSatellite;
  final ValueChanged<PurposeManner> onManner;
  final VoidCallback onCommitIntention;
  final ValueChanged<Intention> onCommit;
  final ValueChanged<Intention> onCoordinate;
  final ValueChanged<Intention> onMore;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        satellites.isEmpty ? 28 : 4,
        20,
        120,
      ),
      children: [
        Text('Hello, $name', style: OType.bodyMist.copyWith(fontSize: 14)),
        if (satellites.isNotEmpty) ...[
          const SizedBox(height: 10),
          PurposeOrbit(
            satellites: satellites,
            onSelect: onSelectSatellite,
          ),
        ] else
          const SizedBox(height: 22),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: KeyedSubtree(
            key: ValueKey(purpose.id),
            child: PurposeStage(
              key: const Key('purpose-stage'),
              purpose: purpose,
              intentions: intentions,
              manner: manner,
              onManner: onManner,
              onCommitIntention: onCommitIntention,
              onCommit: onCommit,
              onCoordinate: onCoordinate,
              onMore: onMore,
            ),
          ),
        ),
      ],
    );
  }
}
