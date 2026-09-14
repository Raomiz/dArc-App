import { r as createServerFn } from "./_ssr/ssr.mjs";
import { t as createServerRpc } from "./_ssr/createServerRpc-CcvdN_gc.mjs";
//#region node_modules/.nitro/vite/services/ssr/assets/__root-CJefmCo7.js
var fetchHouseContext_createServerFn_handler = createServerRpc({
	id: "626bced988c070e67c2a2d118931cad0b003e5be13c552312d41ff003899290d",
	name: "fetchHouseContext",
	filename: "src/routes/__root.tsx"
}, (opts) => fetchHouseContext.__executeServer(opts));
var fetchHouseContext = createServerFn({ method: "GET" }).handler(fetchHouseContext_createServerFn_handler, async () => {
	const { getSessionUser } = await import("./_ssr/verify.server-gagPHUsI.mjs");
	const u = await getSessionUser();
	return {
		sessionUser: u ? {
			id: u.id,
			email: u.email
		} : null,
		previewOwner: !String(process.env.GROK_PROJECT_ID ?? "").trim()
	};
});
//#endregion
export { fetchHouseContext_createServerFn_handler };
