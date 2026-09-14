/** The only identity that may open the atlas. */
export const BOUND_EMAIL = "jdraomiz@gmail.com";

export function isBoundIdentity(email: string | null | undefined): boolean {
  return String(email || "").trim().toLowerCase() === BOUND_EMAIL;
}

/**
 * Who may look out across the table.
 * Bound Gmail always. In the live preview the viewer is the owner.
 */
export function mayEnterAtlas(
  email: string | null | undefined,
  previewOwner: boolean,
): boolean {
  if (isBoundIdentity(email)) return true;
  return previewOwner;
}
