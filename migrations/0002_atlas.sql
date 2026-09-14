-- Private atlas comments, scoped to the sealed identity.
create table if not exists atlas_comments (
  id         serial primary key,
  user_id    text not null,
  node_id    text not null,
  body       text not null,
  created_at timestamptz not null default now()
);
create index if not exists atlas_comments_user_node_idx
  on atlas_comments (user_id, node_id);
