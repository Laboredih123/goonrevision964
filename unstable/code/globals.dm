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
	savefile_ver = "Goon 2"
	SS13_version = "1.0 PR"
	datum/air_tunnel/air_tunnel1/SS13_airtunnel = null
	datum/control/cellular/cellcontrol = null
	datum/control/gameticker/ticker = null
	obj/datacore/data_core = null
	obj/overlay/plmaster = null
	obj/overlay/slmaster = null
	going = 1.0
	master_mode = "random"//"extended"

	persistent_file = "mode.txt"

	nuke_code = null
	poll_controller = null
	datum/engine_eject/engine_eject_control = null
	host = null
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

	CELLRATE = 0.002  // multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
	CHARGELEVEL = 0.001 // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)
	shuttle_z = 2
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

	datum/assembly/wirebundle/airlockbundle = new(9)

	const/shuttle_time_in_station = 1800 // 3 minutes in the station
	const/shuttle_time_to_arrive = 6000 // 10 minutes to arrive

	datum/dna/canonical/canonical_dna = new()

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


var/const
	CELLSTANDARD = 3600000.0		// gas capacity of cell at STP
	O2STANDARD = 756000.0			// O2 standard value (21%)
	N2STANDARD = 2844000.0			// N2 standard value (79%)

	T0C		= 273.15				// 0 deg C - frozen water
	T20C	= 293.15				// 20 deg C - normal temp
	TCMB	= 2.7					// -270 deg C - space temp

	FIREOFFSET = 505				//bias for starting firelevel
	FIREQUOT = 15000				//divisor to get target temp from firelevel
	FIRERATE = 5					//divisor of temp difference rate of change

	NORMPIPERATE = 40					//pipe-insulation rate divisor
	HEATPIPERATE = 8					//heat-exch pipe insulation

	FLOWFRAC = 0.99				// fraction of gas transfered per process


//FLAGS BITMASK
	ONBACK = 1			// can be put in back slot
	TABLEPASS = 1 << 1	// can pass by a table or rack
	HALFMASK = 1 << 2		// mask only gets 1/2 of air supply from internals

	HEADSPACE = 1 << 2	// head wear protects against space

	MASKINTERNALS = 1 << 3// mask allows internals
	SUITSPACE = 1 << 3	// suit protects against space

	USEDELAY = 1 << 4		// 1 second extra delay on use
	// 1 << 5 is an unused flag, because shields don't exist any more
	// 1 << 6 is an unused flag, because everything's drivable by a mass driver now
	// Don't reuse them until the flags are all cleaned up (using the #defined things rather than magic numbers)
	// because some things probably still have them set
	ONBELT = 1 << 7		// can be put in belt slot
	FPRINT = 1 << 8		// takes a fingerprint
	WINDOW = 1 << 9		// window or window/door
	GLASSESCOVERSEYES = 1 << 10 // glasses/masks/headwear covering certain parts of the face
	MASKCOVERSEYES = 1 << 10
	HEADCOVERSEYES = 1 << 10
	MASKCOVERSMOUTH = 1 << 11
	HEADCOVERSMOUTH = 1 << 11

	// for remote signallers
	SENDSRSIGNAL = 1 << 12

	// channel numbers for power

	EQUIP = 1
	LIGHT = 2
	ENVIRON = 3
	TOTAL = 4	//for total power used only

	// bitflags for machine stat variable
	BROKEN = 1
	NOPOWER = 1 << 1
	POWEROFF = 1 << 2	// tbd
	MAINT = 1 << 3	// under maintaince
	EMAGGED = 1 << 4 // is something (such as airlocks!) emagged?

	ENGINE_EJECT_Z = 2

	GAS_O2 = 1 << 0
	GAS_N2 = 1 << 1
	GAS_PL = 1 << 2
	GAS_CO2 = 1 << 3
	GAS_N2O = 1 << 4
