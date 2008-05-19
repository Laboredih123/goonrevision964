/*  To-do list

	Bugs:
	hearing inside closets/pods
	check head protection when hit by tank etc.

	//gas propagation on obj/move cells? plasma doesn't leak.

	//turf-proc to reveal hidden (invis) pipes/wire/etc. when turf.intact variable is changed.
						 //(Check also build/remove for walls etc.)

	bug with two single-length pipes overlaying - pipeline ends up with no members

	//cable under wall/rwall when deconstructed - run levelupdate
	//making rglass with toolbox in r-hand - spawn on ground instead?
	//also single rod in hand, make it just use 1 of rod with 1 of glass

	//gas in heater loop - can accept infinite amount into canister
	//valves need power to switch, even manually
	//heater connection

	alarm continuing when power out?
	//can't connect new cable to directconnect power machines

	//cable - lay in dirn of mob facing when click on same turf

	New:

	//add/check all cameras & tags

	//prison warden gets grey jumpsuit

	//power/engine - make useful? Needs local power DU, check for all machines. Power reserve. Engine generator.
	make regular glass melt in fire
	Blood splatters, can sample DNA & analyze
	also blood stains on clothing - attacker & defender

	whole body anaylzer in medbay - shows damage areas in popup?

	//special closet for captain - spare ID, special uniform?

	try station map maximizing use of image rather than icon

	useful world/Topic commands
	//examine object flags

	flow rate maximum for pipes - slowest of two connected notes

	system for breaking / making pipes, handle deletion, pipeline spliting/rejoining etc.

	?give nominal values to all gas.maximum since turf_take depends on them

	//integrate vote system with admin system - allow admin to start vote even if disabled, etc.

	//update canister icons to use overlays for status
	//impliment other canister colours, e.g. air (O2+N2), new one for N2O

	//add pipe/cable revealing detector a-la infra-sensor

	//add fingerprints to wire/cable actions


	add power-off mode for computers & other equipment (with reboot time)

	make grilles conductive for shocks (again)

	for prison warden/sec - baton allows precise targeting

	//recharger for batteries

	//secret - spawn wave of meteors
	//limit rate of spawn (timer)

	portable generator - hook to wire system

	modular repair/construction system
	maintainance key
	diagnostic tool
	modules - module construction


	hats/caps
	//labcoat
	suit?
	//voting while dead, voting defaults

	//admin PM - able to reply - move to mob topic?

	build/unbuild engine floor with rf sheet

	finish compressor/turbine - think about control system, throttle, etc.

	crowbar opens airlocks when no power

*/

var
	world_message = "Welcome to SS13!"
	savefile_ver = "3"
	SS13_version = "gibbed test #4, version #11"
	changes = {"<FONT color='blue'><B>Changes from base version 40.93.2</B></FONT><BR>
<HR>

<p><b>Gibbed's changes #4 - TEST VERSION #11 5/5/2008</b><br>
<ul>
<li>Added support for querying of server information remotely.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #10 5/5/2008</b><br>
<ul>
<li>Added support for querying of server information remotely.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #9 5/4/2008</b><br>
<ul>
<li>Removed remote reboot exploit (<a target="_blank" href="http://svn.slurm.us/public/spacestation13/misc/remotess13/">thanks Exadv1!</a>)</li>
<li>Added configuration option for allowing respawn (and now it is off by default).</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #8 5/3/2008</b><br>
<ul>
<li>Removed all blindfolds.</li>
<li>Reduced the amount of handcuffs on the station.</li>
<li>Added another slot for security officer.</li>
<li>Staff Assistant now starts with a 3-0-0-0 card instead of 2-0-0-0.</li>
<li>Gasmask screen effect is now removed when you die.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #7 4/27/2008</b><br>
<ul>
<li>Added inner cameras to the AI satellite.</li>
<li>Added APC to the external turret area of the AI satellite.</li>
<li>Added turret controls to the external turret area of the AI satellite.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #6 4/27/2008</b><br>
<ul>
<li>Updated graphic for the floor in the chapel.</li>
<li>Fixed several APCs that were not properly hooked up to power systems.</li>
<li>Fixed the north solar array so that the battery could not feed power from the main system.</li>
<li>Fixed the APCs for north and south solar array.</li>
<li>Moved the AI Upload Foyer onto its own power network using its own solar array.</li>
<li>Widened the south hallway.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #5 4/27/2008</b><br>
<ul>
<li>New graphic for the floor in the chapel thanks to NuclearMailman.</li>
<li>Redid escape pod and recon pod code so that they share code.</li>
<li>Escape pods can no longer rotate, except the one in the pod repair bay.</li>
<li>Syndicate station now has recon pods instead of escape pods.</li>
<li>Syndicate station now has syndicate personal lockers instead of everything being on the ground.</li>
<li>Syndicate station now starts with some breach bombs during nuclear mode.</li>
<li>Instead of standard blank id cards, syndicate personal lockers spawn syndicate cards which block AI tracking.</li>
<li>Fixed up the handling of warping between maps, this means you should no longer end up fucked from traveling too far to the west.</li>
<li>Fixed an issue with the double airlocks unwelding a welded airlock when the other opens.</li>
<li>AI's Track With Camera and Observe should now properly handle duplicate names and names with invalid characters in them.</li>
<li>Nuked all verb admin commands except for variables and show_ctf.</li>
<li>Administrator panel is now enabled for the host of a game (instead of those stupid fucking verbs).</li>
<li>Added Who command.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #4 4/27/2008</b><br>
<ul>
<li>Fixed exploit with rechargers charging tasers to 10 charges.</li>
<li>Added hologram generators that the AI can control to a few places around the station.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #3 4/27/2008</b><br>
<ul>
<li>AI's #2 radio microphone now defaults to being on.</li>
<li>Fixed an issue where the captain could be assigned to another job.</li>
<li>The airlocks for the shuttle bay and shuttle docking arm are no longer infinitely powered.</li>
<li>Fixed the nuke deployable verb not showing up.</li>
<li>For most double airlocks, opening one will cause the other to close automatically before opening (if it can).</li>
<li>New coffin graphic thanks to NuclearMailman</li>
<li>Small changes to closet code so it properly handles opened/closed graphics.</li>
<li>Fixed the pod repair bay not allowing the pod in it to move.</li>
<li>Reduced Athmospheric Technician to 2 slots (was 4).</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #2 4/26/2008</b><br>
<ul>
<li>Went through and all exterior floor tiles so they start out with no oxygen, these can be identified by the fact that their name starts with 'airless'. If you spot any exterior floor tiles that are not airless by default please let me know so I can fix it.</li>
<li>APCs can now be cut with wirecutters (only while open!) to disable AI control of the APC. I plan to add a hack type deal (like airlock doors) into them later.</li>
<li>Fixed the chapel pod door controls (oops).</li>
<li>Blob mode: removed some blob spawn points that might cause it to die pretty much instantly.</li>
</ul>

<p><b>Gibbed's changes #4 - TEST VERSION #1 4/25/2008</b><br>
<ul>
<li>Anesthetic tanks now default to a rate of 250.</li>
<li>Blob mode: blob in a tile with plasma is inhibited from propogating to surrounding tiles.</li>
<li>Oxygen tank capacity has been reduced (roughly halved). Too much? let me know!</li>
<li>Removed insulated gloves from athmospherics and added a glove to engine control.</li>
<li>Taser charges reduced to 3.</li>
<li>The map size has been expanded to 140x140 (was 100x100).</li>
<li>The many engine areas have been moved around and reorganized.</li>
<li>The airlock between medbay and engine has been broken up into two airlocks that have some distance between them. This means to get to the engine from the medbay you now have to spacewalk.</li>
<li>The teleporter room has been moved to the south part of the station.</li>
<li>Small aesthetical changes to the medbay and medlab.</li>
<li>Redid chapel entrance.</li>
<li>Northeast solar panel array has been redone. Note that it is damaged by default and will need to be repaired to be usable.</li>
<li>Northeast solar panel control room has been redone.</li>
<li>Auxillary engine has been moved to north of the northeast solar panel control room.</li>
</ul>

<p><b>Gibbed's changes #3 4/24/2008</b>
<ul>
<li>Blob mode: when you are dead you no longer receive the 'The blob attacks you!' message.</li>
<li>Blob mode: blob should no longer expand to air tunnel / shuttle tiles.</li>
<li>Blob mode: blob should no longer propogate into space.</li>
<li>New toxin researcher locker.</li>
<li>Default anesthetic mix changed.</li>
<li>Added a security camera to the Toxin Research Lab Test Room.</li>
</ul>

<p><b>Gibbed's changes #2 4/24/2008</b>
<ul>
<li>Syndicate radio will now spawn in the users backpack if they started with one.</li>
<li>Syndicate radio will now self-destruct in 10 seconds rather than 3.</li>
<li>New traitor objective: eject engine.</li>
<li>Added OxygenIsToxicToHumans AI module, it can be obtained through a syndicate radio.</li>
<li>Decreased size of morgue and increased size of coffin storage.</li>
<li>Changed some engine walls to rwall and lined the interior of the engine with glass.</li>
<li>Fixed a small harmless bug with job picking code that was preventing selection of assistant jobs.</li>
</ul>

<p><b>Gibbed's changes #1 4/24/2008</b>
<ul>
<li>Prison (and prison jobs) removed.</li>
<li>Athmospheric Technician job slots increased to 4 (was 1).</li>
<li>'Super battery cell' used for AI Upload foyer energy decreased to 2500 (was 5000).</li>
<li>Command Station has been reduced to a Supply Station.</li>
<li>AI Station has been redone.</li>
<li>AI Upload area in Space Station 13 has been redone.</li>
<li>Job picking code for game starting rewritten, should stop crashouts that prevent people from spawning properly.</li>
<li>Removed blob debug messages (this might make blob playable).</li>
<li>AI can now hop to other cameras by clicking them.</li>
<li>Camera lists (for AI, security console) now get sorted.</li>
<li>Getting spaced on new game should no longer happen.</li>
<li>Main solar panel array for Space Station 13 was redone.</li>
<li>Minor tweaks to teleporter room.</li>
<li>Fixed issue where if you are naked when the game starts you don't get your ID.</li>
<li>Character setup no longer opens by default if you have saved data.</li>
</ul>"}
	datum/air_tunnel/air_tunnel1/SS13_airtunnel = null
	datum/control/cellular/cellcontrol = null
	datum/control/gameticker/ticker = null
	obj/datacore/data_core = null
	obj/overlay/plmaster = null
	obj/overlay/slmaster = null
	going = 1.0
	master_mode = "random"//"extended"

	persistent_file = "mode.txt"

	obj/ctf_assist/ctf = null
	nuke_code = null
	poll_controller = null
	datum/engine_eject/engine_eject_control = null
	host = null
	obj/hud/main_hud1 = null
	obj/hud/hud2/main_hud2 = null
	ooc_allowed = 1
	dna_ident = 1
	enter_allowed = 1
	shuttle_frozen = 0
	prison_entered = null

	list/html_colours = new/list(0)
	list/occupations = list(
		"Engineer", "Engineer",
		"Security Officer", "Security Officer", "Security Officer",
		"Forensic Technician",
		"Medical Researcher",
		"Research Technician",
		"Toxin Researcher",
		"Atmospheric Technician", "Atmospheric Technician",
		"Medical Doctor",
		"Station Technician",
		"Head of Personnel",
		"Head of Research",
		/*
		"Prison Security", "Prison Security",
		"Prison Doctor",
		"Prison Warden",
		*/
		"AI")
	list/assistant_occupations = list(
		"Technical Assistant",
		"Medical Assistant",
		"Research Assistant",
		"Staff Assistant")
	list/ai_names = list(
		"Asimov",
		"Hadaly",
		"Robbie",
		"Speedy",
		"Cutie",
		"L-76",
		"Z-1",
		"Z-2",
		"Z-3",
		"Emma-2",
		"Brackenridge",
		"Ez-27",
		"Norby",
		"Gort",
		"Gnut",
		"Irona",
		"Uniblab",
		"S.H.R.O.U.D.",
		"S.H.O.C.K.",
		"Frost",
		"Trurl",
		"Klapaucius",
		"Android",
		"H.A.R.L.I.E.",
		"Setaur",
		"Aniel",
		"Terminus",
		"R2-D2",
		"C-3PO",
		"Fembot",
		"Marvin",
		"Tidy",
		"George",
		"Fagor",
		"Surgeon General Kraken",
		"Chip",
		"Data",
		"Solo",
		"L-Ron",
		"Johnny 5",
		"Kryten 2X4B-523P",
		"Yod",
		"Jay-Dub",
		"Dee Model",
		"ULTRABOT",
		"Dorfl",
		"Robot",
		"Erasmus",
		"Shrike",
		"Maria",
		"Futura",
		"Ro-Man",
		"Tobor",
		"B-9",
		"Mechani-Kong",
		"HAL 9000",
		"Robot 5",
		"Huey",
		"Duey",
		"Louie",
		"THX 1138",
		"LUH 3417",
		"SEN 5241",
		"PTO",
		"TWA",
		"NCH",
		"OMM 0910",
		"Box",
		"Necron-99",
		"Mechagodzilla",
		"V.I.N.CENT.",
		"B.O.B.",
		"Maximillian",
		"Max 404",
		"Cassandra One",
		"T-800",
		"Bishop",
		"Tik-Tok",
		"ED-209",
		"Cherry 2000",
		"Ulysses",
		"Dot Matrix",
		"Astor",
		"Jinx",
		"Robotman",
		"MARK13",
		"Project 2501",
		"SID 6.7",
		"AMEE",
		"R4-P17",
		"T-850",
		"T-1000",
		"G2",
		"B166ER",
		"B-4",
		"E.D.I.",
		"Dor-15",
		"Zed",
		"S.A.M.",
		"Voltes V",
		"Mr. R.I.N.G.",
		"Fi",
		"Fum",
		"K-9",
		"7-Zark-7",
		"1-Rover-1",
		"H.E.R.B.I.E.",
		"W1k1",
		"KITT",
		"Metalhead",
		"Conky 2000",
		"Blitz",
		"ASTAR",
		"16-20",
		"Super 17",
		"Cell",
		"Alpha 5",
		"Alpha 6",
		"790",
		"Zord",
		"Robot Devil",
		"Bender",
		"Alpha 7",
		"XR",
		"Chii",
		"H.E.L.P.eR.",
		"R.I.C. 2.0",
		"S.O.P.H.I.E.",
		"X-5",
		"Master Control Program",
		"SHODAN",
		"XERXES",
		"Computer",
		"FRIEND COMPUTER",
		"Orange v 3.5",
		"Revelation",
		"Faith",
		"Wikipedia",
		"AM",
		"Allied Mastercomputer",
		"Adaptive Manipulator",
		"AmigoBot")
	list/bombers = list(  )
	list/admins = list(  )
	list/shuttles = list(  )
	list/reg_dna = list(  )
	list/banned = list(  )


        //
	shuttle_z = 10	//default
	airtunnel_start = 68 // default
	airtunnel_stop = 68 // default
	airtunnel_bottom = 72 // default
	list/monkeystart = list()
	list/blobstart = list()
	list/blobs = list()
	list/cardinal = list( NORTH, SOUTH, EAST, WEST )


	datum/station_state/start_state = null
	datum/config/config = null
	datum/vote/vote = null
	datum/sun/sun = null

	list/plines = list()
	list/gasflowlist = list()
	list/machines = list()

	list/powernets = null

	defer_powernet_rebuild = 0		// true if net rebuild will be called manually after an event

	Debug = 0	// global debug switch

	datum/debug/debugobj

	datum/moduletypes/mods = new()

	wavesecret = 0

	//airlockWireColorToIndex takes a number representing the wire color, e.g. the orange wire is always 1, the dark red wire is always 2, etc. It returns the index for whatever that wire does.
	//airlockIndexToWireColor does the opposite thing - it takes the index for what the wire does, for example AIRLOCK_WIRE_IDSCAN is 1, AIRLOCK_WIRE_POWER1 is 2, etc. It returns the wire color number.
	//airlockWireColorToFlag takes the wire color number and returns the flag for it (1, 2, 4, 8, 16, etc)
	list/airlockWireColorToFlag = RandomAirlockWires()
	list/airlockIndexToFlag
	list/airlockIndexToWireColor
	list/airlockWireColorToIndex
	list/airlockFeatureNames = list("IdScan", "Main power In", "Main power Out", "Drop door bolts", "Backup power In", "Backup power Out", "Power assist", "AI Control", "Electrify")

world
	mob = /mob/human
	turf = /turf/space
	area = /area
	view = "15x15"
	visibility = 0
	//loop_checks = 0
