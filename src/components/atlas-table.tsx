import { useMemo, useState, type FormEvent } from "react";
import { cn } from "@/lib/cn";
import type { AtlasComment } from "@/lib/atlas/comments";
import {
  ATLAS_NODES,
  PRECINCTS,
  type AtlasNode,
  type PrecinctId,
} from "@/lib/house/atlas";

const KIND_DOT: Record<AtlasNode["kind"], string> = {
  law: "bg-byzantine-lit shadow-[0_0_16px_rgba(154,74,134,0.45)]",
  truth: "bg-gold",
  observed: "bg-jade-lit",
  focus: "bg-gold-soft",
  watch: "bg-jade-lit shadow-[0_0_16px_rgba(125,186,154,0.55)]",
  site: "bg-gold-soft",
};

export function AtlasTable({
  lens,
  comments,
  onPin,
  onOpenCycle,
}: {
  lens: "table" | PrecinctId;
  comments: AtlasComment[];
  onPin: (nodeId: string, body: string) => Promise<void>;
  onOpenCycle: () => void;
}) {
  const visible = useMemo(
    () =>
      lens === "table"
        ? ATLAS_NODES
        : ATLAS_NODES.filter((n) => n.precinct === lens),
    [lens],
  );
  const [openId, setOpenId] = useState<string | null>(null);
  const [draft, setDraft] = useState("");
  const [busy, setBusy] = useState(false);

  async function pin(event: FormEvent, nodeId: string) {
    event.preventDefault();
    const body = draft.trim();
    if (!body || busy) return;
    setBusy(true);
    try {
      await onPin(nodeId, body);
      setDraft("");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="relative">
      <div className="pointer-events-none absolute inset-x-0 top-8 h-px horizon-line" />
      <ol className="relative m-0 grid list-none gap-6 p-0 sm:grid-cols-2 xl:grid-cols-3">
        {visible.map((node) => {
          const slips = comments.filter((c) => c.nodeId === node.id);
          const open = openId === node.id;
          return (
            <li key={node.id} className="min-w-0">
              <button
                type="button"
                onClick={() => {
                  if (node.id === "cycle") onOpenCycle();
                  else setOpenId(open ? null : node.id);
                }}
                className={cn(
                  "w-full rounded-md border border-gold/15 bg-void-mid/50 px-3 py-3 text-left",
                  open && "border-gold/40 bg-void-mid/80",
                )}
              >
                <span className="flex items-start gap-3">
                  <span
                    className={cn(
                      "mt-2 size-2 shrink-0 rounded-full",
                      KIND_DOT[node.kind],
                    )}
                    aria-hidden
                  />
                  <span className="min-w-0">
                    <span className="block text-[10px] tracking-[0.16em] text-gold-soft/80 uppercase">
                      {node.kicker}
                    </span>
                    <span className="mt-0.5 block font-display text-xl text-frost">
                      {node.title}
                    </span>
                    <span className="mt-1 block text-sm leading-snug text-mist">
                      {node.summary}
                    </span>
                    {node.status && (
                      <span className="mt-2 block text-xs text-jade-lit">
                        {node.status}
                      </span>
                    )}
                  </span>
                </span>
              </button>
              {open && (
                <div className="mt-3 ml-5 border-l border-jade-lit/50 pl-3">
                  {slips.map((slip) => (
                    <p
                      key={slip.id}
                      className="mb-2 text-sm leading-snug text-frost italic"
                    >
                      {slip.body}
                    </p>
                  ))}
                  <form
                    onSubmit={(event) => void pin(event, node.id)}
                    className="flex flex-col gap-2"
                  >
                    <label className="sr-only" htmlFor={`note-${node.id}`}>
                      Comment beside {node.title}
                    </label>
                    <textarea
                      id={`note-${node.id}`}
                      rows={3}
                      value={draft}
                      onChange={(e) => setDraft(e.target.value)}
                      placeholder="A comment beside this thought"
                      className="w-full resize-y rounded-sm border border-jade-lit/40 bg-void/70 px-3 py-2 text-sm text-frost placeholder:text-mist/50"
                    />
                    <button
                      type="submit"
                      disabled={busy || !draft.trim()}
                      className="self-start rounded-sm border border-gold/40 px-3 py-1.5 text-sm text-gold-soft disabled:opacity-50"
                    >
                      {busy ? "Pinning…" : "Pin"}
                    </button>
                  </form>
                </div>
              )}
            </li>
          );
        })}
      </ol>
      <p className="mt-8 text-[11px] tracking-[0.14em] text-mist/70 uppercase">
        {PRECINCTS.find((p) => p.id === lens)?.title ?? "Whole field"} ·{" "}
        {visible.length} marks
      </p>
    </div>
  );
}
