import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { ATLAS_NODES, nodeById } from "./atlas.ts";

describe("field watches", () => {
  it("seats ō and Raz as equal featured field watches", () => {
    const o = nodeById("o");
    const raz = nodeById("raz");
    assert.ok(o, "ō must be a field mark");
    assert.ok(raz, "Raz must be a field mark");
    assert.equal(o.precinct, "field");
    assert.equal(raz.precinct, "field");
    assert.equal(o.kind, "watch");
    assert.equal(raz.kind, "watch");
    assert.equal(o.featured, true);
    assert.equal(raz.featured, true);
    assert.equal(o.ready, undefined);
    assert.match(o.summary, /equal product alternative/i);
    assert.match(raz.summary, /equal product alternative/i);
  });

  it("does not claim ō is built", () => {
    const o = nodeById("o");
    assert.ok(o);
    assert.equal(o.status, "named");
    assert.notEqual(o.status, "seated");
    assert.notEqual(o.ready, true);
  });

  it("keeps the public door and cycle marks that already exist", () => {
    const ids = ATLAS_NODES.map((n) => n.id);
    assert.deepEqual(
      ids.filter((id) => ["cycle", "threshold", "o", "raz"].includes(id)).sort(),
      ["cycle", "o", "raz", "threshold"],
    );
  });
});
