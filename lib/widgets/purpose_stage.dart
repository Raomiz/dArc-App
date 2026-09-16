import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/intention.dart';
import '../models/purpose.dart';
import '../theme/o_theme.dart';
import 'empty_state.dart';
import 'intention_card.dart';

/// How you look at a Purpose — manners inside the expanded stage.
///
/// Not a filter row. Not a separate screen. Same Purpose, different lens.
enum PurposeManner { intentions, brewing, people, evidence }

extension PurposeMannerLabel on PurposeManner {
  String get label => switch (this) {
    PurposeManner.intentions => 'Intentions',
    PurposeManner.brewing => 'Brewing',
    PurposeManner.people => 'People',
    PurposeManner.evidence => 'Evidence',
  };

  String get keyName => name;
}

/// Selected Purpose at centre — expanded, holding its work inside.
class PurposeStage extends StatelessWidget {
  const PurposeStage({
    super.key,
    required this.purpose,
    required this.intentions,
    required this.manner,
    required this.onManner,
    required this.onCommitIntention,
    required this.onCommit,
    required this.onCoordinate,
    required this.onMore,
  });

  final Purpose purpose;
  final List<Intention> intentions;
  final PurposeManner manner;
  final ValueChanged<PurposeManner> onManner;
  final VoidCallback onCommitIntention;
  final ValueChanged<Intention> onCommit;
  final ValueChanged<Intention> onCoordinate;
  final ValueChanged<Intention> onMore;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: OType.stageSettleFrom, end: 1),
      duration: OType.stageSettle,
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: DecoratedBox(
        key: const Key('purpose-stage-bloom'),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const RadialGradient(
            center: Alignment(0, -0.35),
            radius: 1.05,
            colors: [
              OType.purposeBloom,
              Color.fromRGBO(112, 41, 99, 0.10),
              Color.fromRGBO(112, 41, 99, 0.00),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
          boxShadow: const [
            BoxShadow(
              color: OType.purposeBloom,
              blurRadius: 52,
              spreadRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PURPOSE',
                style: OType.whisper.copyWith(color: OColors.purpose),
              ),
              const SizedBox(height: 10),
              Text(purpose.title, style: OType.purposeTitle),
              const SizedBox(height: 8),
              Text(purpose.why, style: OType.bodyMist),
              const SizedBox(height: 18),
              _MannerRail(manner: manner, onManner: onManner),
              const SizedBox(height: 16),
              _MannerBody(
                manner: manner,
                intentions: intentions,
                onCommitIntention: onCommitIntention,
                onCommit: onCommit,
                onCoordinate: onCoordinate,
                onMore: onMore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MannerRail extends StatelessWidget {
  const _MannerRail({required this.manner, required this.onManner});

  final PurposeManner manner;
  final ValueChanged<PurposeManner> onManner;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in PurposeManner.values)
          Expanded(
            child: _MannerMark(
              manner: item,
              selected: item == manner,
              onTap: () => onManner(item),
            ),
          ),
      ],
    );
  }
}

class _MannerMark extends StatelessWidget {
  const _MannerMark({
    required this.manner,
    required this.selected,
    required this.onTap,
  });

  final PurposeManner manner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? OColors.purpose : OColors.muted;
    return Semantics(
      button: true,
      selected: selected,
      label: manner.label,
      child: InkWell(
        key: Key('purpose-manner-${manner.keyName}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Text(
                manner.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.2,
                  fontFamily: OType.uiSans,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2.5,
                width: selected ? 28 : 10,
                decoration: BoxDecoration(
                  color: selected ? OColors.purpose : OColors.outline,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MannerBody extends StatelessWidget {
  const _MannerBody({
    required this.manner,
    required this.intentions,
    required this.onCommitIntention,
    required this.onCommit,
    required this.onCoordinate,
    required this.onMore,
  });

  final PurposeManner manner;
  final List<Intention> intentions;
  final VoidCallback onCommitIntention;
  final ValueChanged<Intention> onCommit;
  final ValueChanged<Intention> onCoordinate;
  final ValueChanged<Intention> onMore;

  @override
  Widget build(BuildContext context) {
    return switch (manner) {
      PurposeManner.intentions => _IntentionManner(
        items: intentions,
        emptyTitle: 'Intention follows',
        emptyBody:
            'Commit an intention that achieves this purpose. '
            'ō coordinates when you ask. Nobody else is here yet.',
        onCommitIntention: onCommitIntention,
        onCommit: onCommit,
        onCoordinate: onCoordinate,
        onMore: onMore,
      ),
      PurposeManner.brewing => _IntentionManner(
        items: intentions
            .where((item) => item.status == IntentionStatus.brewing)
            .toList(),
        emptyTitle: 'Nothing brewing',
        emptyBody:
            'No intention is brewing under this purpose. '
            'Commit one — a named move with people.',
        onCommitIntention: onCommitIntention,
        onCommit: onCommit,
        onCoordinate: onCoordinate,
        onMore: onMore,
      ),
      PurposeManner.people => _PeopleManner(intentions: intentions),
      PurposeManner.evidence => _EvidenceManner(intentions: intentions),
    };
  }
}

class _IntentionManner extends StatelessWidget {
  const _IntentionManner({
    required this.items,
    required this.emptyTitle,
    required this.emptyBody,
    required this.onCommitIntention,
    required this.onCommit,
    required this.onCoordinate,
    required this.onMore,
  });

  final List<Intention> items;
  final String emptyTitle;
  final String emptyBody;
  final VoidCallback onCommitIntention;
  final ValueChanged<Intention> onCommit;
  final ValueChanged<Intention> onCoordinate;
  final ValueChanged<Intention> onMore;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(
        title: emptyTitle,
        body: emptyBody,
        accent: OColors.commit,
        primaryLabel: 'Commit an intention',
        onPrimary: onCommitIntention,
      );
    }
    return Column(
      children: [
        for (final intention in items) ...[
          IntentionCard(
            intention: intention,
            onCommit: intention.status == IntentionStatus.brewing
                ? () => onCommit(intention)
                : null,
            onCoordinate: () => onCoordinate(intention),
            onMore: () => onMore(intention),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PeopleManner extends StatelessWidget {
  const _PeopleManner({required this.intentions});

  final List<Intention> intentions;

  @override
  Widget build(BuildContext context) {
    final names = peopleOnPurpose(intentions);
    if (names.isEmpty) {
      return const Text(
        'Nobody else is here yet.',
        style: OType.bodyMist,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'People named on this purpose. No invented cast.',
          style: OType.bodyMist.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 14),
        for (final name in names) ...[
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: OColors.purpose,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: OType.intentionTitle.copyWith(color: OColors.purposeDeep),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _EvidenceManner extends StatelessWidget {
  const _EvidenceManner({required this.intentions});

  final List<Intention> intentions;

  @override
  Widget build(BuildContext context) {
    final items = intentions
        .where((item) => item.status != IntentionStatus.brewing)
        .toList();
    if (items.isEmpty) {
      return const Text(
        'No evidence yet. Commit an intention and it will hold here.',
        style: OType.bodyMist,
      );
    }
    return Column(
      children: [
        for (final intention in items) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: OColors.fieldAir.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(intention.title, style: OType.intentionTitle),
                  const SizedBox(height: 4),
                  Text(
                    '${intention.status.label} · ${intention.statement}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: OType.bodyMist.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

/// Unselected Purpose — a small satellite. One pace to become the stage.
class PurposeSatellite extends StatelessWidget {
  const PurposeSatellite({
    super.key,
    required this.purpose,
    required this.onTap,
  });

  final Purpose purpose;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trimmed = purpose.title.trim();
    final initial = trimmed.isEmpty
        ? 'P'
        : String.fromCharCode(trimmed.runes.first).toUpperCase();
    return Semantics(
      button: true,
      label: 'Purpose ${purpose.title}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 88,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OColors.purpose.withValues(alpha: 0.14),
                  border: Border.all(color: OColors.purpose, width: 1.3),
                  boxShadow: [
                    BoxShadow(
                      color: OColors.purpose.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: OColors.purpose,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: OType.uiSans,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                purpose.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: OType.whisper.copyWith(
                  color: OColors.purposeDeep,
                  fontSize: 11,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Satellites of unselected Purposes — not a chip filter row.
class PurposeOrbit extends StatelessWidget {
  const PurposeOrbit({
    super.key,
    required this.satellites,
    required this.onSelect,
  });

  final List<Purpose> satellites;
  final ValueChanged<Purpose> onSelect;

  @override
  Widget build(BuildContext context) {
    if (satellites.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      key: const Key('purpose-orbit-dim'),
      height: 108,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: OType.satelliteBlur,
          sigmaY: OType.satelliteBlur,
        ),
        child: Opacity(
          opacity: 0.44,
          child: CustomPaint(
            painter: _OrbitPainter(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < satellites.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Transform.translate(
                    offset: Offset(0, i.isEven ? -6 : 8),
                    child: PurposeSatellite(
                      key: Key('purpose-satellite-${satellites[i].id}'),
                      purpose: satellites[i],
                      onTap: () => onSelect(satellites[i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = OColors.purpose.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.72),
      width: size.width * 0.92,
      height: size.height * 0.9,
    );
    canvas.drawArc(rect, 3.35, 2.6, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

List<String> peopleOnPurpose(List<Intention> intentions) {
  final seen = <String>{};
  final names = <String>[];
  for (final item in intentions) {
    for (final person in item.people) {
      if (seen.add(person.toLowerCase())) {
        names.add(person);
      }
    }
  }
  return names;
}
