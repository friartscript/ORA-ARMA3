params [
    ["_unit", objNull, [objNull]],
    ["_isFemale", false, [false]],
    ["_isEnemy", false, [false]]
];

if (isNull _unit || !local _unit) exitWith {};

// Désactiver le randomizeur interne du mod Max Women pour éviter qu'il force des voix anglaises
_unit setVariable ["not_Random", true, true];

// Détection infaillible du sexe basée sur la classe 3D de l'unité
if ((toLower typeOf _unit) find "woman" != -1 || { (typeOf _unit) in (missionNamespace getVariable ["MISSION_CivilianClasses_Female", []]) }) then {
    _isFemale = true;
} else {
    _isFemale = false;
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
    // Ré-appliquer après tout délai d'initialisation de mod (0.01s)
    [_unit, _pch, _spk] spawn {
        params ["_u", "_p", "_s"];
        sleep 0.05;
        if (!isNull _u && alive _u) then {
            _u setPitch _p;
            _u setSpeaker _s;
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

_unit setName [_fullName, _firstName, _lastName];
_unit setNameSound _firstName;

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

if (_isFemale) then {
    _unit forceAddUniform (selectRandom MISSION_CivilianUniforms_Female);
} else {
    _unit forceAddUniform (selectRandom MISSION_CivilianUniforms_Male);
    
    // 100% de chapeaux pour les hommes
    _unit addHeadgear (selectRandom MISSION_CivilianHats);
    
    if (random 1 > 0.4) then {
        _unit addGoggles (selectRandom MISSION_CivilianBeards);
    };
    
    // Les vestes civiles (Jacket) sont ajoutées aléatoirement pour varier
    if (random 1 > 0.3) then {
        _unit addVest (selectRandom MISSION_CivilianVests);
    };
};

if (_isEnemy) then {
    _unit addBackpack (selectRandom MISSION_BanditBackpacks);

    private _weapon = selectRandom MISSION_BanditWeapons;
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
