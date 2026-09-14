import { useEffect, useState } from "react";
import { UserButton } from "@/lib/auth/gates";
import { addComment, listComments, type AtlasComment } from "@/lib/atlas/comments";
import { PRECINCTS, type PrecinctId } from "@/lib/house/atlas";
import type { LayerId } from "@/lib/house/cycle";
import { CycleDiagram } from "@/components/cycle-diagram";
import { LayerDetail } from "@/components/layer-detail";
import { AtlasTable } from "@/components/atlas-table";
import { cn } from "@/lib/cn";

type Lens = "cycle" | "table" | PrecinctId;

const LENSES: { id: Lens; label: string; key: string }[] = [
  { id: "cycle", label: "Cycle", key: "1" },
  { id: "table", label: "Look", key: "0" },
  { id: "site", label: "Site", key: "2" },
  { id: "field", label: "Field", key: "3" },
];

export function AtlasShell() {
  const [lens, setLens] = useState<Lens>("cycle");
  const [selected, setSelected] = useState<LayerId>("L0");
  const [comments, setComments] = useState<AtlasComment[]>([]);
  const [jump, setJump] = useState("");

  useEffect(() => {
    void listComments()
      .then(setComments)
      .catch(() => setComments([]));
  }, []);

  useEffect(() => {
    function onKey(event: KeyboardEvent) {
      const target = event.target as HTMLElement | null;
      if (target && target.matches("input, textarea")) return;
      if (event.key === "1") setLens("cycle");
      if (event.key === "0") setLens("table");
      if (event.key === "2") setLens("site");
      if (event.key === "3") setLens("field");
      if (event.key === "/") {
        event.preventDefault();
        document.getElementById("atlas-jump")?.focus();
      }
    }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, []);

  async function pin(nodeId: string, body: string) {
    const row = await addComment({ data: { nodeId, body } });
    if (row) setComments((prev) => [...prev, row]);
  }

  const hits = jump.trim()
    ? LENSES.filter((l) => l.label.toLowerCase().includes(jump.toLowerCase()))
    : [];

  return (
    <div className="relative flex min-h-dvh flex-col bg-void text-frost">
      <div className="haze-field pointer-events-none absolute inset-0" />

      <header className="relative z-10 flex items-center gap-3 border-b border-gold/20 px-3 py-2.5 pt-[max(0.65rem,env(safe-area-inset-top))] sm:px-5">
        <button
          type="button"
          onClick={() => setLens("cycle")}
          className="flex shrink-0 items-baseline gap-2"
        >
          <span
            className="size-2.5 self-center rounded-full bg-gold shadow-[0_0_0_2px_var(--color-gold)]"
            aria-hidden
          />
          <strong className="font-display text-xl font-semibold text-gold-soft">
            d’ Arc
          </strong>
          <em className="hidden text-xs text-mist italic sm:inline">private atlas</em>
        </button>

        <nav className="hidden items-center gap-1 md:flex" aria-label="Lenses">
          {LENSES.map((item) => (
            <button
              key={item.id}
              type="button"
              onClick={() => setLens(item.id)}
              className={cn(
                "rounded-sm border px-3 py-1.5 text-sm",
                lens === item.id
                  ? "border-gold text-gold-soft"
                  : "border-transparent text-mist hover:text-frost",
              )}
            >
              {item.label}
            </button>
          ))}
        </nav>

        <div className="ml-auto flex min-w-0 items-center gap-2">
          <label className="sr-only" htmlFor="atlas-jump">
            Jump
          </label>
          <input
            id="atlas-jump"
            type="search"
            placeholder="Jump · /"
            value={jump}
            onChange={(e) => setJump(e.target.value)}
            className="hidden w-32 rounded-sm border border-gold/30 bg-void/70 px-3 py-1.5 text-sm text-frost placeholder:text-mist/50 lg:block"
          />
          <div className="atlas-who text-frost [&_img]:size-7 [&_button]:text-gold-soft">
            <UserButton />
          </div>
        </div>
      </header>

      {hits.length > 0 && (
        <div className="relative z-10 mx-4 mt-2 max-w-sm self-end rounded-sm border border-gold bg-void-mid p-2 sm:mx-6">
          {hits.map((item) => (
            <button
              key={item.id}
              type="button"
              className="block w-full px-2 py-1.5 text-left text-sm text-frost hover:bg-gold/15"
              onClick={() => {
                setLens(item.id);
                setJump("");
              }}
            >
              {item.label}
            </button>
          ))}
        </div>
      )}

      <main className="relative z-10 mx-auto flex w-full max-w-6xl flex-1 flex-col px-4 py-5 sm:px-6 sm:py-7">
        {lens === "cycle" ? (
          <div className="grid items-start gap-8 lg:grid-cols-[minmax(0,1.05fr)_minmax(17rem,0.95fr)]">
            <div>
              <p className="m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase">
                Layer 0
              </p>
              <h1 className="mt-1 mb-1 font-display text-3xl text-frost sm:text-4xl">
                Interactions cycle
              </h1>
              <p className="mt-0 mb-5 max-w-xl text-sm leading-relaxed text-mist">
                Reason top-down. Consult truths, then the current focus, then
                only the observed node the question needs. Tap a layer to read
                it.
              </p>
              <CycleDiagram selected={selected} onSelect={setSelected} />
            </div>
            <LayerDetail selected={selected} />
          </div>
        ) : (
          <div>
            <p className="m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase">
              {lens === "table"
                ? "Whole field"
                : PRECINCTS.find((p) => p.id === lens)?.title}
            </p>
            <h1 className="mt-1 mb-6 font-display text-3xl text-frost">
              {lens === "table" ? "Look" : "Marks on the table"}
            </h1>
            <AtlasTable
              lens={lens === "table" ? "table" : lens}
              comments={comments}
              onPin={pin}
              onOpenCycle={() => setLens("cycle")}
            />
          </div>
        )}
      </main>

      <nav
        className="relative z-10 grid grid-cols-4 border-t border-gold/20 md:hidden"
        aria-label="Lenses"
      >
        {LENSES.map((item) => (
          <button
            key={item.id}
            type="button"
            onClick={() => setLens(item.id)}
            className={cn(
              "min-h-12 text-sm",
              lens === item.id ? "text-gold-soft" : "text-mist",
            )}
          >
            {item.label}
          </button>
        ))}
      </nav>
    </div>
  );
}
