import { r as createServerFn } from "./ssr.mjs";
import { t as createServerRpc } from "./createServerRpc-CcvdN_gc.mjs";
import { Jt as object, Zt as string } from "../_libs/@better-auth/core+[...].mjs";
import { t as boundMiddleware } from "./bound-middleware--PH6KUTu.mjs";
//#region node_modules/.nitro/vite/services/ssr/assets/comments-BNvbdCGL.js
var listComments_createServerFn_handler = createServerRpc({
	id: "3d5f16da5c4f0a35ec172fc9ee9b06a604bee01e19f96e5f2b3245289cb97b77",
	name: "listComments",
	filename: "src/lib/atlas/comments.ts"
}, (opts) => listComments.__executeServer(opts));
var listComments = createServerFn({ method: "GET" }).middleware([boundMiddleware]).handler(listComments_createServerFn_handler, async ({ context }) => {
	const { getSql } = await import("./db-BTrU7-Is.mjs").then((n) => n.t).then((n) => n.t);
	return (await (await getSql())`
      select id, node_id, body, created_at
      from atlas_comments
      where user_id = ${context.userId}
      order by created_at asc
    `).map((row) => ({
		id: row.id,
		nodeId: row.node_id,
		body: row.body,
		createdAt: row.created_at
	}));
});
var addComment_createServerFn_handler = createServerRpc({
	id: "4bb6fed79dcea39c3edaada442dc5da628f821f1fb65af1ee6cb21ea19a57ae0",
	name: "addComment",
	filename: "src/lib/atlas/comments.ts"
}, (opts) => addComment.__executeServer(opts));
var addComment = createServerFn({ method: "POST" }).middleware([boundMiddleware]).validator(object({
	nodeId: string().min(1).max(64),
	body: string().trim().min(1).max(2e3)
})).handler(addComment_createServerFn_handler, async ({ context, data }) => {
	const { getSql } = await import("./db-BTrU7-Is.mjs").then((n) => n.t).then((n) => n.t);
	const row = (await (await getSql())`
      insert into atlas_comments (user_id, node_id, body)
      values (${context.userId}, ${data.nodeId}, ${data.body})
      returning id, node_id, body, created_at
    `)[0];
	if (!row) return null;
	return {
		id: row.id,
		nodeId: row.node_id,
		body: row.body,
		createdAt: row.created_at
	};
});
//#endregion
export { addComment_createServerFn_handler, listComments_createServerFn_handler };
