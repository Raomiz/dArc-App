import { o as __toESM } from "../_runtime.mjs";
import { B as require_react, _ as useRouteContext, b as require_jsx_runtime } from "../_libs/@tanstack/react-router+[...].mjs";
import { r as createServerFn } from "./ssr.mjs";
import { Jt as object, Zt as string } from "../_libs/@better-auth/core+[...].mjs";
import { r as mayEnterAtlas } from "./bound-DgtnP-Qy.mjs";
import { t as boundMiddleware } from "./bound-middleware--PH6KUTu.mjs";
import { a as useCurrentUserState, i as VoidSkeleton, n as Threshold, r as UserButton, t as ClosedDoor } from "./void-skeleton-UyEn9dzU.mjs";
import { n as createSsrRpc } from "./router-BZSromjx.mjs";
import { t as clsx } from "../_libs/clsx.mjs";
import { t as twMerge } from "../_libs/tailwind-merge.mjs";
//#region node_modules/.nitro/vite/services/ssr/assets/routes-DEdTLM-8.js
var import_react = /* @__PURE__ */ __toESM(require_react());
var import_jsx_runtime = require_jsx_runtime();
var listComments = createServerFn({ method: "GET" }).middleware([boundMiddleware]).handler(createSsrRpc("3d5f16da5c4f0a35ec172fc9ee9b06a604bee01e19f96e5f2b3245289cb97b77"));
var addComment = createServerFn({ method: "POST" }).middleware([boundMiddleware]).validator(object({
	nodeId: string().min(1).max(64),
	body: string().trim().min(1).max(2e3)
})).handler(createSsrRpc("4bb6fed79dcea39c3edaada442dc5da628f821f1fb65af1ee6cb21ea19a57ae0"));
var PRECINCTS = [
	{
		id: "process",
		title: "Cycle",
		key: "1"
	},
	{
		id: "site",
		title: "Site",
		key: "2"
	},
	{
		id: "field",
		title: "Field",
		key: "3"
	}
];
var ATLAS_NODES = [
	{
		id: "cycle",
		precinct: "process",
		kicker: "Layer 0",
		title: "Interactions cycle",
		summary: "Law of the work. Current focus lives here. The diagram reads AGENTS.md.",
		kind: "law",
		featured: true,
		ready: true
	},
	{
		id: "truths",
		precinct: "process",
		kicker: "Layer 1",
		title: "Truths",
		summary: "Design and technical truths. Stable. Rarely change.",
		kind: "truth",
		ready: true
	},
	{
		id: "observed",
		precinct: "process",
		kicker: "Layer 2",
		title: "Observed Reality",
		summary: "What exists now. Updates when a focus unit is finalized.",
		kind: "observed",
		ready: true
	},
	{
		id: "focus",
		precinct: "process",
		kicker: "Attention",
		title: "Current focus",
		summary: "Keep the atlas live as one table. Folded into Layer 0.",
		kind: "focus",
		status: "live",
		ready: true
	},
	{
		id: "threshold",
		precinct: "site",
		kicker: "Public door",
		title: "d-arc.io",
		summary: "World’s door. Public copy only. Private work does not live there.",
		kind: "site",
		status: "threshold"
	},
	{
		id: "raz",
		precinct: "field",
		kicker: "Watch",
		title: "Raz",
		summary: "Private UE5.8 island world. Field watch + interest.",
		kind: "watch",
		status: "seated",
		featured: true
	}
];
function cn(...inputs) {
	return twMerge(clsx(inputs));
}
var CYCLE_SOURCE = "AGENTS.md";
var CYCLE_LAYERS = [
	{
		id: "L0",
		title: "Layer 0",
		file: "AGENTS.md",
		role: "Interactions cycle + current focus",
		kicker: "Law of the work",
		summary: "The cycle itself, and what the house is attending to now. Read first, by any agent, in any tool.",
		rules: [{
			heading: "When this file updates",
			body: "Cycle portions change only when the interactions cycle itself changes. Current focus (section 5) changes as attention moves — ordinary Layer 0 motion, not a cycle change."
		}, {
			heading: "Process friction",
			body: "A need to change the cycle typically surfaces while working the current focus. The change is written here, in the cycle sections, not into Observed Reality."
		}]
	},
	{
		id: "L1",
		title: "Layer 1",
		file: "truth.mdc + techstack.mdc",
		role: "What is true",
		kicker: "Design + technical truths",
		summary: "Stable. Rarely changes. Identity, purpose, faces, process, field — and the technical law of the sealed canvas.",
		rules: [{
			heading: "Reason top-down",
			body: "Consult Layer 1 for truths, then the current focus in Layer 0, then open only the Layer 2 node a given question actually needs."
		}, {
			heading: "Versus current focus",
			body: "If the current focus conflicts with a Layer 1 truth, resolve by narrowing the focus or updating Layer 1 — whichever is actually correct. Never proceed with a known conflict unresolved."
		}]
	},
	{
		id: "L2",
		title: "Layer 2",
		file: "docs/",
		role: "Observed Reality",
		kicker: "What currently exists",
		summary: "What exists now, and the context applied when it was generated. Updates when a focus unit is finalized — not on every intermediate edit.",
		rules: [{
			heading: "When it updates",
			body: "Layer 2 updates when a specific feature or task within the current focus is finalized and committed — not batched until the entire focus is complete."
		}, {
			heading: "Versus Layer 1",
			body: "If Observed Reality conflicts with a Layer 1 truth, default to refining current focus, not Layer 1. Escalate to changing Layer 1 only if the conflict cannot be resolved that way."
		}]
	}
];
var CYCLE_EDGES = [
	{
		from: "L0",
		to: "L1",
		label: "consult truths",
		kind: "consult"
	},
	{
		from: "L1",
		to: "L2",
		label: "open the node needed",
		kind: "consult"
	},
	{
		from: "L2",
		to: "L0",
		label: "finalize updates focus",
		kind: "finalize"
	},
	{
		from: "L2",
		to: "L1",
		label: "escalate only if needed",
		kind: "escalate"
	},
	{
		from: "L1",
		to: "L0",
		label: "process change",
		kind: "change"
	}
];
var CURRENT_FOCUS = {
	title: "Keep the atlas live as a single table",
	why: "d’ Arc exists so thinking can sit in one space. Interests present, complete overview, a place to contemplate and decide, ready to personalise.",
	already: [
		"Private atlas law: Process, Site, and Field.",
		"Seal: bound Gmail via Google. Only jdraomiz@gmail.com.",
		"House repository Raomiz/d-Arc; layers seated on main.",
		"Raz seated as a field watch and an interest.",
		"Interactions cycle folded into Layer 0."
	],
	notThis: [
		"The digital companion in the field.",
		"Chronicle / public field feed.",
		"Public writing on d-arc.io beyond standing copy."
	]
};
var DESIGN_TRUTHS = [
	{
		heading: "Identity",
		body: "The house is d’ Arc. The bound identity is Joshua d’Arc Raōmiz, Gmail jdraomiz@gmail.com. Information is private and not viewable by the public."
	},
	{
		heading: "Purpose",
		body: "Turn thinking into doing. Built for human connection. A companion for real-world action, not a public feed of private work."
	},
	{
		heading: "Faces",
		body: "Threshold is the world’s door. Atlas is the owner’s table. House repo is the canonical store. Chronicle stays empty until action is meant to be seen."
	},
	{
		heading: "Process",
		body: "Every project under d’ Arc is read through this cycle. Conflicts are flagged explicitly. Never silently resolved."
	},
	{
		heading: "Field",
		body: "The Field is the watch-table for other projects and private information. Each watch is a node. Nothing here is public."
	}
];
var TECHNICAL_TRUTHS = [
	{
		heading: "Atlas runtime",
		body: "The private atlas is a sealed web canvas. Notes and field watches persist per sealed identity. They are never world-readable."
	},
	{
		heading: "Auth and privacy",
		body: "Sign-in is required through Google. The only authorized identity is jdraomiz@gmail.com. A typed email is not a seal. Public visitors see the threshold — never the canvas."
	},
	{
		heading: "House",
		body: "Canonical Layer 0–2 live in the private GitHub repository Raomiz/d-Arc. Other projects instantiate Layer 0 as their own root AGENTS.md."
	}
];
var OBSERVED = [
	{
		heading: "Atlas",
		body: "The sealed table opens only after a verified Google credential for the bound identity. Precincts include Process (this cycle), Site, and Field."
	},
	{
		heading: "Seal",
		body: "Bound Gmail remains jdraomiz@gmail.com. The typed-email box is gone. The door is Continue with Google."
	},
	{
		heading: "House repo",
		body: "Private: github.com/Raomiz/d-Arc. Layer 0 is AGENTS.md (cycle + focus). Layer 1 is truth.mdc and techstack.mdc. Layer 2 is docs/."
	},
	{
		heading: "Assumptions",
		body: "Joshua opening the live preview is the bound identity. Adding a topic on the table is the path to a complete personal census."
	}
];
function layerById(id) {
	const found = CYCLE_LAYERS.find((l) => l.id === id);
	if (!found) throw new Error(`Unknown layer ${id}`);
	return found;
}
var TONE = {
	L0: {
		bar: "bg-gold",
		kicker: "text-gold-soft",
		ring: "border-gold/55"
	},
	L1: {
		bar: "bg-jade-lit",
		kicker: "text-jade-lit",
		ring: "border-jade-lit/45"
	},
	L2: {
		bar: "bg-byzantine-lit",
		kicker: "text-byzantine-lit",
		ring: "border-byzantine-lit/50"
	}
};
function Plate({ id, selected, onSelect }) {
	const layer = CYCLE_LAYERS.find((l) => l.id === id);
	const on = selected === id;
	const tone = TONE[id];
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("button", {
		type: "button",
		onClick: () => onSelect(id),
		"aria-pressed": on,
		className: cn("relative w-full rounded-md border bg-void-mid/80 px-5 py-3 text-left sm:px-6 sm:py-4", tone.ring, on ? "ring-1 ring-gold/40" : "opacity-90 hover:opacity-100"),
		children: [
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", { className: cn("absolute inset-y-0 left-0 w-1 rounded-l-md", tone.bar) }),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
				className: cn("block text-[10px] tracking-[0.2em] uppercase", tone.kicker),
				children: layer.kicker
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
				className: "mt-1 block font-display text-lg text-frost sm:text-xl",
				children: layer.title
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
				className: "mt-1 block text-sm leading-snug text-mist",
				children: layer.role
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
				className: "mt-2 hidden font-mono text-[10px] tracking-wide text-mist/70 sm:block",
				children: layer.file
			})
		]
	});
}
function Flow({ down, up }) {
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
		className: "grid grid-cols-2 items-center gap-2 px-1 py-2 sm:px-3",
		children: [/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("p", {
			className: "m-0 text-[10px] tracking-[0.14em] text-jade-lit uppercase sm:text-[11px]",
			children: ["↓ ", down]
		}), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("p", {
			className: "m-0 text-right text-[10px] tracking-[0.14em] text-gold-soft uppercase sm:text-[11px]",
			children: [up, " ↑"]
		})]
	});
}
function CycleDiagram({ selected, onSelect }) {
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("figure", {
		className: "m-0 w-full",
		children: [/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
			className: "relative pl-4 sm:pl-6",
			children: [
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
					className: "absolute top-4 bottom-4 left-0 w-px bg-gold/35",
					"aria-hidden": true
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)(Plate, {
					id: "L0",
					selected,
					onSelect
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)(Flow, {
					down: "consult truths",
					up: "process change"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)(Plate, {
					id: "L1",
					selected,
					onSelect
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)(Flow, {
					down: "open the node needed",
					up: "escalate only if needed"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)(Plate, {
					id: "L2",
					selected,
					onSelect
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-3 mb-0 pl-1 text-[10px] tracking-[0.14em] text-gold-soft/80 uppercase sm:text-[11px]",
					children: "↺ finalize updates focus"
				})
			]
		}), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("figcaption", {
			className: "mt-4 text-center text-[11px] tracking-[0.16em] text-gold-soft/70 uppercase",
			children: ["Interactions cycle · read from ", CYCLE_SOURCE]
		})]
	});
}
function RuleList({ items }) {
	return /* @__PURE__ */ (0, import_jsx_runtime.jsx)("ul", {
		className: "m-0 flex list-none flex-col gap-4 p-0",
		children: items.map((item) => /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("li", { children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
			className: "m-0 text-[11px] tracking-[0.16em] text-gold-soft uppercase",
			children: item.heading
		}), /* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
			className: "mt-1 mb-0 text-sm leading-relaxed text-mist",
			children: item.body
		})] }, item.heading))
	});
}
function LayerDetail({ selected }) {
	const layer = layerById(selected);
	const edges = CYCLE_EDGES.filter((e) => e.from === selected || e.to === selected);
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("section", {
		"aria-live": "polite",
		className: "flex flex-col gap-5 rounded-lg border border-gold/25 bg-void-mid/55 p-5 sm:p-6",
		children: [
			/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("header", { children: [
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: cn("m-0 text-[11px] tracking-[0.2em] uppercase", selected === "L0" && "text-gold-soft", selected === "L1" && "text-jade-lit", selected === "L2" && "text-byzantine-lit"),
					children: layer.kicker
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("h2", {
					className: "mt-1 mb-0 font-display text-2xl text-frost",
					children: layer.title
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-2 mb-0 text-sm leading-relaxed text-mist",
					children: layer.summary
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-2 mb-0 font-mono text-[11px] text-mist/70",
					children: layer.file
				})
			] }),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
				className: "flex flex-wrap gap-2",
				children: edges.map((edge) => /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("span", {
					className: "rounded-full border border-gold/25 px-3 py-1 text-[11px] tracking-wide text-gold-soft",
					children: [
						edge.from,
						" → ",
						edge.to,
						" · ",
						edge.label
					]
				}, `${edge.from}-${edge.to}-${edge.kind}`))
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)(RuleList, { items: layer.rules }),
			selected === "L0" && /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
				className: "border-t border-gold/15 pt-4",
				children: [
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
						className: "m-0 text-[11px] tracking-[0.2em] text-gold-soft uppercase",
						children: "Current focus"
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("h3", {
						className: "mt-1 mb-0 font-display text-xl text-frost",
						children: CURRENT_FOCUS.title
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
						className: "mt-2 mb-0 text-sm leading-relaxed text-mist",
						children: CURRENT_FOCUS.why
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
						className: "mt-4 mb-2 text-[11px] tracking-[0.16em] text-jade-lit uppercase",
						children: "Already built"
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("ul", {
						className: "m-0 flex list-none flex-col gap-1.5 p-0",
						children: CURRENT_FOCUS.already.map((line) => /* @__PURE__ */ (0, import_jsx_runtime.jsx)("li", {
							className: "text-sm leading-snug text-mist",
							children: line
						}, line))
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
						className: "mt-4 mb-2 text-[11px] tracking-[0.16em] text-mist uppercase",
						children: "Not this focus"
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("ul", {
						className: "m-0 flex list-none flex-col gap-1.5 p-0",
						children: CURRENT_FOCUS.notThis.map((line) => /* @__PURE__ */ (0, import_jsx_runtime.jsx)("li", {
							className: "text-sm leading-snug text-mist",
							children: line
						}, line))
					})
				]
			}),
			selected === "L1" && /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
				className: "grid gap-5 border-t border-gold/15 pt-4 sm:grid-cols-2",
				children: [/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", { children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "m-0 text-[11px] tracking-[0.16em] text-gold-soft uppercase",
					children: "Design truths"
				}), /* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
					className: "mt-3",
					children: /* @__PURE__ */ (0, import_jsx_runtime.jsx)(RuleList, { items: DESIGN_TRUTHS })
				})] }), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", { children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "m-0 text-[11px] tracking-[0.16em] text-jade-lit uppercase",
					children: "Technical truths"
				}), /* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
					className: "mt-3",
					children: /* @__PURE__ */ (0, import_jsx_runtime.jsx)(RuleList, { items: TECHNICAL_TRUTHS })
				})] })]
			}),
			selected === "L2" && /* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
				className: "border-t border-gold/15 pt-4",
				children: /* @__PURE__ */ (0, import_jsx_runtime.jsx)(RuleList, { items: OBSERVED })
			})
		]
	});
}
var KIND_DOT = {
	law: "bg-byzantine-lit shadow-[0_0_16px_rgba(154,74,134,0.45)]",
	truth: "bg-gold",
	observed: "bg-jade-lit",
	focus: "bg-gold-soft",
	watch: "bg-jade-lit shadow-[0_0_16px_rgba(125,186,154,0.55)]",
	site: "bg-gold-soft"
};
function AtlasTable({ lens, comments, onPin, onOpenCycle }) {
	const visible = (0, import_react.useMemo)(() => lens === "table" ? ATLAS_NODES : ATLAS_NODES.filter((n) => n.precinct === lens), [lens]);
	const [openId, setOpenId] = (0, import_react.useState)(null);
	const [draft, setDraft] = (0, import_react.useState)("");
	const [busy, setBusy] = (0, import_react.useState)(false);
	async function pin(event, nodeId) {
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
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
		className: "relative",
		children: [
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", { className: "pointer-events-none absolute inset-x-0 top-8 h-px horizon-line" }),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("ol", {
				className: "relative m-0 grid list-none gap-6 p-0 sm:grid-cols-2 xl:grid-cols-3",
				children: visible.map((node) => {
					const slips = comments.filter((c) => c.nodeId === node.id);
					const open = openId === node.id;
					return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("li", {
						className: "min-w-0",
						children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("button", {
							type: "button",
							onClick: () => {
								if (node.id === "cycle") onOpenCycle();
								else setOpenId(open ? null : node.id);
							},
							className: cn("w-full rounded-md border border-gold/15 bg-void-mid/50 px-3 py-3 text-left", open && "border-gold/40 bg-void-mid/80"),
							children: /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("span", {
								className: "flex items-start gap-3",
								children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
									className: cn("mt-2 size-2 shrink-0 rounded-full", KIND_DOT[node.kind]),
									"aria-hidden": true
								}), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("span", {
									className: "min-w-0",
									children: [
										/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
											className: "block text-[10px] tracking-[0.16em] text-gold-soft/80 uppercase",
											children: node.kicker
										}),
										/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
											className: "mt-0.5 block font-display text-xl text-frost",
											children: node.title
										}),
										/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
											className: "mt-1 block text-sm leading-snug text-mist",
											children: node.summary
										}),
										node.status && /* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
											className: "mt-2 block text-xs text-jade-lit",
											children: node.status
										})
									]
								})]
							})
						}), open && /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
							className: "mt-3 ml-5 border-l border-jade-lit/50 pl-3",
							children: [slips.map((slip) => /* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
								className: "mb-2 text-sm leading-snug text-frost italic",
								children: slip.body
							}, slip.id)), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("form", {
								onSubmit: (event) => void pin(event, node.id),
								className: "flex flex-col gap-2",
								children: [
									/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("label", {
										className: "sr-only",
										htmlFor: `note-${node.id}`,
										children: ["Comment beside ", node.title]
									}),
									/* @__PURE__ */ (0, import_jsx_runtime.jsx)("textarea", {
										id: `note-${node.id}`,
										rows: 3,
										value: draft,
										onChange: (e) => setDraft(e.target.value),
										placeholder: "A comment beside this thought",
										className: "w-full resize-y rounded-sm border border-jade-lit/40 bg-void/70 px-3 py-2 text-sm text-frost placeholder:text-mist/50"
									}),
									/* @__PURE__ */ (0, import_jsx_runtime.jsx)("button", {
										type: "submit",
										disabled: busy || !draft.trim(),
										className: "self-start rounded-sm border border-gold/40 px-3 py-1.5 text-sm text-gold-soft disabled:opacity-50",
										children: busy ? "Pinning…" : "Pin"
									})
								]
							})]
						})]
					}, node.id);
				})
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("p", {
				className: "mt-8 text-[11px] tracking-[0.14em] text-mist/70 uppercase",
				children: [
					PRECINCTS.find((p) => p.id === lens)?.title ?? "Whole field",
					" ·",
					" ",
					visible.length,
					" marks"
				]
			})
		]
	});
}
var LENSES = [
	{
		id: "cycle",
		label: "Cycle",
		key: "1"
	},
	{
		id: "table",
		label: "Look",
		key: "0"
	},
	{
		id: "site",
		label: "Site",
		key: "2"
	},
	{
		id: "field",
		label: "Field",
		key: "3"
	}
];
function AtlasShell() {
	const [lens, setLens] = (0, import_react.useState)("cycle");
	const [selected, setSelected] = (0, import_react.useState)("L0");
	const [comments, setComments] = (0, import_react.useState)([]);
	const [jump, setJump] = (0, import_react.useState)("");
	(0, import_react.useEffect)(() => {
		listComments().then(setComments).catch(() => setComments([]));
	}, []);
	(0, import_react.useEffect)(() => {
		function onKey(event) {
			const target = event.target;
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
	async function pin(nodeId, body) {
		const row = await addComment({ data: {
			nodeId,
			body
		} });
		if (row) setComments((prev) => [...prev, row]);
	}
	const hits = jump.trim() ? LENSES.filter((l) => l.label.toLowerCase().includes(jump.toLowerCase())) : [];
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
		className: "relative flex min-h-dvh flex-col bg-void text-frost",
		children: [
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", { className: "haze-field pointer-events-none absolute inset-0" }),
			/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("header", {
				className: "relative z-10 flex items-center gap-3 border-b border-gold/20 px-3 py-2.5 pt-[max(0.65rem,env(safe-area-inset-top))] sm:px-5",
				children: [
					/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("button", {
						type: "button",
						onClick: () => setLens("cycle"),
						className: "flex shrink-0 items-baseline gap-2",
						children: [
							/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
								className: "size-2.5 self-center rounded-full bg-gold shadow-[0_0_0_2px_var(--color-gold)]",
								"aria-hidden": true
							}),
							/* @__PURE__ */ (0, import_jsx_runtime.jsx)("strong", {
								className: "font-display text-xl font-semibold text-gold-soft",
								children: "d’ Arc"
							}),
							/* @__PURE__ */ (0, import_jsx_runtime.jsx)("em", {
								className: "hidden text-xs text-mist italic sm:inline",
								children: "private atlas"
							})
						]
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("nav", {
						className: "hidden items-center gap-1 md:flex",
						"aria-label": "Lenses",
						children: LENSES.map((item) => /* @__PURE__ */ (0, import_jsx_runtime.jsx)("button", {
							type: "button",
							onClick: () => setLens(item.id),
							className: cn("rounded-sm border px-3 py-1.5 text-sm", lens === item.id ? "border-gold text-gold-soft" : "border-transparent text-mist hover:text-frost"),
							children: item.label
						}, item.id))
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
						className: "ml-auto flex min-w-0 items-center gap-2",
						children: [
							/* @__PURE__ */ (0, import_jsx_runtime.jsx)("label", {
								className: "sr-only",
								htmlFor: "atlas-jump",
								children: "Jump"
							}),
							/* @__PURE__ */ (0, import_jsx_runtime.jsx)("input", {
								id: "atlas-jump",
								type: "search",
								placeholder: "Jump · /",
								value: jump,
								onChange: (e) => setJump(e.target.value),
								className: "hidden w-32 rounded-sm border border-gold/30 bg-void/70 px-3 py-1.5 text-sm text-frost placeholder:text-mist/50 lg:block"
							}),
							/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
								className: "atlas-who text-frost [&_img]:size-7 [&_button]:text-gold-soft",
								children: /* @__PURE__ */ (0, import_jsx_runtime.jsx)(UserButton, {})
							})
						]
					})
				]
			}),
			hits.length > 0 && /* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
				className: "relative z-10 mx-4 mt-2 max-w-sm self-end rounded-sm border border-gold bg-void-mid p-2 sm:mx-6",
				children: hits.map((item) => /* @__PURE__ */ (0, import_jsx_runtime.jsx)("button", {
					type: "button",
					className: "block w-full px-2 py-1.5 text-left text-sm text-frost hover:bg-gold/15",
					onClick: () => {
						setLens(item.id);
						setJump("");
					},
					children: item.label
				}, item.id))
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("main", {
				className: "relative z-10 mx-auto flex w-full max-w-6xl flex-1 flex-col px-4 py-5 sm:px-6 sm:py-7",
				children: lens === "cycle" ? /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
					className: "grid items-start gap-8 lg:grid-cols-[minmax(0,1.05fr)_minmax(17rem,0.95fr)]",
					children: [/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", { children: [
						/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
							className: "m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase",
							children: "Layer 0"
						}),
						/* @__PURE__ */ (0, import_jsx_runtime.jsx)("h1", {
							className: "mt-1 mb-1 font-display text-3xl text-frost sm:text-4xl",
							children: "Interactions cycle"
						}),
						/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
							className: "mt-0 mb-5 max-w-xl text-sm leading-relaxed text-mist",
							children: "Reason top-down. Consult truths, then the current focus, then only the observed node the question needs. Tap a layer to read it."
						}),
						/* @__PURE__ */ (0, import_jsx_runtime.jsx)(CycleDiagram, {
							selected,
							onSelect: setSelected
						})
					] }), /* @__PURE__ */ (0, import_jsx_runtime.jsx)(LayerDetail, { selected })]
				}) : /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", { children: [
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
						className: "m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase",
						children: lens === "table" ? "Whole field" : PRECINCTS.find((p) => p.id === lens)?.title
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)("h1", {
						className: "mt-1 mb-6 font-display text-3xl text-frost",
						children: lens === "table" ? "Look" : "Marks on the table"
					}),
					/* @__PURE__ */ (0, import_jsx_runtime.jsx)(AtlasTable, {
						lens: lens === "table" ? "table" : lens,
						comments,
						onPin: pin,
						onOpenCycle: () => setLens("cycle")
					})
				] })
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("nav", {
				className: "relative z-10 grid grid-cols-4 border-t border-gold/20 md:hidden",
				"aria-label": "Lenses",
				children: LENSES.map((item) => /* @__PURE__ */ (0, import_jsx_runtime.jsx)("button", {
					type: "button",
					onClick: () => setLens(item.id),
					className: cn("min-h-12 text-sm", lens === item.id ? "text-gold-soft" : "text-mist"),
					children: item.label
				}, item.id))
			})
		]
	});
}
function HouseGate({ children }) {
	const { previewOwner } = useRouteContext({ from: "__root__" });
	const { user, isPending } = useCurrentUserState();
	if (isPending) return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(VoidSkeleton, {});
	if (!user) return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(Threshold, {});
	if (!mayEnterAtlas(user.primaryEmail, previewOwner)) return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(ClosedDoor, { user });
	return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(import_jsx_runtime.Fragment, { children });
}
function Home() {
	return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(HouseGate, { children: /* @__PURE__ */ (0, import_jsx_runtime.jsx)(AtlasShell, {}) });
}
//#endregion
export { Home as component };
