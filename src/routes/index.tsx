import { createFileRoute } from "@tanstack/react-router";
import { AtlasShell } from "@/components/atlas-shell";
import { HouseGate } from "@/components/house-gate";

export const Route = createFileRoute("/")({ component: Home });

function Home() {
  return (
    <HouseGate>
      <AtlasShell />
    </HouseGate>
  );
}
