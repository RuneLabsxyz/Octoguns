import { overridableComponent } from "@dojoengine/recs";
import { defineContractComponents } from "./typescript/models.gen";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
    contractComponents,
}: {
    contractComponents: Awaited<ReturnType<typeof defineContractComponents>>;
}) {
    return {
        ...contractComponents,
        Character: overridableComponent(contractComponents.Character),
        Map: overridableComponent(contractComponents.Map),
        MapObjects: overridableComponent(contractComponents.MapObjects),
        Session: overridableComponent(contractComponents.Session),
        SessionMeta: overridableComponent(contractComponents.SessionMeta),
        CharacterPosition: overridableComponent(contractComponents.CharacterPosition),
        Bullet: overridableComponent(contractComponents.Bullet),
        Global: overridableComponent(contractComponents.Global),
        Player: overridableComponent(contractComponents.Player)
    };
}
