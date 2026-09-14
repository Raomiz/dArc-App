import { createFileRoute, Navigate, useRouteContext } from "@tanstack/react-router";
import { useCurrentUserState } from "@/lib/auth/use-current-user";
import { mayEnterAtlas } from "@/lib/bound";
import { ClosedDoor } from "@/components/closed-door";
import { Threshold } from "@/components/threshold";
import { VoidSkeleton } from "@/components/void-skeleton";

export const Route = createFileRoute("/login")({ component: Login });

function Login() {
  const { previewOwner } = useRouteContext({ from: "__root__" });
  const { user, isPending } = useCurrentUserState();
  if (isPending) return <VoidSkeleton />;
  if (user && mayEnterAtlas(user.primaryEmail, previewOwner)) {
    return <Navigate to="/" />;
  }
  if (user) return <ClosedDoor user={user} />;
  return <Threshold />;
}
