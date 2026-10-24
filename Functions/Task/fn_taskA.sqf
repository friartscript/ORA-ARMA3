/*
    LL_fnc_taskA
    Se rendre sur les lieux
*/
params [
    ["_locMarker", "", [""]],
    ["_optionalTasks", [], [[]]]
];

if (!isServer) exitWith {};

private _targetPos = getMarkerPos _locMarker;

[
    group player,
    ["task_mandatory_move"],
    [
        localize "STR_LL_Task_Man1_Desc",
        localize "STR_LL_Task_Man1_Title",
        localize "STR_LL_Task_Man1_Marker"
    ],
    _targetPos,
    "AUTOASSIGNED",
    10,
    true,
    "move",
    false
] call BIS_fnc_taskCreate;

// Attente de l'arrivée sur zone (500m)
waitUntil {
    sleep 2;
    ({ alive _x && (_x distance2D _targetPos) < 500 } count (allPlayers + switchableUnits + [player])) > 0
};

// Lancement de la fonction de sécurité linguistique OPFOR (se déclenche 2 minutes après)
[_targetPos] spawn LL_fnc_secureOpforLanguage;

// Validation de la tâche
["task_mandatory_move", "SUCCEEDED", true] call BIS_fnc_taskSetState;

// Lancement de la TaskB (Protection des civils)
[_locMarker, _optionalTasks] spawn LL_fnc_taskB;
