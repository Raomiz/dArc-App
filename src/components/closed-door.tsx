import { UserButton } from "@/lib/auth/gates";
import type { AppUser } from "@/lib/auth/use-current-user";
import { BOUND_EMAIL } from "@/lib/bound";

export function ClosedDoor({ user }: { user: AppUser }) {
  return (
    <div className="relative grid min-h-dvh place-items-center overflow-hidden bg-void px-4 py-10 text-frost">
      <div className="haze-field pointer-events-none absolute inset-0" />
      <main className="relative w-full max-w-[26rem] rounded-xl border border-closed/50 bg-void-mid/70 px-7 py-9 text-center shadow-[0_30px_80px_rgba(0,0,0,0.45)] backdrop-blur-md">
        <p className="m-0 text-[11px] tracking-[0.22em] text-gold-soft uppercase">
          Closed door
        </p>
        <h1 className="mt-2 mb-0 font-display text-5xl leading-none font-semibold text-gold-soft">
          d’ Arc
        </h1>
        <p className="mt-4 mb-0 text-sm leading-relaxed text-mist">
          The atlas is bound to one Google identity. This session is not that
          seal.
        </p>
        <p className="mt-5 mb-1 text-[11px] tracking-[0.18em] text-mist uppercase">
          Presented
        </p>
        <p className="m-0 text-sm text-frost">
          {user.primaryEmail ?? user.displayName ?? "Unknown"}
        </p>
        <p className="mt-4 mb-1 text-[11px] tracking-[0.18em] text-gold-soft uppercase">
          Bound
        </p>
        <p className="m-0 text-sm text-frost">{BOUND_EMAIL}</p>
        <div className="mt-6 flex justify-center">
          <UserButton />
        </div>
      </main>
    </div>
  );
}
