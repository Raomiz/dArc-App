import { _ as useRouteContext, b as require_jsx_runtime, v as Navigate } from "../_libs/@tanstack/react-router+[...].mjs";
import { r as mayEnterAtlas } from "./bound-DgtnP-Qy.mjs";
import { a as useCurrentUserState, i as VoidSkeleton, n as Threshold, t as ClosedDoor } from "./void-skeleton-UyEn9dzU.mjs";
//#region node_modules/.nitro/vite/services/ssr/assets/login-7rjcW5SF.js
var import_jsx_runtime = require_jsx_runtime();
function Login() {
	const { previewOwner } = useRouteContext({ from: "__root__" });
	const { user, isPending } = useCurrentUserState();
	if (isPending) return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(VoidSkeleton, {});
	if (user && mayEnterAtlas(user.primaryEmail, previewOwner)) return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(Navigate, { to: "/" });
	if (user) return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(ClosedDoor, { user });
	return /* @__PURE__ */ (0, import_jsx_runtime.jsx)(Threshold, {});
}
//#endregion
export { Login as component };
