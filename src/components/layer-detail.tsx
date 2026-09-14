import {
  CURRENT_FOCUS,
  CYCLE_EDGES,
  DESIGN_TRUTHS,
  OBSERVED,
  TECHNICAL_TRUTHS,
  layerById,
  type LayerId,
} from "@/lib/house/cycle";
import { cn } from "@/lib/cn";

function RuleList({
  items,
}: {
  items: { heading: string; body: string }[];
}) {
  return (
    <ul className="m-0 flex list-none flex-col gap-4 p-0">
      {items.map((item) => (
        <li key={item.heading}>
          <p className="m-0 text-[11px] tracking-[0.16em] text-gold-soft uppercase">
            {item.heading}
          </p>
          <p className="mt-1 mb-0 text-sm leading-relaxed text-mist">{item.body}</p>
        </li>
      ))}
    </ul>
  );
}

export function LayerDetail({ selected }: { selected: LayerId }) {
  const layer = layerById(selected);
  const edges = CYCLE_EDGES.filter((e) => e.from === selected || e.to === selected);

  return (
    <section
      aria-live="polite"
      className="flex flex-col gap-5 rounded-lg border border-gold/25 bg-void-mid/55 p-5 sm:p-6"
    >
      <header>
        <p
          className={cn(
            "m-0 text-[11px] tracking-[0.2em] uppercase",
            selected === "L0" && "text-gold-soft",
            selected === "L1" && "text-jade-lit",
            selected === "L2" && "text-byzantine-lit",
          )}
        >
          {layer.kicker}
        </p>
        <h2 className="mt-1 mb-0 font-display text-2xl text-frost">{layer.title}</h2>
        <p className="mt-2 mb-0 text-sm leading-relaxed text-mist">{layer.summary}</p>
        <p className="mt-2 mb-0 font-mono text-[11px] text-mist/70">{layer.file}</p>
      </header>

      <div className="flex flex-wrap gap-2">
        {edges.map((edge) => (
          <span
            key={`${edge.from}-${edge.to}-${edge.kind}`}
            className="rounded-full border border-gold/25 px-3 py-1 text-[11px] tracking-wide text-gold-soft"
          >
            {edge.from} → {edge.to} · {edge.label}
          </span>
        ))}
      </div>

      <RuleList items={layer.rules} />

      {selected === "L0" && (
        <div className="border-t border-gold/15 pt-4">
          <p className="m-0 text-[11px] tracking-[0.2em] text-gold-soft uppercase">
            Current focus
          </p>
          <h3 className="mt-1 mb-0 font-display text-xl text-frost">
            {CURRENT_FOCUS.title}
          </h3>
          <p className="mt-2 mb-0 text-sm leading-relaxed text-mist">{CURRENT_FOCUS.why}</p>
          <p className="mt-4 mb-2 text-[11px] tracking-[0.16em] text-jade-lit uppercase">
            Already built
          </p>
          <ul className="m-0 flex list-none flex-col gap-1.5 p-0">
            {CURRENT_FOCUS.already.map((line) => (
              <li key={line} className="text-sm leading-snug text-mist">
                {line}
              </li>
            ))}
          </ul>
          <p className="mt-4 mb-2 text-[11px] tracking-[0.16em] text-mist uppercase">
            Not this focus
          </p>
          <ul className="m-0 flex list-none flex-col gap-1.5 p-0">
            {CURRENT_FOCUS.notThis.map((line) => (
              <li key={line} className="text-sm leading-snug text-mist">
                {line}
              </li>
            ))}
          </ul>
        </div>
      )}

      {selected === "L1" && (
        <div className="grid gap-5 border-t border-gold/15 pt-4 sm:grid-cols-2">
          <div>
            <p className="m-0 text-[11px] tracking-[0.16em] text-gold-soft uppercase">
              Design truths
            </p>
            <div className="mt-3">
              <RuleList items={DESIGN_TRUTHS} />
            </div>
          </div>
          <div>
            <p className="m-0 text-[11px] tracking-[0.16em] text-jade-lit uppercase">
              Technical truths
            </p>
            <div className="mt-3">
              <RuleList items={TECHNICAL_TRUTHS} />
            </div>
          </div>
        </div>
      )}

      {selected === "L2" && (
        <div className="border-t border-gold/15 pt-4">
          <RuleList items={OBSERVED} />
        </div>
      )}
    </section>
  );
}
