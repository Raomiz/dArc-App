import { cn } from "@/lib/cn";
import { CYCLE_LAYERS, CYCLE_SOURCE, type LayerId } from "@/lib/house/cycle";

const TONE: Record<LayerId, { bar: string; kicker: string; ring: string }> = {
  L0: {
    bar: "bg-gold",
    kicker: "text-gold-soft",
    ring: "border-gold/55",
  },
  L1: {
    bar: "bg-jade-lit",
    kicker: "text-jade-lit",
    ring: "border-jade-lit/45",
  },
  L2: {
    bar: "bg-byzantine-lit",
    kicker: "text-byzantine-lit",
    ring: "border-byzantine-lit/50",
  },
};

function Plate({
  id,
  selected,
  onSelect,
}: {
  id: LayerId;
  selected: LayerId;
  onSelect: (id: LayerId) => void;
}) {
  const layer = CYCLE_LAYERS.find((l) => l.id === id)!;
  const on = selected === id;
  const tone = TONE[id];
  return (
    <button
      type="button"
      onClick={() => onSelect(id)}
      aria-pressed={on}
      className={cn(
        "relative w-full rounded-md border bg-void-mid/80 px-5 py-3 text-left sm:px-6 sm:py-4",
        tone.ring,
        on ? "ring-1 ring-gold/40" : "opacity-90 hover:opacity-100",
      )}
    >
      <span className={cn("absolute inset-y-0 left-0 w-1 rounded-l-md", tone.bar)} />
      <span className={cn("block text-[10px] tracking-[0.2em] uppercase", tone.kicker)}>
        {layer.kicker}
      </span>
      <span className="mt-1 block font-display text-lg text-frost sm:text-xl">
        {layer.title}
      </span>
      <span className="mt-1 block text-sm leading-snug text-mist">{layer.role}</span>
      <span className="mt-2 hidden font-mono text-[10px] tracking-wide text-mist/70 sm:block">
        {layer.file}
      </span>
    </button>
  );
}

function Flow({ down, up }: { down: string; up: string }) {
  return (
    <div className="grid grid-cols-2 items-center gap-2 px-1 py-2 sm:px-3">
      <p className="m-0 text-[10px] tracking-[0.14em] text-jade-lit uppercase sm:text-[11px]">
        ↓ {down}
      </p>
      <p className="m-0 text-right text-[10px] tracking-[0.14em] text-gold-soft uppercase sm:text-[11px]">
        {up} ↑
      </p>
    </div>
  );
}

export function CycleDiagram({
  selected,
  onSelect,
}: {
  selected: LayerId;
  onSelect: (id: LayerId) => void;
}) {
  return (
    <figure className="m-0 w-full">
      <div className="relative pl-4 sm:pl-6">
        <div
          className="absolute top-4 bottom-4 left-0 w-px bg-gold/35"
          aria-hidden
        />
        <Plate id="L0" selected={selected} onSelect={onSelect} />
        <Flow down="consult truths" up="process change" />
        <Plate id="L1" selected={selected} onSelect={onSelect} />
        <Flow down="open the node needed" up="escalate only if needed" />
        <Plate id="L2" selected={selected} onSelect={onSelect} />
        <p className="mt-3 mb-0 pl-1 text-[10px] tracking-[0.14em] text-gold-soft/80 uppercase sm:text-[11px]">
          ↺ finalize updates focus
        </p>
      </div>
      <figcaption className="mt-4 text-center text-[11px] tracking-[0.16em] text-gold-soft/70 uppercase">
        Interactions cycle · read from {CYCLE_SOURCE}
      </figcaption>
    </figure>
  );
}
