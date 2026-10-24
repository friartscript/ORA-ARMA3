if (!isServer) exitWith {};

params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "") then { _locMarker = "marker_0"; };

private _centerPos = getMarkerPos _locMarker;
private _radius = (markerSize _locMarker) select 0;
if (_radius == 0) then { _radius = 250; };
private _nearHelipads = nearestObjects [_centerPos, ["Land_HelipadEmpty_F"], _radius];
private _allLogics = allMissionObjects "Logic";
private _nearLogics = _allLogics select { _x distance2D _centerPos <= _radius };

private _usedPositions = missionNamespace getVariable ["LL_g_usedTaskPos", []];
private _validSpawnPoints = (_nearLogics + _nearHelipads) select {
    private _candidate = _x;
    !(_candidate getVariable ["LL_logic_occupied", false]) && 
    { (_usedPositions findIf { _x distance2D _candidate < 20 }) == -1 }
};

if (count _validSpawnPoints < 2) then {
    while { count _validSpawnPoints < 2 } do {
        private _dummyLogic = "Logic" createVehicleLocal (_centerPos getPos [100 + random 200, random 360]);
        _validSpawnPoints pushBack _dummyLogic;
    };
};

private _numRadios = (1 + floor (random 2)) min (count _validSpawnPoints);
private _shuffled = _validSpawnPoints call BIS_fnc_arrayShuffle;
private _selectedLogics = _shuffled select [0, _numRadios];

{
    _x setVariable ["LL_logic_occupied", true];
    private _p = getPosATL _x;
    if (_p isEqualTo [0,0,0]) then { _p = getPos _x; };
    _usedPositions pushBack _p;
} forEach _selectedLogics;
missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];

missionNamespace setVariable ["LL_TaskD_Trans_AllUnits", [], true];
missionNamespace setVariable ["LL_TaskD_Trans_Destroyed", 0, true];
missionNamespace setVariable ["LL_TaskD_Trans_Total", _numRadios, true];

[
    true,
    ["task_d_transmission"],
    [
        localize "STR_LL_Task_D_Transmission_Desc",
        localize "STR_LL_Task_D_Transmission_Title",
        localize "STR_LL_Task_D_Transmission_Marker"
    ],
    objNull,
    "AUTOASSIGNED",
    5,
    true,
    "destroy",
    false
] call BIS_fnc_taskCreate;

{ _x createDiaryRecord ["diary", [localize "STR_LL_Diary_TaskD_Transmission_Title", localize "STR_LL_Diary_TaskD_Transmission_Text"]]; } forEach (units group player);

for "_i" from 0 to (_numRadios - 1) do {
    private _logic = _selectedLogics select _i;
    private _spawnPos = getPosATL _logic;
    if (_spawnPos isEqualTo [0,0,0]) then { _spawnPos = getPos _logic; };
    _spawnPos set [2, (_spawnPos select 2) + 0.2];

    private _zoneGuards = [];
    
    // Spawn des patrouilles de gardes Takistanis
    private _numPatrols = 1 + floor (random 2);
    for "_p" from 1 to _numPatrols do {
        private _grp = createGroup [east, true];
        _grp setBehaviour "SAFE";
        _grp setCombatMode "RED";

        private _numGuards = 2 + floor (random 2);
        for "_g" from 1 to _numGuards do {
            private _guardPos = _spawnPos getPos [random 5, random 360];
            _guardPos set [2, (_spawnPos select 2)];
            private _isGuardFemale = (random 1) < 0.15;
            private _guardClass = if (_isGuardFemale) then {
                if (isClass (configFile >> "CfgVehicles" >> "Max_Tak_woman1")) then { selectRandom MISSION_CivilianClasses_Female } else { "O_G_Soldier_F" };
            } else {
                "O_G_Soldier_F"
            };
            private _guard = _grp createUnit [_guardClass, _guardPos, [], 0, "CAN_COLLIDE"];
            _guard setVariable ["not_Random", true, true];
            _guard setPosATL _guardPos;
            _guard allowDamage false;
            [_guard] spawn { sleep 3; (_this select 0) allowDamage true; };
            [_guard, _isGuardFemale, true] call LL_fnc_applyTakistaniIdentity;
            _zoneGuards pushBack _guard;
        };
        [_grp, _spawnPos, 40 + random 60] call BIS_fnc_taskPatrol;
    };

    private _allUnits = missionNamespace getVariable ["LL_TaskD_Trans_AllUnits", []];
    _allUnits append _zoneGuards;
    missionNamespace setVariable ["LL_TaskD_Trans_AllUnits", _allUnits, true];

    private _radioClass = "RuggedTerminal_01_communications_F";
    private _radio = createVehicle [_radioClass, _spawnPos, [], 0, "CAN_COLLIDE"];
    _radio setPosATL [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) - 0.2];
    _radio setDir (getDir _logic);
    _radio setVectorUp [0, 0, 1];

    _radio allowDamage false;
    [_radio] spawn { sleep 3; (_this select 0) allowDamage true; };

    private _taskChildId = format ["task_d_transmission_radio_%1", _i];
    [
        true,
        [_taskChildId, "task_d_transmission"],
        [
            localize "STR_LL_Task_D_Transmission_Sub_Desc",
            localize "STR_LL_Task_D_Transmission_Sub_Title",
            localize "STR_LL_Task_D_Transmission_Sub_Marker"
        ],
        [_radio, true],
        "AUTOASSIGNED",
        4,
        true,
        "destroy",
        false
    ] call BIS_fnc_taskCreate;

    _radio addAction [
        format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Task_D_Transmission_Action"],
        {
            params ["_target", "_caller", "_actionId", "_arguments"];
            _arguments params ["_radio", "_taskChildId"];
            
            if (_radio getVariable ["LL_TaskD_Trans_Triggered", false]) exitWith {};
            _radio setVariable ["LL_TaskD_Trans_Triggered", true, true];
            
            _target removeAction _actionId;
            _caller playActionNow "PutDown";
            
            private _pos = getPosATL _radio;
            private _charge = createVehicle ["DemoCharge_F", _pos, [], 0, "CAN_COLLIDE"];
            _charge attachTo [_radio, [0, 0, 0.2]];
            _charge setVectorUp [0, 0, 1];
            
            [_radio, _charge, _taskChildId] spawn {
                params ["_radio", "_charge", "_taskChildId"];
                
                sleep 40; 
                
                if (!isNull _charge) then { deleteVehicle _charge; };
                
                private _pos = getPosATL _radio;
                "Bo_GBU12_LGB" createVehicle _pos;
                
                if (!isNull _radio) then { deleteVehicle _radio; };
                
                [_taskChildId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                
                private _destroyed = (missionNamespace getVariable ["LL_TaskD_Trans_Destroyed", 0]) + 1;
                missionNamespace setVariable ["LL_TaskD_Trans_Destroyed", _destroyed, true];
                private _total = missionNamespace getVariable ["LL_TaskD_Trans_Total", 1];
                
                if (_destroyed >= _total) then {
                    ["task_d_transmission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
                    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
                    
                    private _allUnits = missionNamespace getVariable ["LL_TaskD_Trans_AllUnits", []];
                    private _guards = _allUnits select { alive _x };
                    if (count _guards > 0) then {
                        [_guards] spawn LL_fnc_taskCleanup;
                    };
                };
            };
        },
        [_radio, _taskChildId],
        10, true, true, "", "_this distance _target < 4", 4
    ];
};
