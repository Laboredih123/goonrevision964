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
	SS13_version = "40.93.2H9.5 - B12+Gibbed modified"
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
	abandon_allowed = 1
	enter_allowed = 1
	shuttle_frozen = 0
	prison_entered = null

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
	datum/configuration/config = null
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

	const/shuttle_time_in_station = 1800 // 3 minutes in the station
	const/shuttle_time_to_arrive = 6000 // 10 minutes to arrive

world
	name = "In Space No One Can Hear You Say No"
	mob = /mob/prespawn
	turf = /turf/space
	area = /area
	view = "15x15"
	hub = "Slurm.SpaceStation13"
	hub_password = ""

	//visibility = 0
	//loop_checks = 0
