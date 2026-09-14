export function VoidSkeleton() {
  return (
    <div className="relative grid min-h-dvh place-items-center overflow-hidden bg-void text-frost">
      <div className="haze-field pointer-events-none absolute inset-0" />
      <div className="relative flex flex-col items-center gap-4">
        <span
          className="size-3 rounded-full bg-gold shadow-[0_0_0_2px_var(--color-gold-soft)]"
          aria-hidden
        />
        <p className="font-display text-2xl tracking-tight text-gold-soft">d’ Arc</p>
        <p className="text-sm text-mist">Opening the door…</p>
      </div>
    </div>
  );
}
