/*
    LL_fnc_secureOpforLanguage
    Fonction de sécurité linguistique pour les forces OPFOR
    Se déclenche 2 minutes après le franchissement des 500m de la zone de mission.
    Assigne de force un speaker perse (Male01PER, Male02PER, Male03PER) à toutes les unités OPFOR
    tout en préservant strictement leur pitch audio et leurs autres attributs.
*/
params [
    ["_targetPos", [0,0,0], [[]]]
];

if (!isServer) exitWith {};

// Délai de sécurité de 2 minutes après le franchissement des 500m
sleep 120;

private _fn_enforcePersian = {
    private _opforUnits = allUnits select {
        alive _x && { side group _x == east || _x getVariable ["LL_isEnemy", false] || side _x == east }
    };

    private _persianSpeakers = ["Male01PER", "Male02PER", "Male03PER"];

    {
        private _unit = _x;
        private _curSpeaker = speaker _unit;

        if !(_curSpeaker in _persianSpeakers) then {
            private _newSpeaker = selectRandom _persianSpeakers;
            _unit setSpeaker _newSpeaker;
            [_unit, _newSpeaker] remoteExecCall ["setSpeaker", 0, _unit];
        };
    } forEach _opforUnits;
};

// Première passe immédiate après les 2 minutes
[] call _fn_enforcePersian;

// Surveillance continue en arrière-plan jusqu'à l'extraction (toutes les 30s)
while { !(missionNamespace getVariable ["LL_g_extractionStarted", false]) } do {
    sleep 30;
    [] call _fn_enforcePersian;
};
