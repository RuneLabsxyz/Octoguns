
export type Action = {
    action_type: number,
    step: number
}

export type Vec = {
    x: number,
    y: number
}

export type CharacterMove = {
    characters: number[],
    moves: Vec[],
    actions: Action[]
}