params [
    ["_unit", objNull, [objNull]],
    ["_isFemale", false, [false]],
    ["_isEnemy", false, [false]]
];

if (isNull _unit || !local _unit) exitWith {};

// Désactiver le randomizeur interne du mod Max Women pour éviter qu'il force des voix anglaises
_unit setVariable ["not_Random", true, true];

// Détection infaillible du sexe : si passé en paramètre ou détecté dans la classe 3D
if (_isFemale || { (toLower typeOf _unit) find "woman" != -1 } || { (typeOf _unit) in (missionNamespace getVariable ["MISSION_CivilianClasses_Female", []]) }) then {
    _isFemale = true;
};

private _fullName = "";
private _firstName = "";
private _lastName = "";

if (_isFemale) then {
    private _fNames = missionNamespace getVariable ["MISSION_CivilianNames_Female", []];
    private _nameArr = if (count _fNames > 0) then { selectRandom _fNames } else { ["Fatima Zahra", "Fatima", "Zahra"] };
    _fullName = _nameArr select 0;
    _firstName = _nameArr select 1;
    _lastName = _nameArr select 2;
    private _spk = selectRandom ["Male01PER", "Male02PER", "Male03PER"];
    private _pch = 1.35 + (random 0.07);
    _unit setSpeaker _spk;
    _unit setPitch _pch;
    // Ré-appliquer après tout délai d'initialisation de mod (0.05s) avec broadcast global réseau
    [_unit, _pch, _spk, _fullName, _firstName, _lastName] spawn {
        params ["_u", "_p", "_s", "_fn", "_f", "_l"];
        sleep 0.05;
        if (!isNull _u && alive _u) then {
            _u setPitch _p;
            _u setSpeaker _s;
            _u setName [_fn, _f, _l];
            [_u, [_fn, _f, _l]] remoteExecCall ["setName", 0, _u];
            [_u, _p] remoteExecCall ["setPitch", 0, _u];
            [_u, _s] remoteExecCall ["setSpeaker", 0, _u];
        };
    };
} else {
    private _mNames = missionNamespace getVariable ["MISSION_CivilianNames_Male", []];
    private _nameArr = if (count _mNames > 0) then { selectRandom _mNames } else { ["Ahmad Shah", "Ahmad", "Shah"] };
    _fullName = _nameArr select 0;
    _firstName = _nameArr select 1;
    _lastName = _nameArr select 2;
    _unit setFace (selectRandom (missionNamespace getVariable ["MISSION_CivilianMaleFaces", ["PersianHead_A3_01"]]));
    _unit setSpeaker (selectRandom ["Male01PER", "Male02PER", "Male03PER"]);
    _unit setPitch 1.0;
};

// Application du nom en local et synchronisation globale (JIP inclus) pour tous les joueurs en ligne
_unit setName [_fullName, _firstName, _lastName];
_unit setNameSound _firstName;
[_unit, [_fullName, _firstName, _lastName]] remoteExecCall ["setName", 0, _unit];
_unit setVariable ["LL_unitName", _fullName, true];
_unit setVariable ["LL_isFemale", _isFemale, true];

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

if (_isFemale) then {
    _unit forceAddUniform (selectRandom (missionNamespace getVariable ["MISSION_CivilianUniforms_Female", ["Burqa1"]]));
} else {
    _unit forceAddUniform (selectRandom (missionNamespace getVariable ["MISSION_CivilianUniforms_Male", ["CUP_O_TKI_Khet_Partug_01"]]));
    
    // 100% de chapeaux pour les hommes
    _unit addHeadgear (selectRandom (missionNamespace getVariable ["MISSION_CivilianHats", ["CUP_H_TKI_Pakol_1_01"]]));
    
    if (random 1 > 0.4) then {
        _unit addGoggles (selectRandom (missionNamespace getVariable ["MISSION_CivilianBeards", ["CUP_Beard_Black"]]));
    };
    
    // Les vestes civiles (Jacket) sont ajoutées aléatoirement pour varier
    if (random 1 > 0.3) then {
        _unit addVest (selectRandom (missionNamespace getVariable ["MISSION_CivilianVests", ["CUP_V_OI_TKI_Jacket1_01"]]));
    };
};

if (_isEnemy) then {
    _unit setVariable ["LL_isEnemy", true, true];

    // Rattachement ferme au groupe OPFOR si nécessaire
    if (side group _unit != east) then {
        private _grpEast = createGroup [east, true];
        [_unit] joinSilent _grpEast;
    };

    // Protection anti-Renegade : si le moteur pénalise le tueur pour avoir éliminé un modèle issu de classe civile,
    // ce Killed EH restaure instantanément le rating du tueur pour empêcher le déclassement et la mutinerie de l'escouade
    _unit addEventHandler ["Killed", {
        params ["_unit", "_killer", "_instigator"];
        if (isNull _instigator) then { _instigator = _killer; };
        if (!isNull _instigator && { rating _instigator < 2000 }) then {
            _instigator addRating (3000 - (rating _instigator));
        };
    }];

    _unit addBackpack (selectRandom (missionNamespace getVariable ["MISSION_BanditBackpacks", ["B_FieldPack_khk"]]));

    private _weapons = missionNamespace getVariable ["MISSION_BanditWeapons", ["arifle_AKM_F"]];
    private _weapon = selectRandom _weapons;
    _unit addWeapon _weapon;
    
    _unit addPrimaryWeaponItem (selectRandom ["CUP_acc_Flashlight","CUP_acc_Zenit_2DS"]);
    _unit addHandgunItem (selectRandom ["CUP_acc_CZ_M3X","acc_Flashlight_pistol"]);
    
    private _magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
    if (count _magazines > 0) then {
        private _mag = _magazines select 0;
        _unit addMagazine _mag;
        _unit addMagazine _mag;
        _unit addMagazine _mag;
        _unit addMagazine _mag;
    };
    
    if (!_isFemale) then {
        for "_i" from 1 to 2 do { _unit addItem "FirstAidKit"; };
        _unit addItem "SmokeShell";
        _unit linkItem "ItemMap";
        _unit linkItem "ItemCompass";
        _unit linkItem "ItemWatch";
        _unit linkItem "ItemRadio";
    } else {
        _unit addItem "FirstAidKit";
        _unit linkItem "ItemRadio";
    };
};
