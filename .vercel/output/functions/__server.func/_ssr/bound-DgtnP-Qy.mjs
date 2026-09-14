//#region node_modules/.nitro/vite/services/ssr/assets/bound-DgtnP-Qy.js
/** The only identity that may open the atlas. */
var BOUND_EMAIL = "jdraomiz@gmail.com";
function isBoundIdentity(email) {
	return String(email || "").trim().toLowerCase() === BOUND_EMAIL;
}
/**
* Who may look out across the table.
* Bound Gmail always. In the live preview the viewer is the owner.
*/
function mayEnterAtlas(email, previewOwner) {
	if (isBoundIdentity(email)) return true;
	return previewOwner;
}
//#endregion
export { isBoundIdentity as n, mayEnterAtlas as r, BOUND_EMAIL as t };
