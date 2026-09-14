export type PrecinctId = "process" | "site" | "field";

export type AtlasNode = {
  id: string;
  precinct: PrecinctId;
  kicker: string;
  title: string;
  summary: string;
  kind: "law" | "truth" | "observed" | "focus" | "watch" | "site";
  featured?: boolean;
  ready?: boolean;
  status?: string;
};

export const PRECINCTS: { id: PrecinctId; title: string; key: string }[] = [
  { id: "process", title: "Cycle", key: "1" },
  { id: "site", title: "Site", key: "2" },
  { id: "field", title: "Field", key: "3" },
];

export const ATLAS_NODES: AtlasNode[] = [
  {
    id: "cycle",
    precinct: "process",
    kicker: "Layer 0",
    title: "Interactions cycle",
    summary: "Law of the work. Current focus lives here. The diagram reads AGENTS.md.",
    kind: "law",
    featured: true,
    ready: true,
  },
  {
    id: "truths",
    precinct: "process",
    kicker: "Layer 1",
    title: "Truths",
    summary: "Design and technical truths. Stable. Rarely change.",
    kind: "truth",
    ready: true,
  },
  {
    id: "observed",
    precinct: "process",
    kicker: "Layer 2",
    title: "Observed Reality",
    summary: "What exists now. Updates when a focus unit is finalized.",
    kind: "observed",
    ready: true,
  },
  {
    id: "focus",
    precinct: "process",
    kicker: "Attention",
    title: "Current focus",
    summary: "Keep the atlas live as one table. Folded into Layer 0.",
    kind: "focus",
    status: "live",
    ready: true,
  },
  {
    id: "threshold",
    precinct: "site",
    kicker: "Public door",
    title: "d-arc.io",
    summary: "World’s door. Public copy only. Private work does not live there.",
    kind: "site",
    status: "threshold",
  },
  {
    id: "o",
    precinct: "field",
    kicker: "Watch",
    title: "ō",
    summary:
      "Digital companion in the field. Equal product alternative to Raz. Pocket door — named, not built.",
    kind: "watch",
    status: "named",
    featured: true,
  },
  {
    id: "raz",
    precinct: "field",
    kicker: "Watch",
    title: "Raz",
    summary:
      "Private UE5.8 island world. Equal product alternative to ō. Field watch + interest.",
    kind: "watch",
    status: "seated",
    featured: true,
  },
];

export function nodeById(id: string): AtlasNode | undefined {
  return ATLAS_NODES.find((n) => n.id === id);
}
