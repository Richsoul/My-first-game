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

---

### Game Design

#### Objective
The goal of *Game's Name* is to control a diver to collect dropped/lost items on the bottom of the lake. Depending on the initial cost and state of founded item, player exchanges it to money equivalent at the end of each level; then money could be spend to buy new, more specialized equipement, that will improve his dive experience. On his way the diver will meet variaty of obstacles: fishing nets, boats, seaweed.

#### Gameplay Mechanics
The game is infinite runner(swimmer), where player controls the diver with press and hold action. The control action will make diver swim deeper to the bottom of the lake to collect items. Total worth of collected items will be calculated in the end of each round and sums into player's current savings. The round will end when the diver runs out of oxygen. The erned money could be spend of upgreading oxygen chamber's capasity, that will allow diver to stay under water for longer time perion; or better diving suit, that will improve dive speed. On his way the diver will meet number of obsicles that will somehow affect his performance. He can be stuck inside fishing net, or seaweed which will pull him even deeper into the lake, forcing player to return to the surface; when hit by front part of the boat, it will capture him and push outside of the screen, which will result diver's death; when hit by boat's engine, he looses 10% of max amount of oxygen and bouncec off of it. Fishing net roots for 2 seconds, disallowing him to swim up; seaweed roots for the whole time diver spend inside. The oxygen level is automatialy re-filled, while the diver remains on or above water's surface. Boats' appearence will be alarmed three seconds ahead. Boats will be long, and as diver cannot reach the air, he will have to spend the time under water, whating for boat to pass. The other alarm warns the player to fill the oxigen, while under 15% mark. On the way the diver will collect power ups which will give him sustain to one of the obstacles, or change the controlls.
 
#### Level Design
There will be a long level tamplate, that is repeats infinitefly, however, obstacle are generated independently. Diver won't be able to rise above water level or dive deeper than ground level. The x position of diver will always remain constant, however world's scrolling speed will decrease, when he is hit or gets stuck, to make a illusion of speed loss. The scroll speed will rise by 0.001 every second a hero is alive, this feature will assure the player will never get boared. The further you go the longer will obstacles root you, this feature well keep player tense thourgout entire game.(NO)
[Back to top ^](#)

---

### Technical

#### Scenes
- the menu will include games name on 1/4 of scree height, start area on whole screen and label under the name:"Press anywhere to start" and settings, shop bttons on both bottom corners
- game scene will include pause , upeer righ corner, as well as current distances and money labels on the other top corner
- pause screen will include resume, shop and main menu buttons, highest and current distance labels
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
- the furthest distance will be displayed in the beggingin of the game, on the wooden namaplate or elsewhere
- finish shop upgrades

#### Week 1
_planing your game_
Monday: 
- Analys
- Idea development
- GDD
Tuesday: ------------------------------------------------------------------------------------------------| 7 hours overall
- Buld Game Scene: --------------------------------------------------------------------------------------| 4 hour total
    - add ground node --------------|
    - add water node ---------------|
    - add hero node ----------------|
    - add restarn button node ------| hour
    - add pause button node --------|
    - add highest distance labe ----|
    - add current distance label ---|
    - add money counter label ------|
    - add start game counter label(set isHidden = false one at a time): -|
        - add "3" label -------------------------------------------------|
        - add "2" label -------------------------------------------------|
        - add "1" label -------------------------------------------------| 20 minutes
        - add "Start" label ---------------------------------------------|
    - add death lalel ---------------------------------------------------|
    - add death window node(set to hidden): ----|
        - add main menu button node  (inside) --|
        - add restart button node    (inside) --|
        - add shop button node       (inside) --|
        - add settings button node   (inside) --| hour
        - add highest distance label (inside) --|
        - add current distance label (inside) --|
        - add money counter label    (inside) --|
        - add "You are dead" label   (inside) --|
    - implement reverce physics ----------------------------------------------------|
    - set max hero y location to water node height ---------------------------------|
    - wave motion illusion: --------------------------------------------------------|
        - if hero node reaches water node's max height the y speed = -10 for 1 sec -|
    - add simple obstacles ---------------------------------------------------------| hour and 40 minutes
    - add simple level tamplate: ---------------------------------------------------|
        - different heights --------------------------------------------------------|
        - ununiform surface --------------------------------------------------------|
    - add objectives ---------------------------------------------------------------|
- Build Main Menu: --------------------------------------------------------------------------------------| 20 minutes total
    - add game's name node ---------|
    - add settings button node -----|
    - add highest distance label ---| 20 minutes 
    - add money counter label ------|
    - add shop button node ---------|
    _ add start touch node ---------|
- Build Pause Scene: ------------------------------------------------------------------------------------| 40 minutes total
    - add resume button node -------| 
    - add restart button node ------| 
    - add shop button node ---------|
    - add settings button node -----|
    - add main menu button node ----| 40 minutes total
    - add highest distcace label ---|
    - add current distance label ---|
    - add money counter label ------|
    - add "Pause" label ------------|
- Build Settings Scene: ---------------------------------------------------------------------------------| hour total
    - add game music label -----------------|
    - add sound effects label --------------|
    - add delete game results label --------|
    - add game music "on" switch node ------| 40 minutes
    - add game music "off" switch node -----| 
    - add sound effects "on" switch node ---|
    - add sound effects "off" switch node --|
    - add delete game results button node --|
    - add delete game results window node(set to hidden): -|
        - add question test label  (inside) ---------------|
        - add "ok" button node     (inside) ---------------| 20 minutes
        - add "cancel" button node (inside) ---------------|
    - add go back button node -----------------------------|
- Build Shop Scene: -------------------------------------------------------------------------------------| hour total
    - add shop background node ----|
    - add items icon nodes: -------|
        - oxygen chamber ----------|
        - diving suit -------------|
    - add "Buy" button nodes ------|
    - add price labels ------------|
    - add current index nodes -----| hour
    - add go back button node -----|
    - add setting button node -----|
    - add highest distance label --|
    - add current distance label --|
    - add money counter label -----|
    - add "Shop" lable ------------|
Wednesday: ----------------------------------------------------------------------------------------------| 7 hours overall
- Game Scene: -------------------------------------------------------------------------------------------| 4.5 hours total
    - add button actions: ---------------|
        - restart the scene -------------|
        - reconection to Pause scene ----|
        - deathWindow buttons: ----------| hour and a half
            - goes to main menu ---------|
            - restarts the game ---------|
            - goes to shop --------------|
            - goes to settings ----------|
    - add death action ----------------------|
    - add enum GameState --------------------|
    - add scrollWorld func ------------------| 1 hour
    - add spawn items and obstacles funcs ---| 
    - add touchesBegan override func --------|
    - add funcs for evry GameState: -----------------| 
        - for ".start" run counterStart function ----|
        - for ".playing" run game -------------------| hour and a half
        - for ".death" open deathWindow window ------|
        - for ".pause" stop all active actions ------|
    - add update scene func -----|
    - add money counter func ----| half an hour
- Main Menu: --------------------------------------------------------------------------------------------| 1 hour total comlplete
    - add all button actions: --------------| 
        - startArea starts the game --------|
        - settingsButton goes to settings --| 1 hour
        - shoopButton goes to shop ---------|
- Pause Scene: ------------------------------------------------------------------------------------------| 1.5 hour total comlplete
- add button actions: ---------------|
        - goes to main menu ---------|
        - restarts the game ---------|
        - goes to shop --------------|hour and a half
        - goes to settings ----------|
        - resumes the game ----------|
Thursday:
- Make all buttons in all scenes work(1 hour)comlplete
- Fix objective spawn (3 hours)comlplete
- Fix interaction of hero with other objects(3 hours)comlplete
Friday: 
- Still fixing the objective spawn, but also scrollWorld func(5 hours) almost
- Still work on interaction with objects(2 hours) comlplete
* [goals for the week]

#### Week 2
_finishing a playable build_
* [goals for the week, should be finishing a playable game]
Monday: 
- work on score labels(complete)
- add other objects to updateObstacles func(complete)
Tuesday:
- make itemSpawner function(complete) 
- make upgrade feature for shop scene()
Wednesday:
- return to previous page button(complete)
- keep working on itemSpawner(different reactions on every obstacle)(complete)
Thursday:
- make hero start swiming from shallow water(complete)2 hours
- bounceoff reaction on engine(almost)5 hours
Friday:
- polish everything upolished/undone
- the same score labels in different scenes should indicate the same score(complete)

#### Week 3
* [goals for the week, should be finishing all core gameplay]
Monday:
- particle effect of how much money you earned for particular item, when you collect it(complete)
Tuesday: 
- every 50m game speed increases(complete)
Wednesday:
Thursday:
Friday:
- add shop firebase
- shop power ups: fill the oxygen lvl to max, ivulnerable to all the stuns and roots for 5 sec.,
- every fourth ground texture will be a cave texture
- add fishing hook, description given in notes
- 

#### Week 4
_submitting to the App Store_
* [goals for the week, should be finishing the polish -- demo day on Saturday!]

[Back to top ^](#)
