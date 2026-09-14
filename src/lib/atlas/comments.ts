import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { boundMiddleware } from "@/lib/bound-middleware";

export type AtlasComment = {
  id: number;
  nodeId: string;
  body: string;
  createdAt: string;
};

export const listComments = createServerFn({ method: "GET" })
  .middleware([boundMiddleware])
  .handler(async ({ context }) => {
    const { getSql } = await import("@/lib/db");
    const sql = await getSql();
    const rows = await sql<{
      id: number;
      node_id: string;
      body: string;
      created_at: string;
    }>`
      select id, node_id, body, created_at
      from atlas_comments
      where user_id = ${context.userId}
      order by created_at asc
    `;
    return rows.map(
      (row): AtlasComment => ({
        id: row.id,
        nodeId: row.node_id,
        body: row.body,
        createdAt: row.created_at,
      }),
    );
  });

export const addComment = createServerFn({ method: "POST" })
  .middleware([boundMiddleware])
  .validator(
    z.object({
      nodeId: z.string().min(1).max(64),
      body: z.string().trim().min(1).max(2000),
    }),
  )
  .handler(async ({ context, data }) => {
    const { getSql } = await import("@/lib/db");
    const sql = await getSql();
    const rows = await sql<{
      id: number;
      node_id: string;
      body: string;
      created_at: string;
    }>`
      insert into atlas_comments (user_id, node_id, body)
      values (${context.userId}, ${data.nodeId}, ${data.body})
      returning id, node_id, body, created_at
    `;
    const row = rows[0];
    if (!row) return null;
    return {
      id: row.id,
      nodeId: row.node_id,
      body: row.body,
      createdAt: row.created_at,
    } satisfies AtlasComment;
  });
