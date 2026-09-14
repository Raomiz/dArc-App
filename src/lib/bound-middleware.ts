import { createMiddleware } from "@tanstack/react-start";
import { isBoundIdentity } from "./bound";

function isPreviewProcess(): boolean {
  return !String(process.env.GROK_PROJECT_ID ?? "").trim();
}

/**
 * Same-origin session, then the bound-Gmail seal.
 * Private atlas rows never belong to a visitor who is merely signed in.
 * Preview has no GROK_PROJECT_ID — the viewer is the owner.
 */
export const boundMiddleware = createMiddleware({ type: "function" })
  .client(async ({ next }) => {
    const { getBearerToken } = await import("@/lib/auth/client");
    return next({ sendContext: { bearerToken: getBearerToken() ?? undefined } });
  })
  .server(async ({ next, context }) => {
    const { assertSameSiteRequest } = await import("@/lib/auth/isolation.server");
    const { getSessionUser, UnauthorizedError } = await import("@/lib/auth/verify.server");
    assertSameSiteRequest();
    const user = await getSessionUser(context.bearerToken);
    if (!user) throw new UnauthorizedError();
    if (!isBoundIdentity(user.email) && !isPreviewProcess()) {
      throw new UnauthorizedError();
    }
    return next({ context: { userId: user.id, email: user.email ?? "" } });
  });
