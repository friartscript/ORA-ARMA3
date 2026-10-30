# ⚔️ OPERATION ROYAL ALLIANCE — Takistan

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%5D-blue?style=for-the-badge&logo=arma)
![Theatre](https://img.shields.io/badge/Theatre-Takistan-yellow?style=for-the-badge)
![Mods](https://img.shields.io/badge/Dependencies-CUP%20%7C%20Max%20Women-orange?style=for-the-badge)
![Languages](https://img.shields.io/badge/Localization-14%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)

**Scénario solo dynamique, tactique et hautement rejouable pour Arma 3.**  
Prenez la tête d'un groupe de combat de la **Légion Étrangère du RACS** et menez des opérations spéciales ciblées en territoire hostile.

---

</div>

## 🎯 En Bref

**Operation Royal Alliance (ORA)** vous place aux commandes d'une escouade d'intervention sur le théâtre aride du Takistan. Avant chaque déploiement, configurez entièrement votre mission via un **lanceur tactique 3D**, puis accomplissez vos objectifs en toute liberté avant d'ordonner l'extraction de vos troupes.

> [!IMPORTANT]
> ### 🚨 L'EXTRACTION EST STRICTEMENT MANUELLE
> **L'hélicoptère d'évacuation ne viendra jamais automatiquement.**  
> Une fois vos objectifs accomplis (ou pour ordonner une retraite tactique d'urgence), vous devez appeler vous-même l'hélicoptère via votre radio :  
> 👉 **Menu Communication Radio `0-8-3` (ou molette d'action)**.

---

## 🕹️ Déroulement d'une Opération

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ LANCEUR 3D      │ ──► │ INSERTION ZONE  │ ──► │ COMBATS & ROE   │ ──► │ EXTRACTION 0-8-3│
│ Météo, Secteur, │     │ Vol rase-mottes │     │ Objectifs au    │     │ Évacuation      │
│ Insertion, 4x4  │     │ UH-60 ou C-130  │     │ choix & Arsenal │     │ manuelle à bord │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
```

1. **Planification (Menu Tactique 3D) :**
   - **Conditions météo :** Heure (00h-23h), brouillard et couverture nuageuse en temps réel.
   - **Vecteur d'insertion :** Posé d'assaut en hélicoptère **UH-60L Black Hawk** ou parachutage haute altitude **HALO en C-130J Hercules**.
   - **Secteur opérationnel :** Déploiement parmi 10 secteurs variés de la carte de Takistan.
   - **Véhicule de soutien :** Choix du 4x4 d'appui (Land Rover SF GMG, Hilux...) visualisable en 3D (PiP).

2. **Arsenal & Logistique Intelligente :**
   - À votre arrivée, équipez les armes de votre choix dans la caisse d'arsenal.
   - **Le coffre de votre véhicule de patrouille synchronise automatiquement** les chargeurs et munitions compatibles avec vos armes !

3. **Missions Opérationnelles (1 à 3 au choix) :**
   - 👤 **Libération d'otage :** Secourir un informateur captif retranché sous garde ennemie.
   - 🎯 **Élimination de commandant (HVT) :** Traquer et neutraliser un chef de guerre insurgé.
   - 📡 **Destruction de relais radio :** Poser des charges explosives sur les antennes rebelles.
   - ☣️ **Sécurisation de cuve chimique :** Neutraliser des substances toxiques clandestines.
   - 📁 **Récupération de documents :** Fouiller un officier ennemi pour saisir des plans secrets.
   - 🛡️ **Destruction de Tigris AA :** Neutraliser un blindé antiaérien menaçant le secteur.
   - ⚠️ **Menace insurgée & Tâches d'urgence :** Embuscades civiles et ordres inopinés du QG par radio.

4. **Évacuation Tactique :**
   - Dès que vous le décidez, appelez l'extraction via **Support `0-8-3`**.
   - Marquez la zone d'atterrissage, montez à bord avec votre groupe et profitez du debriefing.

---

## 📻 Menu Radio Support (0-8)

Contactez le commandement à tout moment avec vos touches de communication radio **0-8** :

| Canal | Soutien | Rôle Opérationnel |
| :---: | :--- | :--- |
| **0-8-1** | 🚁 **Appui Aérien (CAS)** | Tir de mitraillage et roquettes sur les positions ennemies par un UH-60. |
| **0-8-2** | 📦 **Largage de Ravitaillement** | Parachutage d'une caisse de munitions et soins médicaux sur votre position. |
| **0-8-3** | 🛫 **Extraction Hélicoptère** | **Appel manuel d'évacuation.** Atterrissage sur zone et retour à la base. |
| **0-8-4** | 🚗 **Véhicule de Remplacement** | Remplacement de votre véhicule de patrouille en cas de destruction. |
| **0-8-5** | 📡 **Drone de Surveillance (MQ-9)** | Transmission vidéo PiP en direct et détection radar des menaces. |

---

## 🎖️ Commandement d'Escouade & Continuité

- **Règles d'Engagement (Molette) :** Commandez votre groupe en temps réel (Infiltration silencieuse, Normal, Défense 360°, Regroupement d'urgence, Assaut lourd).
- **Continuité Solo (`fn_switchToAI`) :** Si votre personnage tombe au combat, le commandement bascule immédiatement sur un de vos coéquipiers IA survivants sans arrêt de mission.
- **Premiers Secours Autonomes :** Les membres de l'escouade soignent leurs blessures et se stabilisent mutuellement.
- **Portes Automatiques :** Les bâtiments et grilles s'ouvrent à votre approche pour éviter les blocages de pathfinding d'Arma 3.

---

## 🕌 Immersion & Monde Vivant

- **Appel à la Prière 3D (Ezan) :** Résonance authentique depuis les minarets des villages avec écho de vallée naturel.
- **Population Takistanaise Réaliste :** Tenues régionales, turbans, femmes civiles et combattantes (mod *Max Women*), dialecte vocal persan/pachto et réactions de panique crédibles sous le feu.

---

## 📦 Mods Requis & Installation

### Mods Nécessaires (Steam Workshop) :
1. [CUP Terrains - Core](https://steamcommunity.com/sharedfiles/filedetails/?id=583496341)
2. [CUP Terrains - Maps](https://steamcommunity.com/sharedfiles/filedetails/?id=583544988)
3. [CUP Units](https://steamcommunity.com/sharedfiles/filedetails/?id=497661914)
4. [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
5. [CUP Weapons](https://steamcommunity.com/sharedfiles/filedetails/?id=497660133)
6. [Max Women](https://steamcommunity.com/sharedfiles/filedetails/?id=1451755886)


## 🌐 14 Langues Supportées (100% Intégré)

La mission s'adapte automatiquement à la langue de votre jeu (textes, dialogues radio, alertes et menus) :  
🇫🇷 Français • 🇬🇧 Anglais • 🇪🇸 Espagnol • 🇩🇪 Allemand • 🇮🇹 Italien • 🇵🇱 Polonais • 🇷🇺 Russe • 🇹🇷 Turc • 🇯🇵 Japonais • 🇰🇷 Coréen • 🇨🇳 Chinois • 🇵🇹 Portugais • 🇨🇿 Tchèque.

