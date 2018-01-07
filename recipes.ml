(******************************************************************************)
(* Copyright (c) 2016 DooMeeR                                                 *)
(*                                                                            *)
(* Permission is hereby granted, free of charge, to any person obtaining      *)
(* a copy of this software and associated documentation files (the            *)
(* "Software"), to deal in the Software without restriction, including        *)
(* without limitation the rights to use, copy, modify, merge, publish,        *)
(* distribute, sublicense, and/or sell copies of the Software, and to         *)
(* permit persons to whom the Software is furnished to do so, subject to      *)
(* the following conditions:                                                  *)
(*                                                                            *)
(* The above copyright notice and this permission notice shall be             *)
(* included in all copies or substantial portions of the Software.            *)
(*                                                                            *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,            *)
(* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF         *)
(* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                      *)
(* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE     *)
(* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION     *)
(* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION      *)
(* WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.            *)
(******************************************************************************)

(* Type definitions and helpful functions are defined in factorio.ml. *)
open Factorio

(******************************************************************************)
(*                                   Makers                                   *)
(******************************************************************************)

(* Maker definitions. Makers are items such as assembling machines,
   that are used to make recipes. *)

(* Usage: maker name crafting_speed *)

let burner_mining_drill = maker "Burner Mining Drill" 0.35    ~power: 2.5
let electric_mining_drill = maker "Electric Mining Drill" 0.5 ~power: 3.
let assembling_machine_1 = maker "Assembling Machine 1" 0.5
let assembling_machine_2 = maker "Assembling Machine 2" 0.75
let assembling_machine_3 = maker "Assembling Machine 3" 20.
let stone_furnace = maker "Stone Furnace" 1.
let steel_furnace = maker "Steel Furnace" 2.
let electric_furnace = maker "Electric Furnace" 32.
let chemical_plant_ = maker "Chemical Plant" 1.25
let chemical_plant_nanite = maker "Chemical Plant" 20.
let centrifuge = maker "Centrifuge" 0.75
let rocket_silo = maker "Rocket Silo" 0.001
let omnitractor_5_nanite = maker "Omnitractor 5 Nanite" 80.
let offshose_pump_ = maker "Offshore pump" 16.
let boiler_ = maker "Boiler" 16.
let boiler_nuclear_ = maker "Boiler Nuclear" 16.

(* Shorthands for some commonly-used lists of makers. *)

let drill = [ burner_mining_drill; electric_mining_drill ]
let am1 = [ assembling_machine_1; assembling_machine_2; assembling_machine_3 ]
let am2 = [ assembling_machine_2; assembling_machine_3 ]
let am3 = [ assembling_machine_3 ]
let furnace = [ stone_furnace; steel_furnace; electric_furnace ]
let chemical_plant = [ chemical_plant_ ]
let omnitractor = [ omnitractor_5_nanite ]
let offshore_pump = [ offshose_pump_ ]
let boiler = [ boiler_ ]
let boiler_nuclear = [ boiler_nuclear_ ]
let oil_processing = [ maker "Advanced oil processing" 1.]

(******************************************************************************)
(*                                  Resources                                 *)
(******************************************************************************)

(* Resource definitions. Resources are craftable items, such as potions.
   Note that makers themselves are craftable and are thus also resources. *)

(* Usage: res name makers crafting_time ingredients

   [makers] is a list of makers.
   [ingredients] is a list of (float, resource) pairs, where the float
   is the amount of the resource which is required.

   Optional arguments:
   - use [~style: Global] (without the brackets) so that
     the resource is global by default;
   - use [~count: 2.] for recipes which produce 2 items at a time. *)

(* DON'T FORGET TO ADD THE RESOURCE TO THE LIST AT THE END OF THIS FILE! *)

(* Coal is only counted to make Plastic Bars, not by Furnaces.
   You can change this by adding the Coal ingredient to the plate recipes. *)

(* I assume 1 Crude Oil per second per pumpjack, but obviously this changes
   all the time. *)

(* I assume Basic Oil Processing is used.
   You can change the line:
     let petroleum_gas = petroleum_gas_basic
   to one of:
     let petroleum_gas = petroleum_gas_advanced
     let petroleum_gas = petroleum_gas_cracking
   to change the oil+water to gas ratio.

   Basically:
   - with Basic Oil Processing, you need 2.5 Oil for 1 Gas;
   - with Advanced Oil Processing, you need 1.9 Oil (and 1 Water) for 1 Gas;
   - with Advanced Oil Processing + Cracking, you need 1.2 Oil (and 1.3 Water)
     for 1 Gas.
   So you can simply keep the Basic Oil Processing and know that the amount
   of oil can be divided by roughly 2 with Advanced Oil Processing and
   cracking. (Who cares about Water?)
   The amount of refineries is also devided by 2 but you need to add
   chemical plants (with 5 refineries you have a perfect ratio
   with 1 heavy cracking and 7 light cracking plants)
   and water pumps (1 pump for 6 groups of 5 refineries + 8 cracking plants). *)



(* Resources *)

let omnite =
  res "Omni ore" drill 1. ~hardness: 0.9
    []
let water =
  res "Water" offshore_pump 5. ~count: 1. ~style: Global
    []
(* derived resources *)

let coal =
  res "Coal" omnitractor 3750. ~count: 65. ~allow_productivity: true
    [6., omnite]
let iron_ore =
  res "Iron Ore" omnitractor 3750. ~count: 65. ~allow_productivity: true
    [6., omnite]
let copper_ore =
  res "Copper Ore" omnitractor 3750. ~count: 65. ~allow_productivity: true
    [6., omnite]
let stone =
  res "Stone" omnitractor 5000. ~count: 65. ~allow_productivity: true
    [6., omnite]

(* oil processing *)

let steam_basic =
  res "Steam" boiler 200. ~count: 1.
    [ 1., water ]
let steam_nuclear =
  res "Steam" boiler_nuclear 114.286 ~count: 1.
    [ 1., water ]
let steam = steam_nuclear
let omnite_crushed =
  res "Crushed omnite" chemical_plant 50. ~count: 2. ~allow_productivity: true
    [1., omnite]
let omnite_pulverized =
  res "Pulverized Omnite" chemical_plant 50. ~count: 3. ~allow_productivity: true
    [2., omnite_crushed]
let omnic_acid =
  res "Omnic Acid" chemical_plant 1000. ~count: 3.4 ~allow_productivity: true
    [12., omnite_crushed; 5., water; 5., steam]
let omniston =
  res "omniston" chemical_plant 3750. ~count: 5. ~allow_productivity: true
    [12., omnite_pulverized; 5., omnic_acid]
let crude_oil =
  res "Crude Oil" chemical_plant 250. ~count: 1. ~allow_productivity: true
    [1., omniston]

(* Intermediate Products *)

let iron_plate =
  res "Iron Plate" furnace 350. ~style: Global ~allow_productivity: true
    [ 2., iron_ore ]
let copper_plate =
  res "Copper Plate" furnace 350. ~style: Global ~allow_productivity: true
    [ 2., copper_ore ]
let steel_plate =
  res "Steel Plate" furnace 1750. ~allow_productivity: true
    [ 5., iron_plate ]
let stone_brick =
  res "Stone Brick" furnace 350. ~allow_productivity: true
    [ 4., stone ]
let petroleum_gas_basic =
  res "Petroleum Gas" [ maker "Basic Oil Processing" 1. ] 6000.
    ~count: 4. ~style: Global ~allow_productivity: true
    [ 10., crude_oil ]
let petroleum_gas_advanced =
  res "Petroleum Gas" oil_processing 12000.
    ~count: 12. ~style: Global ~allow_productivity: true
    [ 20., crude_oil; 10., water ]
let petroleum_gas_cracking =
  (* 1 Heavy Oil becomes 3/4 = 0.75 Light Oil.
     0.75 + 4.5 = 5.25 Light Oil becomes 5.25 * 2 / 3 = 3.5 Petroleum Gas.
     So the end result is 5.5 + 3.5 = 9 Petroleum Gas.
     1 Heavy Oil requires 0.75 Water to be cracked.
     5.25 Light Oil requires 5.25 Water to be cracked.
     So the end result is that 0.75 + 5.25 + 5 = 11 Water is required. *)
  res "Petroleum Gas" [ maker "Advanced Oil Processing + Cracking" 1. ] 30000.
    ~count: 90. ~style: Global ~allow_productivity: true
    [ 100., crude_oil; 110., water ]
let petroleum_gas = petroleum_gas_advanced
let sulfur =
  res "Sulfur" chemical_plant 400. ~count: 16. ~allow_productivity: true
    [ 1., water; 1., petroleum_gas ]
let sulfuric_acid =
  res "Sulfuric Acid" chemical_plant 1200. ~count: 5. ~allow_productivity: true
    [ 12., iron_plate; 120., sulfur; 10., water ]
let plastic_bar =
  res "Plastic Bar" chemical_plant 600. ~count: 12. ~allow_productivity: true
    [ 12., coal; 1., petroleum_gas ]
let battery =
  res "Battery" chemical_plant 3000. ~count: 3. ~allow_productivity: true
    [ 6., iron_plate; 6., copper_plate; 1., sulfuric_acid ]
let iron_gear_wheel =
  res "Iron Gear Wheel" am1 50. ~allow_productivity: true
    [ 2., iron_plate ]
let copper_cable =
  res "Copper Cable" am1 50. ~count: 1. ~allow_productivity: true
    [ 1., copper_plate ]
let electronic_circuit =
  res "Electronic Circuit" am1 50. ~allow_productivity: true
    [ 2., iron_plate; 3., copper_cable ]
let advanced_circuit =
  res "Advanced Circuit" am2 1200. ~allow_productivity: true
    [ 2., electronic_circuit; 4., plastic_bar; 4., copper_cable ]
let processing_unit =
  res "Processing Unit" am2 20000. ~allow_productivity: true
    [ 200., electronic_circuit; 20., advanced_circuit; 1., sulfuric_acid ]
let pipe =
  res "Pipe" am1 50.
    [ 1., iron_plate ]
let engine_unit =
  res "Engine Unit" am2 1000. ~count: 2. ~allow_productivity: true
    [ 1., steel_plate; 1., iron_gear_wheel; 2., pipe ]
let heavy_oil =
  res "Heavy Oil" oil_processing 12000.
    ~count: 2. ~style: Global ~allow_productivity: true
    [ 20., crude_oil; 10., water ]
let light_oil =
  res "Light Oil" oil_processing 12000.
    ~count: 9. ~style: Global ~allow_productivity: true
    [ 20., crude_oil; 10., water ]
let lubricant =
  res "Lubricant" chemical_plant 1200. ~count: 1. ~allow_productivity: true
    [ 1., heavy_oil ]
let electric_engine_unit =
  res "Electric Engine Unit" am2 8000. ~count: 16. ~allow_productivity: true
    [ 16., engine_unit; 8., electronic_circuit; 1., lubricant ]
let transport_belt =
  res "Transport Belt" am1 50. ~count: 2.
    [ 1., iron_plate; 1., iron_gear_wheel ]
let inserter =
  res "Inserter" am2 100.
    [ 2., iron_plate; 2., iron_gear_wheel; 1., electronic_circuit ]

(* Weapons *)

let grenade =
  res "Grenade" am1 800.
    [ 20., coal; 5., iron_plate ]

(* Ammo *)

let firearm_magazine =
  res "Firearm Magazine" am1 200.
    [ 8., iron_plate ]
let piercing_rounds_magazine =
  res "Piercing Rounds Magazine" am1 600.
    [ 1., firearm_magazine; 2., steel_plate; 10., copper_plate ]

(* Modules *)

let efficiency_module =
  res "Efficiency Module" am2 3000. ~count: 4.
    [ 5., advanced_circuit; 5., electronic_circuit ]
let efficiency_module_2 =
  res "Efficiency Module 2" am2 6000. ~count: 4.
    [ 5., advanced_circuit; 10., processing_unit; 16., efficiency_module ]
let efficiency_module_3 =
  res "Efficiency Module 3" am2 12000. ~count: 4.
    [ 5., advanced_circuit; 10., processing_unit; 20., efficiency_module_2 ]
let productivity_module =
  res "Productivity Module" am2 3000. ~count: 4.
    [ 5., advanced_circuit; 5., electronic_circuit ]
let productivity_module_2 =
  res "Productivity Module 2" am2 6000. ~count: 4.
    [ 5., advanced_circuit; 10., processing_unit; 16., productivity_module ]
let productivity_module_3 =
  res "Productivity Module 3" am2 12000. ~count: 4.
    [ 5., advanced_circuit; 10., processing_unit; 20., productivity_module_2 ]
let speed_module =
  res "Speed Module" am2 3000.
    [ 5., advanced_circuit; 5., electronic_circuit ]
let speed_module_2 =
  res "Speed Module 2" am2 6000. ~count: 4.
    [ 5., advanced_circuit; 10., processing_unit; 16., speed_module ]
let speed_module_3 =
  res "Speed Module 3" am2 12000. ~count: 4.
    [ 5., advanced_circuit; 10., processing_unit; 20., speed_module_2 ]

(* Defensive Structures *)

let gun_turret =
  res "Gun Turret" am2 400.
    [ 10., iron_plate; 5., copper_plate; 5., iron_gear_wheel ]
let radar =
  res "Radar" am2 100. ~count: 4.
    [ 5., electronic_circuit; 10., iron_gear_wheel; 20., iron_plate ]


(* Machines & Furnaces *)

(* Because makers exist with the same name, makers as resources are
   prefixed with "r_". *)
let r_electric_mining_drill =
  res "Electric Mining Drill" am2 400. ~count: 4.
    [ 20., iron_plate; 10., iron_gear_wheel; 3., electronic_circuit ]
let r_electric_furnace =
  res "Electric Furnace" am2 1000. ~count: 4.
    [ 20., steel_plate; 20., stone_brick; 5., advanced_circuit ]

(* Electric Network *)

let solar_panel =
  res "Solar Panel" am2 2000. ~count: 4.
    [ 10., steel_plate; 15., electronic_circuit; 10., copper_plate ]
let accumulator =
  res "Accumulator" am1 2000. ~count: 4.
    [ 4., iron_plate; 5., battery ]


(* Rocket Compenents *)

let low_density_structure =
  res "Low Density Structure" am2 600. ~count: 2. ~allow_productivity: true
    [ 2., steel_plate; 1., copper_plate; 1., plastic_bar ]
let rocket_control_unit =
  res "Rocket Control Unit" am1 3000. ~count: 10. ~allow_productivity: true
    [ 1., processing_unit; 2., speed_module ]
let solid_fuel_from_light_oil =
  res "Solid Fuel" chemical_plant 3600. ~count: 24. ~allow_productivity: true
    [ 1., light_oil ]
let solid_fuel = solid_fuel_from_light_oil
let rocket_fuel =
  res "Rocket Fuel" am1 300. ~allow_productivity: true
    [ 2., solid_fuel ]
let rocket_part =
  res "Rocket Part" [ maker "Rocket Silo" 1. ] 3. ~allow_productivity: true
    [ 1., low_density_structure; 1., rocket_fuel; 1., rocket_control_unit ]
let satellite =
  res "Satellite" am3 5.
    [ 10., low_density_structure; 2., solar_panel; 2., accumulator;
      5., radar; 1., processing_unit; 5., rocket_fuel ]


(* Science packs *)
let science_pack_1 =
  res "Science Pack 1" am1 1000. ~allow_productivity: true
    [ 2., copper_plate; 2., iron_gear_wheel ]
let science_pack_2 =
  res "Science Pack 2" am1 1200. ~allow_productivity: true
    [ 4., inserter; 2., transport_belt ]
let science_pack_3 =
  res "Science Pack 3" am2 2400. ~allow_productivity: true
    [ 1., advanced_circuit; 3., engine_unit; 4., r_electric_mining_drill ]
let military_science_pack =
  res "Military science pack" am2 2000. ~count: 2. ~allow_productivity: true
    [ 1., piercing_rounds_magazine; 2., grenade; 4., gun_turret ]
let production_science_pack =
  res "Production science pack" am2 1400. ~count: 1. ~allow_productivity: true
    [ 2., electric_engine_unit; 2., r_electric_furnace ]
let high_tech_science_pack =
  res "High tech science pack" am2 2800. ~count: 2. ~allow_productivity: true
    [ 1., battery; 6., processing_unit; 4., speed_module; 30., copper_cable ]
let space_science_pack =
  (* TODO: we could replace the 1. by the time it takes to launch a rocket. *)
  res "Space Science Pack" [ rocket_silo ] 1. ~count: 1000.
    [ 100., rocket_part; 1., satellite ]

(******************************************************************************)
(*                              List of Resources                             *)
(******************************************************************************)

(* These are the resources that appear in the user interface. *)

let resources =
  [
    (* Resources *)
    omnite;
    water;
    (* Derived resources *)
    coal;
    iron_ore;
    copper_ore;
    stone;
    
    (* oil processing *)
    omnite_crushed;
    omnite_pulverized;
    omnic_acid;
    omniston;
    crude_oil;

    (* Intermediate Products *)
    steam;
    iron_plate;
    copper_plate;
    steel_plate;
    stone_brick;
    sulfur;
    plastic_bar;
    battery;
    iron_gear_wheel;
    copper_cable;
    electronic_circuit;
    advanced_circuit;
    processing_unit;
    pipe;
    engine_unit;
    electric_engine_unit;

    (* science packs *)
    science_pack_1;
    science_pack_2;
    science_pack_3;
    military_science_pack;
    production_science_pack;
    high_tech_science_pack;
    space_science_pack;

    (* Chemicals *)
    petroleum_gas;
    light_oil;
    heavy_oil;
    sulfuric_acid;
    lubricant;

    grenade;

    (* Ammo *)
    firearm_magazine;
    piercing_rounds_magazine;


    (* Modules *)
    efficiency_module;
    efficiency_module_2;
    efficiency_module_3;
    productivity_module;
    productivity_module_2;
    productivity_module_3;
    speed_module;
    speed_module_2;
    speed_module_3;

    (* Special *)
    solid_fuel;

    (* Transport Belts *)
    transport_belt;

    (* Inserters *)
    inserter;


    (* Defensive Structures *)
    gun_turret;

    (* Machines & Furnaces *)
    r_electric_mining_drill;
    r_electric_furnace;
    radar;

    (* Electric Network *)
    solar_panel;
    accumulator;

    (* Rocket Components *)
    low_density_structure;
    rocket_fuel;
    rocket_part;
    rocket_control_unit;
    satellite;
  ]
