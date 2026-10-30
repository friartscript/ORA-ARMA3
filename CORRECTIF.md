# 📋 RAPPORT D'ANALYSE TECHNIQUE ET PLAN DE CORRECTIFS

Ce document détaille l'analyse exhaustive, les causes racines identifiées et les solutions pas à pas pour corriger les derniers bugs, incohérences linguistiques, optimisation des fichiers et retours joueurs sur la mission **OPERATION ROYAL ALLIANCE (Takistan)**.

---

## 1. 🔍 DIAGNOSTIC TECHNIQUE DES BUGS ET INCOHÉRENCES

### 1.1. Bug à l'appel à la prière : Erreur furtive `titles... ezan`
- **Fichier en cause :** `CfgSounds.hpp` (lignes 401-405) & `Functions/Environment/fn_playEzan.sqf`.
- **Symptôme :** Dès que l'appel à la prière démarre dans les minarets, un message d'erreur furtif apparaît à l'écran puis disparaît.
- **Cause racine :**
  Dans `CfgSounds.hpp` :
  ```cpp
  class ezan
  {
      name = "ezan";
      sound[] = {"Music\ezan.ogg", db+12, 1.0, 2000};
  };
  ```
  Le paramètre obligatoire `titles[] = {0, ""};` est **manquant**.
  Dans le moteur d'Arma 3, tout son joué avec la commande `say3D` ou `say` exige impérativement la propriété `titles[]` pour gérer les sous-titres associés. Si cette propriété est omise, le moteur lève une exception visuelle : `"Sound ezan: titles[] missing"`.
- **Correctif :** Ajouter `titles[] = {0, ""};` dans la classe `ezan`.

---

### 1.2. Bug furtif à la prise des documents (`fn_taskD_documents.sqf`)
- **Fichier en cause :** `Functions/Task/fn_taskD_documents.sqf` (lignes 138, 156, 158, 165, 199-211).
- **Symptômes :** Dès que le joueur termine l'action hold ("Fouiller le corps (Documents)"), un message d'erreur rouge/orange clignote une fraction de seconde au centre supérieur de l'écran.
- **Causes racines identifiées :**
  1. **Classe d'inventaire inexistante (Cause directe du flash d'erreur) :**
     À la ligne 156 :
     ```sqf
     if (_caller canAdd "Item_Document_01_F") then { _caller addItem "Item_Document_01_F"; };
     ```
     La classe `"Item_Document_01_F"` **n'existe pas** dans les configurations d'Arma 3 vanilla ou CUP (`CfgWeapons` / `CfgMagazines`). Le modèle 3D présent dans l'éditeur s'appelle `"Land_Document_01_F"` (qui est un objet du monde `CfgVehicles`, impossible à placer dans un sac ou un uniforme). Lorsque `canAdd` ou `addItem` teste cette classe inconnue, le moteur d'Arma 3 déclenche immédiatement :
     ```
     No entry 'bin/config.bin/CfgWeapons.Item_Document_01_F'
     ```
     Ce message apparaît brièvement sous forme de notification d'erreur. Dans les missions Arma 3, la complétion de la tâche ne nécessite pas d'objet d'inventaire (l'action Hold valide directement la tâche via `BIS_fnc_taskSetState`).
  2. **Double suppression de l'Action Hold :**
     À la ligne 158 :
     ```sqf
     [_target, _actionId] call BIS_fnc_holdActionRemove;
     ```
     Alors que le 14ème paramètre de `BIS_fnc_holdActionAdd` (ligne 165) est déjà fixé à `true` (`_removeCompleted = true`). Le script tente donc de supprimer manuellement un identifiant d'action que le framework `BIS_fnc_holdActionAdd` est déjà en train de supprimer automatiquement, provoquant un avertissement de script.
  3. **Titre de l'action en français codé en dur :**
     À la ligne 138 :
     ```sqf
     private _actionTitle = format ["<t color='#FFFF00'>%1</t>", "Fouiller le corps (Documents)"];
     ```
     Ce titre est en français en dur et ne respecte pas le paramétrage linguistique en anglais.
  4. **Clés de localisation manquantes dans `stringtable.xml` :**
     Les clés `STR_LL_Task_01_Desc`, `STR_LL_Task_01_Title`, `STR_LL_Task_01_Marker`, `STR_LL_Diary_Task01_Title`, `STR_LL_Diary_Task01_Text` appelées par `fn_taskD_documents.sqf` n'étaient même pas déclarées dans `stringtable.xml`.
- **Correctif :**
  - Supprimer la tentative d'ajout de `"Item_Document_01_F"`.
  - Supprimer l'appel superflu à `BIS_fnc_holdActionRemove`.
  - Créer `Functions/Task/fn_taskD_documents.xml` contenant toutes les clés traduites dans toutes les langues supportées.
  - Lier l'intitulé de l'action à `localize "STR_LL_Task_01_Action"`.

---

### 1.3. Traces de français codées en dur (Sous-titres, Émetteurs, Chat, Voix)
- **Capture d'écran fournie par l'utilisateur :**
  ```
  APPUI AERIEN:
  Close Air Support approved. Helicopter en route.
  ```
  Alors que le jeu et le message sont en anglais, l'émetteur est affiché en français : `APPUI AERIEN:` !
- **Causes racines identifiées :**
  1. **Émetteurs radio en dur dans `Functions/UI/fn_radioMessage.sqf` (lignes 30-40) :**
     ```sqf
     if (_speaker isEqualTo "") then {
         if (_stringKey find "STR_Drone_" == 0) then {
             _speaker = "Opérateur Drone";
         } else {
             if (_stringKey find "STR_LL_Heli_" == 0) then {
                 _speaker = "Appui Aérien";
             } else {
                 _speaker = "QG";
             };
         };
     };
     ```
     `BIS_fnc_showSubtitle` passe l'émetteur en majuscules. Comme `"Appui Aérien"` est codé en dur, il devient `APPUI AERIEN:`.
     De plus, la ligne 19 contient un texte de fallback en français : `"Brouillage radio détecté. Impossible de contacter le drone."`.
  2. **Messages système en français dans `Functions/Task/fn_spawnStartArsenal.sqf` (lignes 38, 42) :**
     ```sqf
     systemChat "Le commandement interdit la modification de l'uniforme réglementaire.";
     systemChat "Le couvre-chef standard de la Légion doit être conservé.";
     ```
  3. **ETA d'avion cargo en français dans `Functions/Task/fn_taskD_tigris.sqf` (ligne 308) :**
     ```sqf
     private _etaText = format ["(Survol cargo ETA %1 min)", _min];
     ```
  4. **Attribution de profils vocaux français aux IA dans `Functions/Team/fn_identityManager.sqf` (lignes 132-143) :**
     ```sqf
     case "White": { _selectedSpeaker = "Male01FRE"; };
     case "Black": { _selectedSpeaker = "Male02FRE"; };
     default { _selectedSpeaker = "Male03FRE"; };
     ```
     Les IA alliées de l'escouade utilisent des profils vocaux français natifs d'Arma 3 (`FRE`), les faisant crier en français lors des contacts et des ordres radio du moteur de jeu.
  5. **Description de mission dans `description.ext` (ligne 7) :**
     `overviewText` est rédigé en français au lieu d'utiliser une clé localisée `$STR_LL_OverviewText`.
  6. **Balises `<Original>` rédigées en français dans `stringtable.xml` :**
     Plusieurs dizaines de clés possédaient une balise `<Original>` en français au lieu de l'anglais, en contradiction avec la règle n°1 de `INFO_STRINTABLE.md`.

---

### 1.4. Incompréhension des joueurs sur l'extraction (Retours Steam Workshop)
- **Constat sur le Workshop Steam :**
  Un joueur demande : *« No exfil if one of the team dies ? »*
  Certains joueurs s'attendent à ce que l'hélicoptère d'extraction arrive automatiquement une fois tous les objectifs accomplis, ou pensent que la mission est bloquée / buggée si l'un de leurs coéquipiers est tombé au combat.
- **Cause :**
  Bien que les directives jaunes du menu mentionnent l'appel radio 0-8-3, cette information est noyée au milieu du paragraphe des règles d'engagement. Elle n'est pas assez visible ni percutante pour les joueurs qui survolent le menu rapidement.
- **Solution demandée :**
  Ajouter un message d'avertissement **en rouge vif (`#FF2222`)**, très visible et stylisé avec icône d'alerte, traduit dans **l'ensemble des langues du jeu**, stipulant explicitement que :
  > **L'extraction de la zone est strictement MANUELLE (via le menu Radio Support 0-8-3) et ne se déclenchera JAMAIS automatiquement ! Le joueur est libre de l'appeler à tout moment.**

---

### 1.5. Fichiers musicaux non utilisés et superflus dans `Music\` et `description.ext`
- **Dossier concerné :** `c:\Users\kevin\Documents\Arma 3\missions\ORA.Takistan\Music\`
- **Constat d'audit :**
  Actuellement, la mission embarque plusieurs morceaux audio dans son dossier `Music\` et les déclare dans `CfgMusic` / `CfgSounds`. Cependant, l'analyse exhaustive des scripts de la mission montre que seuls **3 fichiers** sont réellement exploités :
  1. `ezan.ogg` : Appel à la prière via les minarets dans `fn_playEzan.sqf`.
  2. `Rubab_01.ogg` : Musique des cinématiques d'introduction dans `fn_intro_01.sqf` et `fn_intro_02.sqf`.
  3. `Rubab_02.ogg` : Musique de la cinématique d'extraction finale dans `fn_extraction.sqf`.

- **Fichiers totalement inutilisés (poids mort) :**
  - `Shadow_of_the_Valley_01.ogg` (ancien thème d'intro, remplacé par Rubab)
  - `Shadow_of_the_Valley_02.ogg` (jamais appelé par aucun script)
  - `Shadow_of_the_Valley_03.ogg` (jamais appelé par aucun script)
  - `legion_01.ogg` (chant de marche français non utilisé, hors contexte linguistique)
  - `Rubab_Full.ogg` (version longue de 5 min non découpée, les scripts utilisent `Rubab_01` et `Rubab_02`)

- **Bénéfices de la suppression :**
  - **Allègement significatif du fichier de mission (`.pbo`) :** Réduction de plusieurs dizaines de mégaoctets, accélérant le téléchargement Steam Workshop et le temps de chargement des joueurs.
  - **Purge des configurations :** Nettoyage des classes orphelines dans `description.ext` (`CfgMusic`) et `CfgSounds.hpp`.
  - **Suppression définitive des traces audio françaises :** Élimination de `legion_01.ogg`.

---

### 1.6. Erreur à l'extraction : `Sound Sound_Music_Intro not found`
- **Fichier en cause :** `Functions/Helicopter/fn_heliManager.sqf` (lignes 550 & 552).
- **Symptôme :** Lors de la montée à bord de l'hélicoptère d'extraction, une fenêtre d'erreur orange/noire s'affiche : `"Sound Sound_Music_Intro not found"`.
- **Cause racine :**
  Le script tentait de jouer un son ou une musique nommée `"Sound_Music_Intro"` ou `"Music_Intro"` qui avait été nettoyée / renommée lors de la standardisation des musiques.
- **Solution appliquée :**
  Remplacement de la référence sonore par `"Music_Rubab_02"` / `"Sound_Rubab_02"` qui correspond au thème oriental de fin de mission disponible dans `Music\Rubab_02.ogg`.

---

### 1.7. Erreurs de textures de carte au menu principal : `something_ca.paa`, `ruins_ca.paa` et `tourist_ca.paa`
- **Fichier en cause :** `Dialogs/main_menu.hpp` (lignes 560, 569, 578, 596, 614 et 623).
- **Symptôme :** À l'ouverture du menu tactique ou lors de la sélection d'un secteur contenant des ruines (ex: Secteur 8 Feruz Abad), de la végétation ou un point d'intérêt touristique (ex: Secteur 10 Grid 067-088), des messages d'erreur de textures manquantes apparaissaient :
  - `Cannot load texture a3\ui_f\data\map\mapcontrol\something_ca.paa.`
  - `Cannot load texture a3\ui_f\data\map\mapcontrol\ruins_ca.paa.`
  - `Cannot load texture a3\ui_f\data\map\mapcontrol\tourist_ca.paa.`
- **Causes racines :**
  1. `something_ca.paa` était un placeholder fictif utilisé dans les classes `SmallTree` et `Tree`.
  2. `ruins_ca.paa` contenait une faute d'orthographe (un 's' en trop) : dans les bibliothèques UI vanilla d'Arma 3, la texture s'appelle `ruin_ca.paa` au singulier.
  3. `tourist_ca.paa` contenait une coquille : dans les bibliothèques UI vanilla d'Arma 3, la texture s'appelle `tourism_ca.paa` (avec un 'm', non un 't').
- **Solution appliquée :**
  - Remplacement de `something_ca.paa` par `\A3\ui_f\data\map\mapcontrol\bush_ca.paa` dans `SmallTree` et `Tree`.
  - Remplacement de `ruins_ca.paa` par `\A3\ui_f\data\map\mapcontrol\ruin_ca.paa` dans `Ruin` et `Ruins`.
  - Remplacement de `tourist_ca.paa` par `\A3\ui_f\data\map\mapcontrol\tourism_ca.paa` dans `Tourism` et `Tourist`.

---

## 2. 🛠️ PLAN DE MODIFICATIONS PAS À PAS

### Étape 1 : Corriger `CfgSounds.hpp` (Bug Ezan)
Insérer `titles[] = {0, ""};` dans la classe `ezan` :
```cpp
    class ezan
    {
        name = "ezan";
        sound[] = {"Music\ezan.ogg", db+12, 1.0, 2000};
        titles[] = {0, ""};
    };
```

---

### Étape 2 : Nettoyer `Functions/Task/fn_taskD_documents.sqf` (Bug Documents)
1. Remplacer le titre en dur par `localize "STR_LL_Task_01_Action"` :
   ```sqf
   private _actionTitle = format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Task_01_Action"];
   ```
2. Supprimer la ligne `_caller addItem "Item_Document_01_F";` et la ligne `[_target, _actionId] call BIS_fnc_holdActionRemove;`.
   Le bloc de complétion devient :
   ```sqf
   {
       params ["_target", "_caller", "_actionId", "_arguments"];
       _arguments params ["_unit"];
       
       if (missionNamespace getVariable ["LL_TaskD_Doc_Triggered", false]) exitWith {};
       missionNamespace setVariable ["LL_TaskD_Doc_Triggered", true];
       
       [_unit] call (missionNamespace getVariable "LL_fnc_taskD_docComplete");
   },
   ```

---

### Étape 3 : Créer `Functions/Task/fn_taskD_documents.xml`
Créer le fichier XML contenant toutes les clés pour les documents selon la norme `INFO_STRINTABLE.md` (Original et English en anglais, traductions complètes) :
- `STR_LL_Task_01_Action` : "Search body (Documents)" / "Fouiller le corps (Documents)"
- `STR_LL_Task_01_Title` : "Recover Documents" / "Récupérer des documents"
- `STR_LL_Task_01_Desc` : "Infiltrate the zone, eliminate the insurgent officer and recover the sensitive documents found on his body." / "Infiltrez la zone, éliminez l'officier insurgé et récupérez les documents sensibles sur son corps."
- `STR_LL_Task_01_Marker` : "Officer (Documents)" / "Officier (Documents)"
- `STR_LL_Diary_Task01_Title` : "Intel: Classified Documents" / "Renseignement : Documents Secrets"
- `STR_LL_Diary_Task01_Text` : "An insurgent officer in the sector holds critical tactical intelligence. Neutralize him and search his remains to secure the documents."

---

### Étape 4 : Localiser les Émetteurs dans `Functions/UI/fn_radioMessage.sqf`
Modifier la détection automatique de l'émetteur pour utiliser `localize` :
```sqf
// Détection automatique de l'émetteur si non fourni
if (_speaker isEqualTo "") then {
    if (_stringKey find "STR_Drone_" == 0) then {
        _speaker = localize "STR_LL_Radio_Speaker_Drone";
    } else {
        if (_stringKey find "STR_LL_Heli_" == 0 || _stringKey find "STR_TAG_Msg_" == 0) then {
            _speaker = localize "STR_LL_Radio_Speaker_AirSupport";
        } else {
            _speaker = localize "STR_LL_Radio_Speaker_HQ";
        };
    };
};
```
Et créer `Functions/UI/fn_radioMessage.xml` avec les clés :
- `STR_LL_Radio_Speaker_Drone` : "Drone Operator" / "Opérateur Drone"
- `STR_LL_Radio_Speaker_AirSupport` : "Air Support" / "Appui Aérien"
- `STR_LL_Radio_Speaker_HQ` : "HQ" / "QG"
- `STR_Drone_Jammed` : "Radio jamming detected. Unable to reach drone." / "Brouillage radio détecté. Impossible de contacter le drone."

---

### Étape 5 : Localiser l'Arsenal et le Tigris
1. Dans `Functions/Task/fn_spawnStartArsenal.sqf` :
   Remplacer les `systemChat` en dur par des clés :
   - `systemChat (localize "STR_LL_Arsenal_UniformForbidden");`
   - `systemChat (localize "STR_LL_Arsenal_HeadgearForbidden");`
   Créer `Functions/Task/fn_spawnStartArsenal.xml` pour définir ces messages dans toutes les langues.
2. Dans `Functions/Task/fn_taskD_tigris.sqf` (ligne 308) :
   Remplacer :
   ```sqf
   private _etaText = format [localize "STR_LL_Task_08_Flyover_ETA", _min];
   ```
   Et ajouter `STR_LL_Task_08_Flyover_ETA` ("(Cargo flyover ETA %1 min)" / "(Survol cargo ETA %1 min)").

---

### Étape 6 : Voix des Coéquipiers IA dans `Functions/Team/fn_identityManager.sqf`
Remplacer les profils vocaux français par les profils anglophones d'Arma 3 :
```sqf
private _selectedSpeaker = "";
switch (_faceType) do {
    case "White": { 
        _selectedSpeaker = selectRandom ["Male01ENG", "Male02ENG", "Male03ENG", "Male04ENG", "Male05ENG"]; 
    };
    case "Black": { 
        _selectedSpeaker = selectRandom ["Male01ENGB", "Male02ENGB", "Male03ENGB"]; 
    };
    default { 
        _selectedSpeaker = selectRandom ["Male01ENG", "Male02ENG", "Male03ENG"]; 
    };
};
```
Ainsi, les équipiers répondront et crieront en anglais pendant toute l'opération lorsque le jeu est en anglais.

---

### Étape 7 : Message d'Alerte Rouge pour l'Extraction Manuelle sur le Menu Principal
Pour garantir qu'aucun joueur ne manque cette information capitale, le message est affiché en **rouge vif (`#FF2222`) avec une typographie grasse (`PuristaBold`)** dans le panneau gauche du menu principal (`Refour_Main_Menu_Dialog` dans `Dialogs/main_menu.hpp`), directement sous les cases à cocher et au-dessus des directives.

#### A. Structure du Contrôle dans `Dialogs/main_menu.hpp` :
Le bloc `Txt_Rules` (ou un nouveau contrôle dédié `Txt_ExtractionAlert`) est configuré pour afficher en tête la clé `$STR_MAIN_MENU_EXTRACTION_ALERT` :

```cpp
        class Txt_ExtractionAlert: RscStructuredText {
            idc = 7130;
            text = "$STR_MAIN_MENU_EXTRACTION_ALERT";
            x = safezoneX + (0.025 * safezoneW);
            y = safezoneY + (0.49 * safezoneH);
            w = 0.29 * safezoneW;
            h = 0.08 * safezoneH;
            colorBackground[] = {0.3, 0.05, 0.05, 0.7}; // Encadrement rouge sombre d'alerte
        };

        class Txt_Rules: RscStructuredText {
            idc = -1;
            text = "$STR_MAIN_MENU_RULES";
            x = safezoneX + (0.025 * safezoneW);
            y = safezoneY + (0.58 * safezoneH);
            w = 0.29 * safezoneW;
            h = 0.20 * safezoneH;
            colorBackground[] = {0,0,0,0};
        };
```

#### B. Traductions complètes de `STR_MAIN_MENU_EXTRACTION_ALERT` dans les 14 langues :
```xml
<Key ID="STR_MAIN_MENU_EXTRACTION_ALERT">
    <Original>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ EXTRACTION NOTICE:&lt;br/&gt;Extraction is strictly MANUAL via radio Support (0-8-3), NEVER automatic! You can call it at any time.&lt;/t&gt;</Original>
    <English>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ EXTRACTION NOTICE:&lt;br/&gt;Extraction is strictly MANUAL via radio Support (0-8-3), NEVER automatic! You can call it at any time.&lt;/t&gt;</English>
    <French>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ AVIS D'EXTRACTION :&lt;br/&gt;L'extraction est strictement MANUELLE via le menu Support (0-8-3), JAMAIS automatique ! Vous pouvez l'appeler à tout moment.&lt;/t&gt;</French>
    <Spanish>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ AVISO DE EXTRACCIÓN:&lt;br/&gt;¡La extracción es estrictamente MANUAL a través del menú Soporte (0-8-3), NUNCA automática! Puede solicitarla en cualquier momento.&lt;/t&gt;</Spanish>
    <German>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ EVAKUIERUNGSHINWEIS:&lt;br/&gt;Die Evakuierung erfolgt ausschließlich MANUELL über das Funkmenü Support (0-8-3), NIEMALS automatisch! Sie kann jederzeit angefordert werden.&lt;/t&gt;</German>
    <Italian>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ AVVISO DI ESTRAZIONE:&lt;br/&gt;L'estrazione è rigorosamente MANUALE tramite la radio Supporto (0-8-3), MAI automatica! Puoi richiederla in qualsiasi momento.&lt;/t&gt;</Italian>
    <Polish>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ UWAGA DOTYCZĄCA EWAKUACJI:&lt;br/&gt;Ewakuacja jest wyłącznie RĘCZNA przez menu Wsparcia (0-8-3), NIGDY automatyczna! Możesz ją wezwać w dowolnym momencie.&lt;/t&gt;</Polish>
    <Portuguese>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ AVISO DE EXTRAÇÃO:&lt;br/&gt;A extração é estritamente MANUAL através do menu Suporte (0-8-3), NUNCA automática! Pode solicitá-la a qualquer momento.&lt;/t&gt;</Portuguese>
    <Russian>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ ВАЖНОЕ ПРЕДУПРЕЖДЕНИЕ:&lt;br/&gt;Эвакуация вызывается исключительно ВРУЧНУЮ через меню Поддержки (0-8-3), а НЕ автоматически! Вы можете запросить её в любой момент.&lt;/t&gt;</Russian>
    <Czech>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ UPOZORNĚNÍ K EVAKUACI:&lt;br/&gt;Evakuace je striktně MANUÁLNÍ přes menu Podpory (0-8-3), NIKDY automatická! Můžete ji povolat kdykoliv.&lt;/t&gt;</Czech>
    <Turkish>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ TAHLİYE UYARISI:&lt;br/&gt;Tahliye kesinlikle Destek menüsünden (0-8-3) MANUEL olarak çağrılır, ASLA otomatik gerçekleşmez! İstediğiniz an tahliye çağırabilirsiniz.&lt;/t&gt;</Turkish>
    <Japanese>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ 脱出に関する重要警告:&lt;br/&gt;脱出はサポートメニュー(0-8-3)からの完全手動要請であり、自動では絶対に発生しません！いつでも好きなタイミングで要請可能です。&lt;/t&gt;</Japanese>
    <Korean>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ 탈출 관련 중요 안내:&lt;br/&gt;탈출은 지원 메뉴(0-8-3)를 통해 100% 수동으로 요청해야 하며, 자동으로 진행되지 않습니다! 언제든지 원할 때 요청할 수 있습니다.&lt;/t&gt;</Korean>
    <Chinese>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ 撤離重要提示：&lt;br/&gt;撤離行動必須由玩家透過支援選單 (0-8-3) 手動呼叫，絕非自動觸發！您可以在行動中隨時呼叫撤離。&lt;/t&gt;</Chinese>
    <Chinesesimp>&lt;t color='#FF3333' size='0.90' font='PuristaBold'&gt;⚠️ 撤离重要提示：&lt;br/&gt;撤离行动必须由玩家通过支援菜单 (0-8-3) 手动呼叫，绝非自动触发！您可以在行动中随时呼叫撤离。&lt;/t&gt;</Chinesesimp>
</Key>
```

---

### Étape 8 : Nettoyage des Musiques Inutilisées (`description.ext`, `CfgSounds.hpp` et `Music\`)

#### A. Suppression des fichiers physiques dans `c:\Users\kevin\Documents\Arma 3\missions\ORA.Takistan\Music\` :
Fichiers à supprimer :
- `Shadow_of_the_Valley_01.ogg`
- `Shadow_of_the_Valley_02.ogg`
- `Shadow_of_the_Valley_03.ogg`
- `legion_01.ogg`
- `Rubab_Full.ogg`

*Fichiers conservés intacts :* `ezan.ogg`, `Rubab_01.ogg`, `Rubab_02.ogg`.

#### B. Nettoyage de `class CfgMusic` dans `description.ext` :
Conserver uniquement les musiques nécessaires :
```cpp
class CfgMusic
{
    tracks[] = {};

    class Music_Ezan
    {
        name = "Ezan";
        sound[] = {"Music\ezan.ogg", db+0, 1.0};
        titles[] = {0, ""};
    };

    class Music_Rubab_01
    {
        name = "Rubab 01";
        sound[] = {"Music\Rubab_01.ogg", db+10, 1.0};
        titles[] = {0, ""};
    };

    class Rubab_01: Music_Rubab_01 {};

    class Music_Rubab_02
    {
        name = "Rubab 02";
        sound[] = {"Music\Rubab_02.ogg", db+10, 1.0};
        titles[] = {0, ""};
    };

    class Rubab_02: Music_Rubab_02 {};
};
```

#### C. Nettoyage de `CfgSounds.hpp` :
Supprimer les déclarations `Sound_Music_Intro` et `Sound_Rubab_Full` qui faisaient référence aux fichiers supprimés.

---

### Étape 9 : Régénérer la `stringtable.xml`
Exécuter la compilation non destructive via `compile_stringtable.py` pour intégrer automatiquement tous les nouveaux fichiers `.xml` sans aucune perte de données.

---

### Étape 10 : Corriger la musique de départ de l'hélicoptère d'extraction (`fn_heliManager.sqf`)
Dans `Functions/Helicopter/fn_heliManager.sqf` (lignes 550 & 552) :
```sqf
playMusic "Music_Rubab_02";
playSound "Sound_Rubab_02";
```

---

### Étape 11 : Corriger les textures de carte manquantes dans le Menu Principal (`Dialogs/main_menu.hpp`)
Dans `Dialogs/main_menu.hpp` :
1. Remplacer les références fictives `something_ca.paa` par l'icône de buisson standard Arma 3 :
   - Dans `class SmallTree` (ligne 578) : `icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";`
   - Dans `class Tree` (ligne 596) : `icon = "\A3\ui_f\data\map\mapcontrol\bush_ca.paa";`
2. Corriger la faute de frappe sur l'icône de ruine (retrait du 's' pluriel inexistant) :
   - Dans `class Ruin` (ligne 560) : `icon = "\A3\ui_f\data\map\mapcontrol\ruin_ca.paa";`
   - Dans `class Ruins` (ligne 569) : `icon = "\A3\ui_f\data\map\mapcontrol\ruin_ca.paa";`
3. Corriger la coquille sur l'icône de tourisme (remplacement de 'tourist' par 'tourism') :
   - Dans `class Tourism` (ligne 614) : `icon = "\A3\ui_f\data\map\mapcontrol\tourism_ca.paa";`
   - Dans `class Tourist` (ligne 623) : `icon = "\A3\ui_f\data\map\mapcontrol\tourism_ca.paa";`
