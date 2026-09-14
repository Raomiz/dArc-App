import { o as __toESM } from "../_runtime.mjs";
import { B as require_react, b as require_jsx_runtime } from "../_libs/@tanstack/react-router+[...].mjs";
import { i as signOut, r as signIn, t as authClient } from "./client-CVqXY6bk.mjs";
import { t as BOUND_EMAIL } from "./bound-DgtnP-Qy.mjs";
import { i as hasGateSessionMarker } from "./server-D6IIiuIO.mjs";
//#region node_modules/.nitro/vite/services/ssr/assets/void-skeleton-UyEn9dzU.js
var import_react = /* @__PURE__ */ __toESM(require_react());
var import_jsx_runtime = require_jsx_runtime();
/**
* Current user + loading state. Same behavior in live preview and when deployed:
*   - Auth enabled -> the real signed-in user; `user` is `null` while
*                            the session resolves (`isPending: true`) and when
*                            signed out (`isPending: false`). Session comes from
*                            Better Auth `useSession()` → `/api/auth/get-session`
*                            (cookie when deployed; bearer in live preview).
*   - Auth disabled (`VITE_AUTH_ENABLED=false`) -> `DEV_USER`, never pending.
*
* Protect a route by waiting out `isPending` before acting on `user` —
* redirecting on `user: null` alone bounces signed-in visitors to sign-in on
* every hard reload:
*
*   import { RedirectToSignIn } from "@/lib/auth/gates";
*   const { user, isPending } = useCurrentUserState();
*   if (isPending) return null;              // still resolving — don't redirect yet
*   if (!user) return <RedirectToSignIn />;  // definitely signed out
*
* `authEnabled` is a module-level constant fixed at load, so the guarded hook
* call keeps a stable hook order across every render of a given component.
*/
function useCurrentUserState() {
	const { data, isPending } = authClient.useSession();
	const user = data?.user;
	return {
		user: user ? {
			id: user.id,
			displayName: user.name ?? null,
			primaryEmail: user.email ?? null,
			profileImageUrl: user.image ?? null,
			isDevFallback: false
		} : null,
		isPending
	};
}
/**
* Convenience view of `useCurrentUserState().user` for display (e.g.
* `user?.displayName ?? "Guest"`). NOTE: `null` means *loading OR signed out* —
* for redirects/guards use `useCurrentUserState()` and check `isPending`.
*/
function useCurrentUser() {
	return useCurrentUserState().user;
}
var subscribeToNothing = () => () => {};
var noGateSessionOnServer = () => false;
/**
* Minimal signed-in identity chip + sign-out. Restyle freely (see the
* `design-ui` skill). Sign-out is only shown when auth is enabled (the
* disabled-auth dev user has nothing to sign out of) and the session is not
* gate-materialized — behind the gate the next request signs the viewer
* straight back in, so a sign-out control there is a broken loop.
*/
function UserButton() {
	const user = useCurrentUser();
	const [signingOut, setSigningOut] = (0, import_react.useState)(false);
	const gateSession = (0, import_react.useSyncExternalStore)(subscribeToNothing, hasGateSessionMarker, noGateSessionOnServer);
	if (!user) return null;
	const label = user.displayName ?? user.primaryEmail ?? "Account";
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
		className: "flex items-center gap-2",
		children: [
			user.profileImageUrl ? /* @__PURE__ */ (0, import_jsx_runtime.jsx)("img", {
				src: user.profileImageUrl,
				alt: "",
				className: "h-8 w-8 rounded-full object-cover"
			}) : /* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
				className: "grid h-8 w-8 place-items-center rounded-full bg-black/10 text-sm font-medium dark:bg-white/20",
				children: label.charAt(0).toUpperCase()
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
				className: "text-sm font-medium",
				children: label
			}),
			!gateSession && /* @__PURE__ */ (0, import_jsx_runtime.jsx)("button", {
				type: "button",
				disabled: signingOut,
				onClick: () => {
					setSigningOut(true);
					signOut().catch(() => setSigningOut(false));
				},
				className: "cursor-pointer text-sm underline-offset-4 opacity-70 hover:underline disabled:cursor-wait disabled:no-underline",
				children: signingOut ? "Signing out…" : "Sign out"
			})
		]
	});
}
function ClosedDoor({ user }) {
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
		className: "relative grid min-h-dvh place-items-center overflow-hidden bg-void px-4 py-10 text-frost",
		children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", { className: "haze-field pointer-events-none absolute inset-0" }), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("main", {
			className: "relative w-full max-w-[26rem] rounded-xl border border-closed/50 bg-void-mid/70 px-7 py-9 text-center shadow-[0_30px_80px_rgba(0,0,0,0.45)] backdrop-blur-md",
			children: [
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase",
					children: "Closed door"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("h1", {
					className: "mt-2 mb-0 font-display text-5xl leading-none font-semibold text-gold-soft",
					children: "d’ Arc"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-4 mb-0 text-sm leading-relaxed text-mist",
					children: "The atlas is bound to one Google identity. This session is not that seal."
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-5 mb-1 text-[11px] tracking-[0.18em] text-mist uppercase",
					children: "Presented"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "m-0 text-sm text-frost",
					children: user.primaryEmail ?? user.displayName ?? "Unknown"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-4 mb-1 text-[11px] tracking-[0.18em] text-gold-soft uppercase",
					children: "Bound"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "m-0 text-sm text-frost",
					children: BOUND_EMAIL
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", {
					className: "mt-6 flex justify-center",
					children: /* @__PURE__ */ (0, import_jsx_runtime.jsx)(UserButton, {})
				})
			]
		})]
	});
}
function GoogleMark({ className }) {
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("svg", {
		className,
		viewBox: "0 0 24 24",
		"aria-hidden": "true",
		children: [
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("path", {
				fill: "#4285F4",
				d: "M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("path", {
				fill: "#34A853",
				d: "M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("path", {
				fill: "#FBBC05",
				d: "M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"
			}),
			/* @__PURE__ */ (0, import_jsx_runtime.jsx)("path", {
				fill: "#EA4335",
				d: "M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
			})
		]
	});
}
function Threshold() {
	const [busy, setBusy] = (0, import_react.useState)(false);
	const [err, setErr] = (0, import_react.useState)(null);
	async function openGoogle() {
		if (busy) return;
		setBusy(true);
		setErr(null);
		try {
			await signIn("grok-google", { callbackURL: "/" });
		} catch (error) {
			setErr(error instanceof Error ? error.message : "The door did not open.");
			setBusy(false);
		}
	}
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
		className: "relative grid min-h-dvh place-items-center overflow-hidden bg-void px-4 py-10 text-frost",
		children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", { className: "haze-field pointer-events-none absolute inset-0" }), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("main", {
			className: "relative w-full max-w-[26rem] rounded-xl border border-gold/40 bg-void-mid/70 px-7 py-9 text-center shadow-[0_30px_80px_rgba(0,0,0,0.45)] backdrop-blur-md",
			children: [
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase",
					children: "Private atlas"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("h1", {
					className: "mt-2 mb-0 font-display text-6xl leading-none font-semibold tracking-tight text-gold-soft",
					children: "d’ Arc"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-3 mb-0 font-display text-[1.35rem] text-mist italic",
					children: "Turn thinking into doing."
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-4 mb-0 text-sm leading-relaxed text-mist",
					children: "The atlas is the owner’s table. Sign in with the bound Google identity to look out across the cycle."
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "mt-6 mb-2 text-left text-[11px] tracking-[0.18em] text-gold-soft uppercase",
					children: "Bound identity"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "m-0 rounded-sm border border-gold/20 bg-void/70 px-3 py-2.5 text-left text-sm text-frost",
					children: BOUND_EMAIL
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsxs)("button", {
					type: "button",
					onClick: () => void openGoogle(),
					disabled: busy,
					className: "mt-5 flex h-12 w-full items-center justify-center gap-3 rounded-md border border-gold/50 bg-void-lit text-gold-soft transition-transform duration-150 ease-out hover:border-gold hover:bg-byzantine-deep disabled:cursor-wait disabled:opacity-70 active:not-disabled:scale-[0.96]",
					children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)(GoogleMark, { className: "size-5" }), /* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", { children: busy ? "Opening Google…" : "Continue with Google" })]
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: `mt-3 mb-0 min-h-[1.3em] text-sm ${err ? "text-closed" : "text-mist/80"}`,
					role: "status",
					children: err ?? "Only this Google account may enter."
				})
			]
		})]
	});
}
function VoidSkeleton() {
	return /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
		className: "relative grid min-h-dvh place-items-center overflow-hidden bg-void text-frost",
		children: [/* @__PURE__ */ (0, import_jsx_runtime.jsx)("div", { className: "haze-field pointer-events-none absolute inset-0" }), /* @__PURE__ */ (0, import_jsx_runtime.jsxs)("div", {
			className: "relative flex flex-col items-center gap-4",
			children: [
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("span", {
					className: "size-3 rounded-full bg-gold shadow-[0_0_0_2px_var(--color-gold-soft)]",
					"aria-hidden": true
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "font-display text-2xl tracking-tight text-gold-soft",
					children: "d’ Arc"
				}),
				/* @__PURE__ */ (0, import_jsx_runtime.jsx)("p", {
					className: "text-sm text-mist",
					children: "Opening the door…"
				})
			]
		})]
	});
}
//#endregion
export { useCurrentUserState as a, VoidSkeleton as i, Threshold as n, UserButton as r, ClosedDoor as t };
