export type LayerId = "L0" | "L1" | "L2";

export type CycleLayer = {
  id: LayerId;
  title: string;
  file: string;
  role: string;
  kicker: string;
  summary: string;
  rules: { heading: string; body: string }[];
};

export type CycleEdge = {
  from: LayerId;
  to: LayerId;
  label: string;
  kind: "consult" | "change" | "escalate" | "finalize";
};

export const CYCLE_NAME = "Interactions cycle";
export const CYCLE_SOURCE = "AGENTS.md";

export const CYCLE_LAYERS: CycleLayer[] = [
  {
    id: "L0",
    title: "Layer 0",
    file: "AGENTS.md",
    role: "Interactions cycle + current focus",
    kicker: "Law of the work",
    summary:
      "The cycle itself, and what the house is attending to now. Read first, by any agent, in any tool.",
    rules: [
      {
        heading: "When this file updates",
        body: "Cycle portions change only when the interactions cycle itself changes. Current focus (section 5) changes as attention moves — ordinary Layer 0 motion, not a cycle change.",
      },
      {
        heading: "Process friction",
        body: "A need to change the cycle typically surfaces while working the current focus. The change is written here, in the cycle sections, not into Observed Reality.",
      },
    ],
  },
  {
    id: "L1",
    title: "Layer 1",
    file: "truth.mdc + techstack.mdc",
    role: "What is true",
    kicker: "Design + technical truths",
    summary:
      "Stable. Rarely changes. Identity, purpose, faces, process, field — and the technical law of the sealed canvas.",
    rules: [
      {
        heading: "Reason top-down",
        body: "Consult Layer 1 for truths, then the current focus in Layer 0, then open only the Layer 2 node a given question actually needs.",
      },
      {
        heading: "Versus current focus",
        body: "If the current focus conflicts with a Layer 1 truth, resolve by narrowing the focus or updating Layer 1 — whichever is actually correct. Never proceed with a known conflict unresolved.",
      },
    ],
  },
  {
    id: "L2",
    title: "Layer 2",
    file: "docs/",
    role: "Observed Reality",
    kicker: "What currently exists",
    summary:
      "What exists now, and the context applied when it was generated. Updates when a focus unit is finalized — not on every intermediate edit.",
    rules: [
      {
        heading: "When it updates",
        body: "Layer 2 updates when a specific feature or task within the current focus is finalized and committed — not batched until the entire focus is complete.",
      },
      {
        heading: "Versus Layer 1",
        body: "If Observed Reality conflicts with a Layer 1 truth, default to refining current focus, not Layer 1. Escalate to changing Layer 1 only if the conflict cannot be resolved that way.",
      },
    ],
  },
];

export const CYCLE_EDGES: CycleEdge[] = [
  { from: "L0", to: "L1", label: "consult truths", kind: "consult" },
  { from: "L1", to: "L2", label: "open the node needed", kind: "consult" },
  { from: "L2", to: "L0", label: "finalize updates focus", kind: "finalize" },
  { from: "L2", to: "L1", label: "escalate only if needed", kind: "escalate" },
  { from: "L1", to: "L0", label: "process change", kind: "change" },
];

export const CURRENT_FOCUS = {
  title: "Keep the atlas live as a single table",
  why: "d’ Arc exists so thinking can sit in one space. Interests present, complete overview, a place to contemplate and decide, ready to personalise.",
  already: [
    "Private atlas law: Process, Site, and Field.",
    "Seal: bound Gmail via Google. Only jdraomiz@gmail.com.",
    "House repository Raomiz/d-Arc; layers seated on main.",
    "Raz seated as a field watch and an interest.",
    "ō seated as a field watch, equal product alternative to Raz.",
    "Interactions cycle folded into Layer 0.",
  ],
  notThis: [
    "Building ō (Flutter, Play listing, paywall). The watch is seated; the companion is not built.",
    "Raz grind / Unreal on a below-standard PC.",
    "Chronicle / public field feed.",
    "Public writing on d-arc.io beyond standing copy.",
  ],
};

export const DESIGN_TRUTHS = [
  {
    heading: "Identity",
    body: "The house is d’ Arc. The bound identity is Joshua d’Arc Raōmiz, Gmail jdraomiz@gmail.com. Information is private and not viewable by the public.",
  },
  {
    heading: "Purpose",
    body: "Turn thinking into doing. Built for human connection. A companion for real-world action, not a public feed of private work.",
  },
  {
    heading: "Faces",
    body: "Threshold is the world’s door. Atlas is the owner’s table. House repo is the canonical store. Chronicle stays empty until action is meant to be seen.",
  },
  {
    heading: "Process",
    body: "Every project under d’ Arc is read through this cycle. Conflicts are flagged explicitly. Never silently resolved.",
  },
  {
    heading: "Field",
    body: "The Field is the watch-table for other projects and private information. Each watch is a node. Nothing here is public.",
  },
];

export const TECHNICAL_TRUTHS = [
  {
    heading: "Atlas runtime",
    body: "The private atlas is a sealed web canvas. Notes and field watches persist per sealed identity. They are never world-readable.",
  },
  {
    heading: "Auth and privacy",
    body: "Sign-in is required through Google. The only authorized identity is jdraomiz@gmail.com. A typed email is not a seal. Public visitors see the threshold — never the canvas.",
  },
  {
    heading: "House",
    body: "Canonical Layer 0–2 live in the private GitHub repository Raomiz/d-Arc. Other projects instantiate Layer 0 as their own root AGENTS.md.",
  },
];

export const OBSERVED = [
  {
    heading: "Atlas",
    body: "The sealed table opens only after a verified Google credential for the bound identity. Precincts include Process (this cycle), Site, and Field.",
  },
  {
    heading: "Seal",
    body: "Bound Gmail remains jdraomiz@gmail.com. The typed-email box is gone. The door is Continue with Google.",
  },
  {
    heading: "House repo",
    body: "Private: github.com/Raomiz/d-Arc. Layer 0 is AGENTS.md (cycle + focus). Layer 1 is truth.mdc and techstack.mdc. Layer 2 is docs/.",
  },
  {
    heading: "Assumptions",
    body: "Joshua opening the live preview is the bound identity. Adding a topic on the table is the path to a complete personal census.",
  },
  {
    heading: "ō",
    body: "Named on the Field as an equal watch to Raz. No Flutter package, Android build, or store path exists in this repository. The companion remains unbuilt.",
  },
];

export function layerById(id: LayerId): CycleLayer {
  const found = CYCLE_LAYERS.find((l) => l.id === id);
  if (!found) throw new Error(`Unknown layer ${id}`);
  return found;
}
