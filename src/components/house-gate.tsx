import type { ReactNode } from "react";
import { useRouteContext } from "@tanstack/react-router";
import { useCurrentUserState } from "@/lib/auth/use-current-user";
import { mayEnterAtlas } from "@/lib/bound";
import { ClosedDoor } from "@/components/closed-door";
import { Threshold } from "@/components/threshold";
import { VoidSkeleton } from "@/components/void-skeleton";

export function HouseGate({ children }: { children: ReactNode }) {
  const { previewOwner } = useRouteContext({ from: "__root__" });
  const { user, isPending } = useCurrentUserState();
  if (isPending) return <VoidSkeleton />;
  if (!user) return <Threshold />;
  if (!mayEnterAtlas(user.primaryEmail, previewOwner)) {
    return <ClosedDoor user={user} />;
  }
  return <>{children}</>;
}
