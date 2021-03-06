// ------ Base militaire baie de Pefkas -----
// Author : [LM]Cheitan
// Team   : La Muerta

//----------Initialisation de l'environnement----------
marker_pefkas1 = createMarker ["marker_pefkas1", [20944.5,19252.7,0]]; "marker_pefkas1" setMarkerType "Empty";
[WEST,["task_pefkas1_main"],["De longue date, la <marker name='marker_pefkas1'>base militaire de la baie de Pefkas</marker> est occupée par le KICC. Le commandement a décidé d'y mettre un terme, afin d'accroître notre contrôle sur la région. L'objectif est simple : réduire cette base au silence. Pour ce faire, réalisez tous les objectifs ci-dessous. Plus vous réaliserez d'objectifs, plus l'ennemi perdra pied et sera enclin à fuir ou se rendre.", "Opération Jackhammer", "marker_pefkas1"],objNull,true,1,true, "attack"] call BIS_fnc_taskCreate;
LM_MISSION_MAIN_TASK = "task_pefkas1_main";
LM_MISSION_POSITION = getMarkerPos "marker_pefkas1";

//Initialisation du tableau de suppression
_mission_object_array = [];
_mission_unit_array = [];

//Niveau de désespoir et fonction de reddition
surrender = 0;
_surrenderWave = {
	surrender = surrender + 0.25;
	{
		if(random 1 < surrender) then {
			_ennemy = _x findNearestEnemy _x;
			if(!isNull _ennemy && {(_x distance _ennemy < 100)}) then {[_x, true] call ace_captives_fnc_setSurrendered}
			else {_x allowFleeing 1};
		};
	} forEach ((LM_MISSION_POSITION nearEntities ["Man", 300]) select {side _x == east});
};


// Antiaérien
_emp = [
	[[20848.5,19243.5,0],298],
	[[20834.9,19193.2,0],245],
	[[20885.6,19172.2,0],200]
];
_arrayTigris = [];
{
	_tigris = [EAST, "KICC_TIGRIS", (_x select 0), (_x select 1)] call LM_fnc_createVehicle;
	_tigris forceSpeed 0;
	_arrayTigris pushBack _tigris;
} forEach _emp;
[WEST,["task_pefkas_aa","task_pefkas1_main"],["Détruisez les moyens antiaériens à l'ouest de la base.", "Batterie AA", ""],[20834.9,19193.2,0],false,1,false,"destroy"] call BIS_fnc_taskCreate;

// Artillerie
_emp = [
	[21047,19243.5,0],
	[21047.2,19224.5,0],
	[21047.1,19206.5,0]
];
_arraySochors = [];
{
	_sochor = "KICC_SOCHOR" createVehicle _x;
	_sochor setDir 90;
	_sochor lock true;
	_arraySochors pushBack _sochor;
} forEach _emp;
[WEST,["task_pefkas_lr","task_pefkas1_main"],["Détruisez la batterie d'artillerie à l'est de la base.", "Batterie 155mm", ""],[21047.2,19224.5,0],false,1,false,"destroy"] call BIS_fnc_taskCreate;

// Mortiers
_emp = [
	[[20906,19346.4,0],35],
	[[20912.9,19349.6,0],173],
	[[20922.2,19349.3,0],266]
];
{
	_sacs = "Land_BagFence_Round_F" createVehicle (_x select 0);
	_sacs setDir (_x select 1);
	_mortier = "O_Mortar_01_F" createVehicle (_sacs getRelPos [1, 0]);
	_mortier setDir ((_x select 1) + 180);
	_mission_object_array pushBack _sacs;
	_mission_object_array pushBack _mortier;
} forEach _emp;
[WEST,["task_pefkas_sr","task_pefkas1_main"],["Capturez la batterie de mortiers au nord de la base.", "Batterie 82mm", ""],[20912.9,19349.6,0],false,1,false,"interact"] call BIS_fnc_taskCreate;
_trigger = createTrigger ["EmptyDetector", [20912.9,19349.6,0], false];
_trigger setTriggerArea [5, 5, 0, false];
_trigger setTriggerActivation ["WEST", "PRESENT", false];
_trigger setTriggerStatements ["this", "['task_pefkas_sr', 'SUCCEEDED'] call BIS_fnc_taskSetState; [] spawn _surrenderWave", ""];

// Recherches
_filets = [[[20902.8,19231.3,0],0.000454269],[[20893.3,19236,0],344.28],[[20894.9,19236.8,0],327.749],[[20893.4,19237.8,0],65.6544]];
_bidons = [[[20895.6,19227.3,0.5],359.998],[[20895.7,19228.3,0.5],359.998],[[20894.9,19228.1,0.5],359.998],[[20901.7,19232.6,0.5],359.998]];
{
	_filet = createVehicle ["CargoNet_01_barrels_F", (_x select 0), [], 0, "CAN_COLLIDE"];
	_filet setDir (_x select 1);
	_mission_object_array pushBack _filet;
} forEach _filets;
{
	_bidon = createVehicle ["Land_MetalBarrel_F", (_x select 0), [], 0, "CAN_COLLIDE"];
	_bidon setPosATL (_x select 0);
	_bidon setDir (_x select 1);
	_mission_object_array pushBack _bidon;
} forEach _bidons;
_deco = [["Land_Notepad_F",[20893.7,19227.9,1.41428],359.978],["Land_CampingTable_small_F",[20893.8,19228.1,0.603271],243.484],["Land_FilePhotos_F",[20893.5,19228.3,1.41428],80.2825],["Land_OfficeChair_01_F",[20890.8,19225.1,0.60067],125.383],["OfficeTable_01_new_F",[20889.8,19224.8,0.600668],241.956],["Land_PenBlack_F",[20893.6,19228.1,1.41427],359.997],["Land_MapBoard_01_Wall_Altis_F",[20889.5,19224.6,1.823],241.967],["Land_MapBoard_F",[20890.2,19231,0.59845],290.08]];
{
	_deco = createVehicle [(_x select 0), (_x select 1), [], 0, "CAN_COLLIDE"];
	_deco enableSimulation false;
	_deco setDir (_x select 2);
	_mission_object_array pushBack _deco;
} forEach _deco;
[WEST,["task_pefkas_rs","task_pefkas1_main"],["Trouvez la formule du carburant amélioré expérimenté par le KICC sur Altis.", "Recherches", ""],[20894.9,19228.1,0.5],false,1,false,"search"] call BIS_fnc_taskCreate;
_objectif = createVehicle ["Land_File1_F",[20893.7,19228.1,1.41428], [], 0, "CAN_COLLIDE"];
_objectif enableSimulation false;
_objectif setPosATL [20893.7,19228.1,1.41428];
_objectif setDir 38;
_statement = {
	params ["_target", "_player", "_params"];
	deleteVehicle _target;
	["task_pefkas_rs", "SUCCEEDED"] call BIS_fnc_taskSetState;
};
[_objectif,0,["ACE_MainActions"],"pefkas_rs","Prendre les données","",_statement,{true}] call LM_fnc_createAceActionGlobal;

// Boucles des tâches AA et LR
[_arraySochors, _surrenderWave] spawn {
	waitUntil {
		sleep 5;
		{alive _x} count (_this select 0) == 0
	};
	["task_pefkas_lr", "SUCCEEDED"] call BIS_fnc_taskSetState;
	{LM_MISSION_TEMP pushBack _x} forEach (_this select 0);
	[] spawn (_this select 1);
};
[_arrayTigris, _surrenderWave] spawn {
	waitUntil {
		sleep 5;
		{alive _x} count (_this select 0) == 0
	};
	["task_pefkas_aa", "SUCCEEDED"] call BIS_fnc_taskSetState;
	{LM_MISSION_TEMP pushBack _x} forEach (_this select 0);
	[] spawn (_this select 1);
};


//----------Boucle principale----------
waitUntil {
	sleep 5;
	_fin = true;
	{
		_state = [_x] call BIS_fnc_taskState;
		if( !(_state in ["SUCCEEDED","CANCELED"]) ) exitWith { _fin = false }
	} forEach ("task_pefkas1_main" call BIS_fnc_taskChildren);
	_fin
};

//----------Suppression de l'environnement----------
{LM_MISSION_TEMP pushBack _x}forEach _mission_object_array;
{LM_MISSION_TEMP pushBack _x}forEach _mission_unit_array;
deleteMarker "marker_pefkas1";
deleteVehicle _trigger;
["task_pefkas1_main", "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
// ... end of mission's code, do not edit any of the lines bellow.