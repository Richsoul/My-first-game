# My-first-game
## Table of Contents
  * [Game Design](#game-design)
    * [Objective](#objective)
    * [Gameplay Mechanics](#gameplay-mechanics)
    * [Level Design](#level-design)
  * [Technical](#technical)
    * [Scenes](#scenes)
    * [Controls/Input](#controlsinput)
    * [Classes](#classessks)
  * [MVP Milestones](#mvp-milestones)
    * [Week 1](#week-1)
    * [Week 2](#week-2)
    * [Week 3](#week-3)
    * [Week 4](#week-4)
    * [Week 5](#week-5)
    * [Week 6](#week-6)

---

### Game Design

#### Objective
The goal of *Game's Name* is to control a diver to collect dropped/lost items on the bottom of the lake. Depending on the initial cost and state of founded item player exchanges it on money at the end of each level, then money could be spend to buy new, more specialized equipement, that will improve his dive experience. On his way the diver will meet obstacles as: fishing nets, hooks, boats, rocks, seaweed, etc.

#### Gameplay Mechanics
The game is infinite runner(swimmer), where player controls the diver with press and hold action. The control action will make diver swim deeper to the bottom of the lake to collect items. Total worth of collected items will be calculated in the end of each round and sums into player's current savings. The round can end either by player's decision or when the diver runs out of oxygen. The erned money could be spend of upgreading oxygen chamber's capasity, that will allow diver to stay under water dor longer time perion; or better diving suit, that will improve dive speed. On his way the diver will meet number of obsicles that will somehow affect diver's performance. He can be stuck inside fishing net, fishing hook or seaweed which will pull him even deeper into the lake, forcing player to return to the surface; when hit by rock or boat he stops for a second, looses sertain amount of oxygen, but don't go any deeper. Fishing net roots for 4 seconds, seaweed for 3, and hook for 2. The oxygen level is automatialy re-filled, while the diver remains on or above water's surface. Boats' appearence will be alarmed three seconds ahead. Boats will be long, and as diver cannot reach the air, he will have to spend the time under water, whating for boat to pass. The other alarm warns the player to fill the oxigen, while under 15% mark.
 
#### Level Design
There will be a long level tamplate, that is repeats infinitefly, however, obstacle are generated independently. Diver won't be able to rise above water level or dive deeper than ground level. The x position of diver is always remains constant, while world's scrolling speed will decrease, when he is hit or gets stuck, to make a illusion of speed loss. The scroll speed will rise by 0.1 every second a hero is alive, this featre will assure the player never gets boared as the game gets harder. The further you go the longer will obstacles stun you, this feature well keep player tense thourgout entire game.
[Back to top ^](#)

---

### Technical

#### Scenes
- the menu will include games name on 1/4 of scree height, start area on whole screen and label under the name:"Press anywhere to start" and settings, shop bttons on both bottom corners
- game scene will include pause and restart buttons, on both upeer corners, as well as current and highest distances labels
- pause screen will include resure, shop and main menu buttons, high distance and current distance labels
- lose screen will look like pause screen
- shop scene will include items for update, current money amount label, return button, buy buttons, setting button

#### Controls/Input
- hold - dive
- release - swim up

#### Classes/SKS
* Classes
 - Game Scene
 - Main Menu
 - Pause Scene
 - Schop Scene
  * [list classes needed and some basic information about required implementation]
* SKS
 - Game Scene
 - Main Menu
 - Pause Scene
 - Schop Scene 
  * [list SKS files you will need to create]

[Back to top ^](#)

---

### MVP Milestones
[The overall milestones of first playable build, core gameplay, and polish are just suggestions, plan to finish earlier if possible. The last 20% of work tends to take about as much time as the first 80% so do not slack off on your milestones!]

#### Week 1
_planing your game_
Monday: 
- Analys
- Idea development
- GDD
Tuesday: ------------------------------------------------------------------------------------------------| 3 and a half hours overall
- Buld Game Scene: --------------------------------------------------------------------------------------| 2 hour total
    - add ground node --------------|
    - add water node ---------------|
    - add hero node ----------------|
    - add touch node ---------------|
    - add restarn button node ------| 30 minutes
    - add pause button node --------|
    - add high distance labe -------|
    - add current distance label ---|
    - add money counter label ------|
    - add start game counter label(set isHidden = false one at a time): -|
        - add "3" label -------------------------------------------------|
        - add "2" label -------------------------------------------------|
        - add "1" label -------------------------------------------------| 10 minutes
        - add "Start" label ---------------------------------------------|
    - add death lalel ---------------------------------------------------|
    - add death window node(set to hidden): ----|
        - add main menu button node  (inside) --|
        - add restart button node    (inside) --|
        - add shop button node       (inside) --|
        - add settings button node   (inside) --| 30 minutes
        - add high distance label    (inside) --|
        - add current distance label (inside) --|
        - add money counter label    (inside) --|
        - add "You are dead" label   (inside) --|
    - implement reverce physics ----------------------------------------------------|
    - set max hero y location to water node height ---------------------------------|
    - wave motion illusion: --------------------------------------------------------|
        - if hero node reaches water node's max height the y speed = -10 for 1 sec -|
    - add simple obstacles ---------------------------------------------------------| 50 minutes
    - add simple level tamplate: ---------------------------------------------------|
        - different heights --------------------------------------------------------|
        - ununiform surface --------------------------------------------------------|
    - add objectives ---------------------------------------------------------------|
- Build Main Menu: --------------------------------------------------------------------------------------| 10 minutes total
    - add game's name node --------|
    - add settings button node ----|
    - add touch node --------------| 10 minutes 
    - add high distance label -----|
    - add money counter label -----|
- Build Pause Scene: ------------------------------------------------------------------------------------| 20 minutes total
    - add resume button node -------| 
    - add restart button node ------| 
    - add shop button node ---------|
    - add settings button node -----|
    - add main menu button node ----| 20 minutes total
    - add high distance label ------|
    - add current distance label ---|
    - add money counter label ------|
    - add "Pause" label ------------|
- Build Settings Scene: ---------------------------------------------------------------------------------| 30 minutes total
    - add game music label -----------------|
    - add sound effects label --------------|
    - add delete game results label --------|
    - add game music "on" switch node ------| 20 minutes
    - add game music "off" switch node -----| 
    - add sound effects "on" switch node ---|
    - add sound effects "off" switch node --|
    - add delete game results button node --|
    - add delete game results window node(set to hidden): -|
        - add question test label  (inside) ---------------|
        - add "ok" button node     (inside) ---------------| 10 mintes
        - add "cancel" button node (inside) ---------------|
    - add go back button node -----------------------------|
- Build Shop Scene: --------------------------------------------------------------------------------------| 30 minutes total
    - add shop background node ----|
    - add items icon nodes: -------|
        - oxygen chamber ----------|
        - diving suit -------------|
    - add "Buy" button nodes ------|
    - add price labels ------------|
    - add current index nodes -----| 30 minutes
    - add go back button node -----|
    - add setting button node -----|
    - add high distance label -----|
    - add current distance label --|
    - add money counter label -----|
    - add "Shop" lable ------------|


* [goals for the week]

#### Week 2
_finishing a playable build_
* [goals for the week, should be finishing a playable game]

#### Week 3
* [goals for the week]

#### Week 4
* [goals for the week, should be finishing all core gameplay]

#### Week 5
_starting the polish_
* [goals for the week]

#### Week 6
_submitting to the App Store_
* [goals for the week, should be finishing the polish -- demo day on Saturday!]

[Back to top ^](#)
