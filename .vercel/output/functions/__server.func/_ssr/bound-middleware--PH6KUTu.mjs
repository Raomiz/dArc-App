import { n as createMiddleware } from "./ssr.mjs";
import { n as isBoundIdentity } from "./bound-DgtnP-Qy.mjs";
//#region node_modules/.nitro/vite/services/ssr/assets/bound-middleware--PH6KUTu.js
function isPreviewProcess() {
	return !String(process.env.GROK_PROJECT_ID ?? "").trim();
}
/**
* Same-origin session, then the bound-Gmail seal.
* Private atlas rows never belong to a visitor who is merely signed in.
* Preview has no GROK_PROJECT_ID — the viewer is the owner.
*/
var boundMiddleware = createMiddleware({ type: "function" }).client(async ({ next }) => {
	const { getBearerToken } = await import("./client-CVqXY6bk.mjs").then((n) => n.n).then((n) => n.n);
	return next({ sendContext: { bearerToken: getBearerToken() ?? void 0 } });
}).server(async ({ next, context }) => {
	const { assertSameSiteRequest } = await import("./isolation.server-CGNg1r0B.mjs");
	const { getSessionUser, UnauthorizedError } = await import("./verify.server-gagPHUsI.mjs");
	assertSameSiteRequest();
	const user = await getSessionUser(context.bearerToken);
	if (!user) throw new UnauthorizedError();
	if (!isBoundIdentity(user.email) && !isPreviewProcess()) throw new UnauthorizedError();
	return next({ context: {
		userId: user.id,
		email: user.email ?? ""
	} });
});
//#endregion
export { boundMiddleware as t };
