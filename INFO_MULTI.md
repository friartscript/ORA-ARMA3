# INFO_MULTI.md — Guide de Conversion Multijoueur Coopératif Simple (1 à 6 Joueurs)

Ce document analyse et détaille la méthode la plus simple, fluide et immersive pour rendre la mission **OPERATION ROYAL ALLIANCE** jouable en coopération multijoueur (de 1 à 6 joueurs), **sans avoir à réécrire des centaines de variables**.

---

## 1. Philosophie : Le Multijoueur Asymétrique Léger

### 🔹 Pourquoi ce concept est le meilleur ?
Vouloir donner à chaque joueur l'accès à tous les menus (choix de météo, sélection des tâches, appel de drone, déclenchement de l'extraction) crée des conflits réseau majeurs, casse l'immersion militaire et alourdit considérablement le code.

À l'inverse, l'**Asymétrie Chef / Équipiers** reproduit la structure réelle d'une section de forces spéciales :
* **Le Chef d'Escouade (`player_0` / Leader) :**
  * Il agit exactement comme dans votre mode Solo actuel.
  * Il ouvre le **Panneau de Commandement Initial** (`Refour_Main_Menu_Dialog`) : choix de l'heure, de la météo, du véhicule, du vecteur d'insertion (Hélico / HALO), des tâches et de la menace insurgée.
  * Il détient le **Support Radio de Commandement** (0-8) : demande de drone MQ-9, hélicoptère CAS, livraison de munitions, véhicule de largage et appel de l'extraction.
  * Il gère les Règles d'Engagement (RoE) à la molette.
* **Les Équipiers Humains (`player_1` à `player_5`) :**
  * Ils n'ont pas à se soucier de la gestion lourde des menus.
  * Au lancement, pendant que le chef configure l'opération, ils voient un écran d'attente cinématique immersif : *"EN ATTENTE DES ORDRES DU CHEF D'ESCOUADE..."*.
  * Dès que le chef valide, ils sont déployés ensemble sur zone (à bord du véhicule ou au sol à la LZ).
  * Ils voient automatiquement les objectifs de mission sur leur carte et leur HUD 3D.
  * Leur rôle est tactique et immersif : progression, couverture de secteur, combat CQB, soins médicaux et soutien du chef.

---

## 2. Réponse Formelle : Faut-il rendre les unités jouables dans l'Éditeur ?

### 👉 **OUI, ABSOLUMENT ET OBLIGATOIREMENT !**

Dans le moteur Arma 3 :
* Une unité définie sur **"Joueur"** (`isPlayer = 1`) ne peut être incarnée que par l'hôte de la partie ou le joueur solo.
* Pour qu'un ami puisse rejoindre votre serveur et choisir un soldat dans l'écran de sélection des rôles, cette unité **DOIT** impérativement être configurée sur **"Jouable"** (`isPlayable = 1`).

### 🛠️ Comment faire dans l'Éditeur Eden (30 secondes chrono) :
1. Ouvrez la mission dans l'**Éditeur Eden** sur Takistan.
2. Repérez votre escouade de 6 opérateurs RACS :
   * `player_0` : **Laissez-le configuré sur "Joueur"** (Player - icône rouge). C'est votre chef d'escouade.
   * `player_1`, `player_2`, `player_3`, `player_4`, `player_5` :
     * Sélectionnez-les (ou double-cliquez sur chacun).
     * Dans le panneau d'attributs de l'unité, sous la catégorie **"Contrôle"**, cochez **"Jouable"** (Playable - icône violette).
3. Sauvegardez la mission (`Ctrl + S`).

> [!IMPORTANT]
> **Le secret de la flexibilité : `disabledAI = 0;`**  
> Votre fichier `description.ext` contient déjà la ligne `disabledAI = 0;`.  
> Cela signifie que **si vous jouez seul**, les 5 autres soldats restent des IA obéissantes.  
> **Si vous jouez à 2**, votre ami prend le slot de `player_1` et les 4 autres restent des IA.  
> **Si vous jouez à 6**, les 6 unités sont de vrais joueurs humains.  
> Vous n'avez jamais besoin de changer de mission selon le nombre d'amis connectés !

---

## 3. Pourquoi presque tout fonctionne déjà sans retaper les variables ?

Votre architecture de mission a été pensée dès le départ avec des bases très saines :

1. **Les Tâches (`fn_task*.sqf`) :**
   * Toutes les tâches principales et secondaires utilisent `BIS_fnc_taskCreate` avec soit `group player`, soit `true` (global).
   * Dans Arma 3, dès que des joueurs sont dans le même groupe, **les tâches et leurs marqueurs 3D sont automatiquement partagés avec tous les joueurs de l'escouade** !
2. **Le Décompte des Unités (`allPlayers`) :**
   * Les scripts de détection de distance (TaskA, extraction, zones de sécurité) utilisent déjà `allPlayers + switchableUnits + [player]`. Ils détectent donc naturellement n'importe quel joueur humain qui s'approche de l'objectif !
3. **L'Équipement et l'Identité :**
   * L'arsenal tactique au démarrage (`spawnStartArsenal`) et la boîte de munitions s'adaptent et sont utilisables par tous les joueurs.
   * La radio et les tenues camouflées sont appliquées à chaque unité présente.

---

## 4. Les Seules Adaptations Nécessaires (Légères et Rapides)

Pour éviter que tous les joueurs n'ouvrent le menu de démarrage en même temps, seules **deux modifications simples** sont requises :

### 1️⃣ Modification dans `init.sqf` (Ouverture du Menu réservée au Chef)
Dans `init.sqf`, nous remplaçons le lancement aveugle du menu pour faire la distinction :
* Le chef d'escouade (`player_0` ou le leader du groupe) ouvre le menu.
* Les autres joueurs reçoivent un écran d'attente avec un sous-titre élégant.

```sqf
[] spawn {
    titleCut ["", "BLACK FADED", 999];
    waitUntil { !isNull player && time > 0 };

    private _isSquadLeader = (player == (missionNamespace getVariable ["player_0", objNull])) || (player == leader (group player));

    if (_isSquadLeader) then {
        ["OPEN"] spawn LL_fnc_spawn_main_menu;
    } else {
        [
            "<t size='1.0' color='#00d5ff' font='PuristaMedium' align='center'>OPERATION ROYAL ALLIANCE</t><br/><t size='0.75' color='#bbbbbb' font='PuristaLight' align='center'>En attente des directives tactiques du chef d'escouade...</t>",
            -1, -1, 6, 1, 0, 794
        ] spawn BIS_fnc_dynamicText;

        waitUntil { sleep 1; missionNamespace getVariable ["MISSION_intro_finished", false] };
    };

    waitUntil { sleep 1; missionNamespace getVariable ["MISSION_intro_finished", false] };
    [] spawn LL_fnc_reloadWeapons;

    private _lastPlayer = objNull;
    while {true} do {
        waitUntil { sleep 1; player != _lastPlayer && { !isNull player } };
        _lastPlayer = player;
        
        _lastPlayer removeAllEventHandlers "HandleRating";
        _lastPlayer addEventHandler ["HandleRating", {
            params ["_unit", "_rating"];
            if (_rating < 0) then { 0 } else { _rating };
        }];
        if (rating _lastPlayer < 5000) then {
            _lastPlayer addRating (5000 - (rating _lastPlayer));
        };

        if (_isSquadLeader) then {
            [_lastPlayer] call LL_fnc_addRoeActions;
            [] call LL_fnc_initSupport;
        };

        [] call LL_fnc_initBriefing;
        [] call LL_fnc_initContext;
    };
};
```

### 2️⃣ Paramétrage Multijoueur dans `description.ext`
Ajouter en tête de `description.ext` les règles de lobby et de respawn :

```cpp
// --- CONFIGURATION MULTIJOUEUR COOP ---
briefingName = "COOP 06 - OPERATION ROYAL ALLIANCE";
onLoadName = "OPERATION ROYAL ALLIANCE";
disabledAI = 0;              // 0 = Les slots vides restent des IA au service du groupe
joinUnassigned = 0;          // Les joueurs sont directement assignés à leur slot
respawn = "GROUP";           // Si un joueur meurt, il prend le contrôle d'une IA restante du groupe !
respawnDelay = 5;
respawnDialog = 0;
enableDebugConsole = 1;      // Console disponible uniquement pour l'hôte de la partie
```

> [!TIP]
> **Pourquoi `respawn = "GROUP";` est génial ?**  
> Si vous jouez à 2 avec 4 IA dans l'escouade, et que votre ami se fait tuer, le jeu le transfère instantanément dans l'un des 4 soldats IA survivants de votre équipe ! Vous ne perdez aucun temps et la mission continue sans interruption.

---

## 5. Comment Lancer une Partie en Multijoueur (Pas-à-pas)

1. Dans le menu principal d'Arma 3 :
   * Cliquez sur **Multijoueur** > **Héberger une partie** (Serveur Internet avec mot de passe, ou LAN).
2. Choisissez la carte **Takistan** puis sélectionnez **OPERATION ROYAL ALLIANCE**.
3. Dans l'écran du lobby :
   * L'hôte prend le rôle **Chef d'escouade (`player_0`)**.
   * Vos amis choisissent les rôles **Fusilier / Opérateur (`player_1` à `player_5`)**.
4. Cliquez sur **Continuer** :
   * L'hôte voit apparaître le panneau tactique initial 3 panneaux (choix de la mission, météo, véhicule, insertion).
   * Vos amis ont leur écran d'attente élégant.
   * Dès que l'hôte clique sur **Lancer l'opération**, tout le monde est inséré en même temps sur zone !

---

## 6. Synthèse des Avantages de cette Solution

| Critère | Solution Proposée | Solution "Tout Réécrire en MP" |
| :--- | :--- | :--- |
| **Nombre de variables à refaire** | **0** | Des centaines |
| **Temps de mise en place** | **2 minutes** | Plusieurs semaines |
| **Risque de bugs réseau** | **Quasi nul** (Scripts locaux et chef maître) | Très élevé (désynchronisations) |
| **Immersion Militaire** | **Maximale** (Hiérarchie réelle Chef / Soldats) | Faible (cacophonie dans les menus) |
| **Rejouabilité Solo** | **Préservée à 100%** (`disabledAI = 0`) | Souvent cassée |
