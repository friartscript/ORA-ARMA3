# ⚔️ OPERATION ROYAL ALLIANCE — Takistan

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%5D-blue?style=for-the-badge&logo=arma)
![Engine](https://img.shields.io/badge/Engine-Real%20Virtuality%204-red?style=for-the-badge)
![Mods](https://img.shields.io/badge/Dependencies-CUP%20%7C%20Max%20Women-orange?style=for-the-badge)
![Languages](https://img.shields.io/badge/Localization-14%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Fully%20Optimized%20%26%20Tested-success?style=for-the-badge)

**Un générateur d'opérations dynamiques en bac à sable et un centre de commandement tactique immersif pour Arma 3 Solo.**

[Vue d'Ensemble](#-vue-densemble) • [Lore & Contexte](#-contexte-stratégique--lore) • [Fonctionnalités Clés](#-fonctionnalités-majeures) • [Opérations](#-catalogue-des-missions) • [Commandement & R.O.E](#-règles-dengagement--commandement-descouade) • [Menu Radio Support 0-8](#-menu-radio-support-0-8) • [Installation & Dépendances](#-installation--dépendances) • [Localisation](#-localisation-multilingue-14-langues) • [Architecture](#-architecture-technique)

---

</div>

<br/>

## 🎯 Vue d'Ensemble

**Operation Royal Alliance (ORA)** est une mission solo tactique non-linéaire qui réinvente l'expérience d'engagement en milieu aride sur le théâtre d'opérations du **Takistan**. 

Incarnez le chef de groupe d'une escouade de la **Légion Étrangère du RACS** (*Royal Army Corps of Sahrani*). Grâce à un **lanceur tactique 3D sur mesure**, planifiez votre secteur d'insertion, sélectionnez votre appui motorisé, réglez les conditions météo et enchaînez des missions procédurales dans un environnement moyen-oriental vivant et hautement réactif.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  CENTRE DE COMMANDEMENT ──► INSERTION TACTIQUE ──► OPÉRATIONS EN ZONE        │
│  (GUI 3 Panneaux & PiP)     (UH-60L ou C-130 HALO) (Missions Procédurales)   │
│                                                                │             │
│  FIN DE SESSION ◄──────────── EXTRACTION HÉLIPORTÉE ◄──────────┘             │
│  (Rapport de Mission)         (Support Radio 0-8-3 • MANUELLE À LA DEMANDE)  │
└──────────────────────────────────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> ### 🚨 DIRECTIVE D'EXTRACTION CRUCIALE
> **L'évacuation de la zone d'opération est STRICTEMENT MANUELLE.**  
> L'hélicoptère d'extraction ne viendra **JAMAIS** de façon automatique après avoir accompli vos tâches. Vous êtes libre d'ordonner l'extraction à tout moment (après un, deux ou trois objectifs, ou même en cas de retraite d'urgence si votre escouade est décimée) via votre radio :  
> 👉 **Menu Communication Radio `0-8-3` (ou molette d'action)**.

---

## 🌍 Contexte Stratégique & Lore

### 1. La Guerre Civile au Takistan (2025–2026)
Le **Takistan** est plongé dans une guerre civile sanglante. Carrefour géostratégique du Moyen-Orient riche en ressources sensibles, la région est devenue le sanctuaire de milices rebelles surarmées, de cellules terroristes et de seigneurs de guerre locaux menaçant la stabilité internationale.

### 2. Le Corps Expéditionnaire de Sahrani (RACS)
À la suite de la réunification du Royaume de Sahrani, la monarchie a créé une unité d'élite dédiée aux interventions extérieures à haut risque : la **Légion Étrangère du RACS** (*RACS Foreign Legion*). Composée de vétérans internationaux aguerris, l'escouade est déployée sous mandat de pacification pour éliminer la menace insurgée et protéger les populations locales sans exposer les forces régulières du Royaume.

---

## ⚡ Fonctionnalités Majeures

### 🖥️ 1. Lanceur de Mission Tactique Interactif (GUI)
* **Centre de Commandement 3D :** Interface graphique à 3 volets déployée avant chaque départ en mission.
* **Vecteurs d'Insertion Dédiés :**
  * *Vol basse altitude :* Insertion cinématique à bord d'un hélicoptère **UH-60L Black Hawk** au ras du relief avec atterrissage tactique.
  * *Parachutage HALO :* Largage à haute altitude depuis un avion-cargo **C-130J Hercules**.
* **Visualiseur 3D en Temps Réel (PiP) :** Sélection interactive du véhicule terrestre d'appui (Land Rover SF GMG RACS, Hilux, etc.) avec rendu caméra 3D dynamique.
* **Météorologie Personnalisable :** Paramétrage temps réel de l'heure du jour (00:00 à 23:00), du brouillard (0% à 100%) et de la couverture nuageuse.
* **Contrôle de Carte Fiabilisé :** Mini-carte vectorielle optimisée sans erreurs de textures sur les 10 secteurs d'opération (végétation, ruines, points d'intérêt touristiques).

---

### 🔄 2. Moteur d'Opérations Dynamiques & Modulaires
* **Boucle de Jeu Flexible :** Choisissez entre 1 et 3 opérations prioritaires et accomplissez-les dans l'ordre de votre choix.
* **Génération Procédurale :** Placement dynamique des camps ennemis, patrouilles, otages, relais de communication, officiers HVT et caches chimiques à travers les villages et reliefs du Takistan.
* **Logistique Adaptative Intelligente :** L'arsenal de départ synchronise en temps réel le coffre de votre véhicule de patrouille avec les munitions, chargeurs et calibres exacts de l'armement que vous venez d'équiper.
* **Contre-Attaque Ennemie Réactive :** À la complétion d'un objectif majeur, les cellules insurgées locales déclenchent immédiatement une manœuvre de riposte agressive (*Search & Destroy*).
* **Missions d'Urgence Inopinées :** Le Commandement peut vous assigner une mission surprise par radio en cours de patrouille si vous n'avez pas d'otage sous escorte.

---

### 🕌 3. Immersion Culturelle & Vie Rurale Vivante
* **Appel à la Prière 3D Spatialisé (Ezan) :** Diffusion audio Mono 3D ultra-réaliste depuis les minarets des mosquées avec écho naturel de vallée et algorithme anti-cacophonie (< 350m).
* **Population Takistanaise Authentique :**
  * Hommes civils vêtus de tenues traditionnelles, turbans (*Lungee*), bonnets (*Pakol*, *SkullCap*) et barbes afghanes.
  * **Présence de femmes civiles et combattantes** avec des modèles 3D féminins authentiques (*Mod Max Women*), burqas et tenues régionales.
  * **Protocole Vocal Persan & Pachto :** Voix natives persanes (`RadioProtocolPER`) avec modulation de pitch pour des dialogues et réactions de panique réalistes.
* **Vie Rurale & Faune :** Troupeaux de moutons procéduraux avec comportements de pâturage et dispersion sous les tirs.
* **Profils Comportementaux IA :** 6 états psychologiques civils distincts (fuite paniquée, mise à couvert, résignation, neutralité).

---

### 🎮 4. Commandement d'Escouade & Continuité Solo
* **Contrôle Tactique R.O.E :** Régulez instantanément la posture de vos coéquipiers IA via le menu déroulant (Infiltration, Normal, Défense, Regroupement d'Urgence, Assaut).
* **Transfert de Commandement Transparent (`fn_switchToAI`) :** Si le joueur tombe au combat, la caméra et le commandement basculent immédiatement sur un coéquipier IA survivant de l'escouade.
* **Auto-Soin des Unités Alliées :** Gestionnaire autonome de premiers secours permettant aux coéquipiers IA de se soigner et de stabiliser leurs blessures au combat.
* **Discipline d'Éclairage Nocturne :** Les ennemis conservent leurs lampes éteintes dans l'obscurité et ne les allument que lors d'un engagement armé confirmé.
* **Système Intelligent de Portes & Grilles (`fn_doorSecurity`) :** Ouverture automatique universelle des portes, volets métalliques de commerces et portails à 4.5m pour l'infanterie, avec fermeture automatique à 6.0m pour éliminer les blocages de pathfinding d'Arma 3.

---

## 📻 Menu Radio Support (0-8)

À tout moment, appuyez sur vos touches de communication radio **0-8** pour contacter le Commandement de la Légion :

| Canal Radio | Type d'Appui Tactique | Description Opérationnelle |
| :---: | :--- | :--- |
| **0-8-1** | 🚁 **Appui Aérien (CAS)** | Un hélicoptère UH-60L Black Hawk intervient pour délivrer des tirs de suppression au sol sur coordonnées. |
| **0-8-2** | 📦 **Ravitaillement par Air** | Parachutage d'une caisse de munitions et d'équipement médical d'urgence sur votre position. |
| **0-8-3** | 🛫 **Extraction Tactique** | **Appel manuel de l'hélicoptère d'évacuation.** Définition de la LZ, sécurisation de zone et retour à la base. |
| **0-8-4** | 🚗 **Véhicule de Remplacement** | Largage ou mise à disposition d'un véhicule de patrouille neuf si le vôtre est détruit ou immobilisé. |
| **0-8-5** | 📡 **Drone de Reconnaissance (MQ-9)** | Déploiement d'un drone avec retransmission vidéo en direct (PiP) et télémétrie des forces ennemies sur zone. |

---

## 📋 Catalogue des Missions

Chaque déploiement combine des directives d'engagement globales et des missions procédurales sélectionnées au panneau :

| Code Tâche | Type d'Opération | Description Stratégique |
| :---: | :--- | :--- |
| **Directive 1** | **Transit & Reconnaissance** | Déploiement initial et prise de position dans le secteur opérationnel (550m). |
| **Directive 2** | **Protection Civile** | Préservation absolue des populations civiles et respect strict des règles d'engagement. |
| **Directive 3** | **Survie & Extraction Sécurisée** | Préservation des effectifs de la Légion et évacuation manuelle via Support `0-8-3`. |
| **Tâche D-00** | **Libération de Captif** | Infiltration d'un complexe fortifié pour secourir un informateur ou agent captif. |
| **Tâche D-01** | **Récupération de Documents** | Fouille méticuleuse d'un officier ou avant-poste ennemi pour récupérer des ordres secrets. |
| **Tâche D-02** | **Élimination de Commandant (HVT)** | Traque et neutralisation ciblée d'un chef insurgé retranché dans une zone urbaine. |
| **Tâche D-03** | **Destruction de Relais Radio** | Neutralisation d'antennes de communication rebelles à l'aide de charges d'explosifs programmées. |
| **Tâche D-04** | **Sécurisation de Cuve Chimique** | Infiltration d'un dépôt clandestin et neutralisation de précurseurs toxiques. |
| **Tâche D-08** | **Destruction de Tigris AA** | Localisation et destruction d'un blindé antiaérien menaçant l'espace aérien de la coalition. |
| **Optionnelle** | **Menace Insurgée** | Activation d'embuscades civiles rares et d'insurgés infiltrés parmi la population. |
| **Bonus** | **Tâche d'Urgence Inopinée** | Réassignation tactique inattendue du Commandement vers un nouvel objectif chaud en Takistan. |

---

## 🎖️ Règles d'Engagement & Commandement d'Escouade

Gérez la tactique de votre escouade en direct via le menu déroulant (molette de la souris) :

| Posture Tactique | Effet sur l'Escouade IA | Cas d'Usage Idéal |
| :--- | :--- | :--- |
| 🤫 **Infiltration** | Déplacement furtif en silence, accroupi, désactivation de l'autocombat. | Approche nocturne, reconnaissance, contournement de patrouilles. |
| 🛡️ **Normal** | Vitesse standard, engagement libre à portée utile, couverture mutuelle. | Progression générale en terrain ouvert et fouille de village. |
| 🏰 **Défense** | Prise de position statique à 360°, couverture des accès et fenêtres. | Attente de l'extraction, sécurisation de VIP, tenue d'un carrefour. |
| ⚡ **Regroupement d'Urgence** | Sprint immédiat vers le leader, rupture de contact sans riposte. | Désengagement sous tir de mortier, extraction précipitée. |
| 💥 **Assaut** | Vitesse maximale, tir de suppression soutenu et progression agressive. | Assaut final sur bâtiment fortifié, réduction d'un nid de résistance. |

---

## 📦 Installation & Dépendances

### 1. Prérequis (Mods Requis)
Cette mission nécessite les mods suivants, disponibles sur le **Steam Workshop** :

* [CUP Terrains - Core](https://steamcommunity.com/sharedfiles/filedetails/?id=583496341)
* [CUP Terrains - Maps](https://steamcommunity.com/sharedfiles/filedetails/?id=583544988)
* [CUP Units](https://steamcommunity.com/sharedfiles/filedetails/?id=497661914)
* [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
* [CUP Weapons](https://steamcommunity.com/sharedfiles/filedetails/?id=497660133)
* [Max Women](https://steamcommunity.com/sharedfiles/filedetails/?id=1451755886)

### 2. Installation Manuelle
1. Téléchargez ou clonez ce dossier de mission dans votre répertoire Arma 3 :
   ```text
   C:\Users\<VotreNom>\Documents\Arma 3\missions\ORA.Takistan
   ```
2. Lancez **Arma 3** avec les mods CUP et Max Women activés dans votre lanceur.
3. Rendez-vous dans le menu : **Jouer** ──► **Scénarios** ──► **Operation Royal Alliance**.

---

## 🌐 Localisation Multilingue (14 Langues)

La mission intègre une internationalisation native complète grâce à un pipeline XML compilé :

| Langue | Statut | Langue | Statut | Langue | Statut |
| :--- | :---: | :--- | :---: | :--- | :---: |
| 🇫🇷 **Français** | 100% | 🇬🇧 **Anglais** | 100% | 🇪🇸 **Espagnol** | 100% |
| 🇩🇪 **Allemand** | 100% | 🇮🇹 **Italien** | 100% | 🇵🇱 **Polonais** | 100% |
| 🇷🇺 **Russe** | 100% | 🇹🇷 **Turc** | 100% | 🇯🇵 **Japonais** | 100% |
| 🇰🇷 **Coréen** | 100% | 🇨🇳 **Chinois** | 100% | 🇵🇹 **Portugais** | 100% |
| 🇨🇿 **Tchèque** | 100% | 🌐 **Original** | 100% | | |

*Tous les sous-titres, communications radio, alertes et interfaces sont traduits dynamiquement selon la langue de votre jeu sans texte en dur résiduel.*

---

## 🏗️ Architecture Technique

Le code source de la mission a été conçu selon des normes strictes de modularité et de performance :

* **Zéro Desync Solo :** 100% optimisé pour le moteur Solo (aucune charge réseau superflue).
* **Architecture Modulaire :** 54 fonctions SQF spécialisées regroupées par domaine sous `Functions/` (`Briefing/`, `Civilian/`, `Drone/`, `Environment/`, `Helicopter/`, `Medical/`, `Player/`, `Spawn/`, `Task/`, `Team/`).
* **Qualité Sonore & Stabilité :** Entrées `titles[]` déclarées pour toutes les émissions sonores 3D (`CfgSounds.hpp`), bande son optimisée au format OGG.
* **Documentation Développeur Complète :**
  * 👉 **[`ARCHI.md`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/ARCHI.md)** : Architecture globale détaillée de la mission.
  * 👉 **[`CORRECTIF.md`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/CORRECTIF.md)** : Rapport complet de tous les correctifs appliqués.
  * 👉 **[`INFO_STRINTABLE.md`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/INFO_STRINTABLE.md)** : Pipeline de traduction et standard de localisation.

---

## 👤 Auteur & Crédits

* **Créateur & Développeur Principal :** **Friart Script** ([@friartscript](https://steamcommunity.com))
* **Moteur & Univers :** [Bohemia Interactive](https://www.bohemia.net/) (*Arma 3*)
* **Assets & Équipements :** [CUP Team](http://cup-arma3.org/) (*Community Upgrade Project*)
* **Modèles Féminins :** [Max](https://steamcommunity.com/sharedfiles/filedetails/?id=1451755886) (*Max Women*)
* **Bande Son & Ambiance :** Musiques traditionnelles orientales au Rubab afghan (*Rubab 01* et *Rubab 02*) & Appel à la Prière authentique (*Ezan*).

---

<div align="center">

*« Analyser les données de vos missions et informations qui vous sont données et tout se passera bien. »*  
**OPORD — Commandement de la Légion Étrangère du RACS**

</div>
