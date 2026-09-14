import { useState } from "react";
import { authEnabled, signIn } from "@/lib/auth/client";
import { BOUND_EMAIL } from "@/lib/bound";
import { GoogleMark } from "@/components/google-mark";

export function Threshold() {
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<string | null>(null);

  async function openGoogle() {
    if (busy) return;
    setBusy(true);
    setErr(null);
    try {
      await signIn("grok-google", { callbackURL: "/" });
    } catch (error) {
      setErr(
        error instanceof Error ? error.message : "The door did not open.",
      );
      setBusy(false);
    }
  }

  return (
    <div className="relative grid min-h-dvh place-items-center overflow-hidden bg-void px-4 py-10 text-frost">
      <div className="haze-field pointer-events-none absolute inset-0" />
      <main className="relative w-full max-w-[26rem] rounded-xl border border-gold/40 bg-void-mid/70 px-7 py-9 text-center shadow-[0_30px_80px_rgba(0,0,0,0.45)] backdrop-blur-md">
        <p className="m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase">
          Private atlas
        </p>
        <h1 className="mt-2 mb-0 font-display text-6xl leading-none font-semibold tracking-tight text-gold-soft">
          d’ Arc
        </h1>
        <p className="mt-3 mb-0 font-display text-[1.35rem] text-mist italic">
          Turn thinking into doing.
        </p>
        <p className="mt-4 mb-0 text-sm leading-relaxed text-mist">
          The atlas is the owner’s table. Sign in with the bound Google
          identity to look out across the cycle.
        </p>

        <p className="mt-6 mb-2 text-left text-[11px] tracking-[0.18em] text-gold-soft uppercase">
          Bound identity
        </p>
        <p className="m-0 rounded-sm border border-gold/20 bg-void/70 px-3 py-2.5 text-left text-sm text-frost">
          {BOUND_EMAIL}
        </p>

        {authEnabled ? (
          <button
            type="button"
            onClick={() => void openGoogle()}
            disabled={busy}
            className="mt-5 flex h-12 w-full items-center justify-center gap-3 rounded-md border border-gold/50 bg-void-lit text-gold-soft transition-transform duration-150 ease-out hover:border-gold hover:bg-byzantine-deep disabled:cursor-wait disabled:opacity-70 active:not-disabled:scale-[0.96]"
          >
            <GoogleMark className="size-5" />
            <span>{busy ? "Opening Google…" : "Continue with Google"}</span>
          </button>
        ) : (
          <p className="mt-5 text-sm text-mist">Sign-in is not seated on this door.</p>
        )}

        <p
          className={`mt-3 mb-0 min-h-[1.3em] text-sm ${err ? "text-closed" : "text-mist/80"}`}
          role="status"
        >
          {err ?? "Only this Google account may enter."}
        </p>
      </main>
    </div>
  );
}
