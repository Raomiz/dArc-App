import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../nav/o_paces.dart';
import '../theme/o_theme.dart';
import '../widgets/empty_state.dart';
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

  @override
  Widget build(BuildContext context) {
    final name = state.sessionName ?? 'You';
    return FieldBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'ō',
            style: TextStyle(
              color: OColors.commit,
              fontSize: 32,
              fontWeight: FontWeight.w600,
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
          onPressed: () => openComposePurposeSheet(
            context: context,
            state: state,
          ),
          backgroundColor: OColors.purpose,
          foregroundColor: OColors.paper,
          icon: const Icon(Icons.add),
          label: const Text('New Purpose'),
        ),
        body: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            final purpose = state.focusedPurpose;
            if (purpose == null) {
              return EmptyState(
                title: 'New Purpose',
                body:
                    'Hello, $name. This is the land — name a purpose. '
                    'Intentions follow from that north star. Nobody else is here yet.',
                accent: OColors.purpose,
                primaryLabel: 'New Purpose',
                onPrimary: () => openComposePurposeSheet(
                  context: context,
                  state: state,
                ),
              );
            }

            final manner = _mannerFor(purpose.id);
            final satellites = state.purposes
                .where((item) => item.id != purpose.id)
                .toList();
            final items = state.intentionsFor(purpose.id);

            return ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                satellites.isEmpty ? 28 : 4,
                20,
                120,
              ),
              children: [
                Text(
                  'Hello, $name',
                  style: const TextStyle(color: OColors.muted, fontSize: 14),
                ),
                if (satellites.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  PurposeOrbit(
                    satellites: satellites,
                    onSelect: (item) {
                      state.focusPurpose(item.id);
                      setState(() {
                        _boundPurposeId = item.id;
                        _manner = PurposeManner.intentions;
                      });
                    },
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
                      intentions: items,
                      manner: manner,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
