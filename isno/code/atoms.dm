#include "data\stylesheet.dm"

/atom
	layer = 2
	var/level = 2
	var/flags = FPRINT
	var/list/fingerprints = null
	var/is_ai_interactable = 0

/atom/movable
	layer = 3
	var/last_move = null
	var/anchored = 0
	var/weight = 25000
	var/elevation = 2
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = 0
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0

/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/proc/burn(fi_amount)
	return

/atom/movable/Move()
	var/atom/A = src.loc
	. = ..()
	src.move_speed = world.time - src.l_move_time
	src.l_move_time = world.time
	src.m_flag = 1
	if((A != src.loc && A && A.z == src.z))
		src.last_move = get_dir(A, src.loc)
		src.moved_recently = 1
	return

/atom/movable/Move(NewLoc, direct)

	if(!(direct & direct - 1))
		return ..()

	if(direct & NORTH)
		if(step(src,NORTH))
			if(direct & EAST)
				step(src,EAST)
			if(direct & WEST)
				step(src,WEST)
			return 1

	if(direct & SOUTH)
		if(step(src,SOUTH))
			if(direct & EAST)
				step(src,EAST)
			if(direct & WEST)
				step(src,WEST)
			return 1

	if(direct & EAST)
		if(step(src,EAST))
			if(direct & NORTH)
				step(src,NORTH)
			if(direct & SOUTH)
				step(src,SOUTH)
			return 1

	if(direct & WEST)
		if(step(src,WEST))
			if(direct & NORTH)
				step(src,NORTH)
			if(direct & SOUTH)
				step(src,SOUTH)
			return 1
	return 0

/atom/movable/verb/pull()
	set src in oview(1)

	if (!( usr ))
		return
	if (!( src.anchored ))
		usr.pulling = src
	return

/atom/verb/examine()
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return
	usr << src.desc
	// *****RM
	//usr << "[src.name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

/datum/air_tunnel
	//name = "air tunnel"
	var/operating = 0
	var/siphon_status = 0
	var/air_stat = 0
	var/list/connectors = list()

/datum/air_tunnel/air_tunnel1
	//name = "air tunnel1"

/datum/control
	//name = "control"
	var/processing = 1.0

/datum/control/cellular
	//name = "cellular"
	var/checkfire = 0.0
	var/var_swap = 1.0
	var/time = 0

/datum/control/gameticker
	var/datum/game_mode/mode = null
	var/event_time = null
	var/event = 0

/datum/control/poll
	//name = "poll"
	var/question = null

	var/list/answers = list(  )

/datum/data
	var/name = "data"
	var/size = 1.0
	//name = null
/datum/data/function
	name = "function"
	size = 2.0
/datum/data/function/data_control
	name = "data control"
/datum/data/function/id_changer
	name = "id changer"
/datum/data/record
	name = "record"
	size = 5.0

	var/list/fields = list(  )

/datum/data/text
	name = "text"
	var/data = null
/datum/engine_eject
	//name = "engine eject"
	var/status = 0.0
	var/resetting = null
	var/timeleft = 60.0

/datum/station_state
	var/floor = 0
	var/wall = 0
	var/r_wall = 0
	var/window = 0
	var/door = 0
	var/grille = 0
	var/mach = 0

/datum/substance/gas
	var/temp = T20C
	var/nitrogen = 0.0
	var/oxygen = 0.0
	var/plasma = 0.0
	var/no2	= 0.0
	var/co2	= 0.0
	var/maximum = -1.0

/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all APCs & sources
	var/newload = 0
	var/load = 0
	var/newavail = 0
	var/avail = 0

	var/viewload = 0

	var/number = 0

	var/perapc = 0			// per-apc avilability

	var/netexcess = 0

/datum/debug
	var/list/debuglist

/obj
	var/datum/module/mod

/obj/mark
		var/mark = ""
		icon = 'mark.dmi'
		icon_state = "blank"
		anchored = 1
		layer = 99
		mouse_opacity = 0


/obj/blob
		icon = 'blob.dmi'
		icon_state = "bloba0"
		var/health = 30
		var/attempt = 0
		var/idle = 0
		density = 1
		opacity = 0
		anchored = 1

/obj/barrier
	name = "barrier"
	icon = 'stationobjs.dmi'
	icon_state = "barrier"
	opacity = 1
	density = 1
	anchored = 1.0
/obj/beam
	name = "beam"
	flags = TABLEPASS|GLASSPASS
/obj/beam/a_laser
	name = "a laser"
	icon = 'weap_sat.dmi'
	icon_state = "laser"
	density = 1
	var/yo = null
	var/xo = null
	var/current = null
	var/life = 50.0
	anchored = 1
/obj/beam/a_laser/s_laser
	name = "s laser"
	icon_state = "spark"
	flags = TABLEPASS // this should not pass through glass
/obj/beam/i_beam
	name = "i beam"
	icon = 'weap_sat.dmi'
	icon_state = "laser"
	var/obj/beam/i_beam/next = null
	var/obj/item/weapon/infra/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	anchored = 1
/obj/bedsheetbin
	name = "Linen Bin"
	desc = "A bin for containing bedsheets."
	icon = 'icons.dmi'
	icon_state = "bedbin"
	var/amount = 23.0
	anchored = 1.0
/obj/begin
	name = "begin"
	icon = 'stationobjs.dmi'
	icon_state = "begin"
	anchored = 1.0
/obj/bullet
	name = "bullet"
	icon = 'weap_sat.dmi'
	icon_state = "bullet"
	density = 1
	var/yo = null
	var/xo = null
	var/current = null
	anchored = 1.0
	flags = 2.0

/obj/d_girders
	name = "Displaced girders"
	icon = 'stationobjs.dmi'
	icon_state = "d_girders"
	density = 1
	anchored = 0.0
	weight = 1.0E8
/obj/datacore
	name = "datacore"

	var/list/medical = list(  )
	var/list/general = list(  )
	var/list/security = list(  )

/obj/effects
	name = "effects"
	mouse_opacity = 0
	flags = 2
/obj/effects/smoke
	name = "smoke"
	icon = 'water.dmi'
	icon_state = "smoke"
	opacity = 1
	var/amount = 6.0
	anchored = 0.0
/obj/effects/sparks
	name = "sparks"
	icon = 'water.dmi'
	icon_state = "sparks"
	var/amount = 6.0
	anchored = 0.0
	mouse_opacity = 0
/obj/effects/sparks/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = 1.0
/obj/effects/water
	name = "water"
	icon = 'water.dmi'
	icon_state = "extinguish"
	var/life = 15.0
	flags = 2.0
	mouse_opacity = 0
/obj/equip_e
	name = "carbon-based life form"
	var/mob/carbon/source = null
	var/s_loc = null
	var/t_loc = null
	var/obj/item/item = null
	var/place = null
	var/mob/carbon/target = null
/obj/grille
	desc = "A piece of metal with evenly spaced gridlike holes in it. Blocks large object but lets small items, gas, or energy beams through."
	name = "grille"
	icon = 'turfs2.dmi'
	icon_state = "grille"
	density = 1
	var/health = 10.0
	var/destroyed = 0.0
	anchored = 1.0
	flags = FPRINT
	weight = 500000	// added
/obj/securearea
	desc = "A warning sign which reads 'SECURE AREA'"
	name = "SECURE AREA"
	icon = 'icons.dmi'
	icon_state = "securearea"
	anchored = 1.0
	opacity = 0
	density = 0
/obj/item
	name = "item"
	var/w_class = 3.0
/obj/item/weapon
	name = "weapon"
	icon = 'items.dmi'
	var/abstract = 0.0
	var/force = null
	var/s_istate = null
	var/damtype = "brute"
	var/throwforce = null
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	flags = 258.0
	weight = 500000.0
/obj/item/weapon/ammo
	name = "ammo"
	icon = 'ammo.dmi'
	var/amount_left = 0.0
	flags = 322.0
	s_istate = "syringe_kit"
/obj/item/weapon/ammo/a357
	desc = "There are 7 bullets left!"
	name = "ammo-357"
	icon_state = "357-7"
	amount_left = 7.0
/obj/item/weapon/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "analyzer"
	icon_state = "analyzer"
	w_class = 2.0
	flags = 322.0

/obj/item/weapon/shock_kit
	name = "Shock Kit"
	icon = 'assemblies.dmi'
	icon_state = "shock_kit"
	var/obj/item/weapon/clothing/head/helmet = null
	var/obj/item/weapon/radio/electropack/electropack = null
	var/status = 0
	w_class = 5
	flags = 322
	var/obj/stool/chair/e_chair/chair = null

/obj/item/weapon/baton
	name = "Stun Baton"
	desc = "A stun baton for hitting people with."
	icon = 'stun_baton.dmi'
	icon_state = "baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 15
	throwforce = 7
	w_class = 3

/obj/item/weapon/bedsheet
	name = "bedsheet"
	icon = 'icons.dmi'
	icon_state = "sheet"
	layer = 4.0
	s_istate = "w_suit"
/obj/item/weapon/bottle
	name = "bottle"
	var/obj/substance/chemical/chem = null
	throw_speed = 4
	throw_range = 20
	w_class = 1.0
/obj/item/weapon/bottle/antitoxins
	name = "antitoxins"
	icon_state = "atoxinbottle"
/obj/item/weapon/bottle/r_ch_cough
	name = "Cough remedy"
	icon_state = "medibottle"
/obj/item/weapon/bottle/r_epil
	name = "Epileptic Remedy"
	icon_state = "medibottle"
/obj/item/weapon/bottle/rejuvenators
	name = "rejuvenators"
	icon_state = "rejuvbottle"
/obj/item/weapon/bottle/s_tox
	name = "sleep toxins"
	icon_state = "toxinbottle"
/obj/item/weapon/bottle/toxins
	name = "toxins"
	icon_state = "toxinbottle"
/obj/item/weapon/brutepack
	name = "Bruise Pack"
	desc = "A pack designed to treat blunt-force trauma."
	icon_state = "brutepack"
	var/amount = 5.0
	w_class = 1.0
	throw_speed = 4
	throw_range = 20
/obj/item/weapon/c_tube
	name = "Cardboard tube"
	icon_state = "c_tube"
/obj/item/weapon/camera
	name = "camera"
	icon_state = "camera"
	var/last_pic = 1.0
	s_istate = "wrench"
	w_class = 2.0
/obj/item/weapon/card
	name = "card"
	w_class = 1.0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "Data Disk"
	icon_state = "card-data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	s_istate = "card-id"
/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "emag"
	icon_state = "emag-card"
	s_istate = "card-id"
/obj/item/weapon/card/id
	name = "Identification Card"
	icon_state = "card-id"
	var/access = list()
	var/registered = null
	var/assignment = null
/obj/item/weapon/card/id/syndicate
	name = "Syndicate Card"

/obj/item/weapon/card/id/captains_spare
	name = "Captain's spare ID"
	icon_state = "card-id"
	registered = "Captain"
	assignment = "Captain"
	New()
		access = get_all_accesses()
		..()
/obj/item/weapon/clipboard
	name = "clipboard"
	icon_state = "clipboard00"
	var/obj/item/weapon/pen/pen = null
	s_istate = "clipboard"
/obj/item/weapon/cloaking_device
	name = "cloaking device"
	icon_state = "shield0"
	var/active = 0.0
	flags = 322.0
	s_istate = "electronic"
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	var/obj/item/weapon/cell/cell = new(null, 100)

/obj/item/weapon/clothing
	name = "clothing"
	var/clothing_name = "clothing"
	var/a_filter = 0.0
	var/fb_filter = 0.0
	var/h_filter = 0.0
	var/s_fire = 0.0
	var/see_face = 1.0
	var/color = null
	var/brute_protect = 0
	var/fire_protect = 0
/obj/item/weapon/clothing/glasses
	name = "glasses"
	clothing_name = "glasses"
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	s_fire = 7.5E7
/obj/item/weapon/clothing/glasses/meson
	name = "Optical Meson Scanner"
	icon_state = "m_glasses"
	s_istate = "glasses"
/obj/item/weapon/clothing/glasses/regular
	name = "Prescription Glasses"
	icon_state = "p_glasses"
	s_istate = "glasses"
/obj/item/weapon/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "Sunglasses"
	icon_state = "s_glasses"
	s_istate = "s_glasses"
/obj/item/weapon/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	icon_state = "t_glasses"
	s_istate = "glasses"
/obj/item/weapon/clothing/gloves
	name = "gloves"
	clothing_name = "gloves"
	w_class = 2.0
	s_fire = 1.875E7
	var/elec_protect = 1
/obj/item/weapon/clothing/gloves/black
	desc = "These gloves are somewhat fire-resistant."
	name = "Black Gloves"
	icon_state = "bgloves"
	s_istate = "bgloves"
	h_filter = 4.0
	s_fire = 7.5E7
	fire_protect = 16
/obj/item/weapon/clothing/gloves/latex
	name = "Latex Gloves"
	icon_state = "lgloves"
	s_istate = "lgloves"
	h_filter = 5.0
	elec_protect = 2
/obj/item/weapon/clothing/gloves/robot
	desc = "These gloves are somewhat fire-resistant."
	name = "Robot Gloves"
	icon_state = "r_hands"
	s_istate = "r_hands"
	h_filter = 4.0
	fire_protect = 16
	elec_protect = 0
/obj/item/weapon/clothing/gloves/swat
	desc = "These gloves are somewhat fire-resistant."
	name = "SWAT Gloves"
	icon_state = "swat_gl"
	s_istate = "swat_gl"
	h_filter = 4.0
	fire_protect = 16
	brute_protect = 16
	elec_protect = 2

/obj/item/weapon/clothing/gloves/yellow
	desc = "These gloves are electrically insulated."
	name = "insulated gloves"
	icon_state = "ygloves"
	s_istate = "ygloves"
	h_filter = 4.0
	s_fire = 7.5E7
	fire_protect = 16
	elec_protect = 10


/obj/item/weapon/clothing/head
	name = "head"
	clothing_name = "head"
/obj/item/weapon/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio_hood"
	fb_filter = 9.0
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH
	see_face = 0.0
	s_fire = 1.875E7
	fire_protect = 1
/obj/item/weapon/clothing/head/helmet
	name = "helmet"
	icon_state = "helmet"
	flags = FPRINT|TABLEPASS|SUITSPACE|HEADCOVERSEYES
	s_istate = "helmet"
	s_fire = 6.75E7
	fire_protect = 1
	brute_protect = 1
/obj/item/weapon/clothing/head/s_helmet
	name = "s helmet"
	icon_state = "s_helmet"
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH
	see_face = 0.0
	s_istate = "s_helmet"
	s_fire = 5.625E7
	fire_protect = 1
/obj/item/weapon/clothing/head/helmet/swat_hel
	name = "swat hel"
	icon_state = "swat_hel"
	flags = FPRINT|TABLEPASS|SUITSPACE|HEADSPACE|HEADCOVERSEYES
	s_istate = "swat_hel"
/obj/item/weapon/clothing/head/wig
	name = "wig"
/obj/item/weapon/clothing/mask
	name = "mask"
	clothing_name = "mask"
/obj/item/weapon/clothing/mask/gasmask
	name = "gasmask"
	desc = "A close-fitting mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "mask"
	flags = FPRINT|TABLEPASS|MASKINTERNALS|MASKCOVERSMOUTH|MASKCOVERSEYES
	w_class = 3.0
	fb_filter = 5.0
	a_filter = 6.0
	see_face = 0.0
	s_istate = "gas_mask"
	s_fire = 7.5E7
	fire_protect = 1
/obj/item/weapon/clothing/mask/m_mask
	desc = "This mask does not work very well in low pressure environments."
	name = "Medical Mask"
	icon_state = "m_mask"
	flags = FPRINT|TABLEPASS|MASKINTERNALS|HALFMASK|MASKCOVERSMOUTH
	w_class = 3.0
	fb_filter = 4.0
	a_filter = 6.0
	s_istate = "m_mask"
	s_fire = 1.875E7
/obj/item/weapon/clothing/mask/muzzle
	name = "muzzle"
	icon_state = "muzzle"
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH
	w_class = 2.0
	a_filter = 3.0
	s_istate = "muzzle"
	s_fire = 1.875E7
/obj/item/weapon/clothing/mask/robot
	name = "Robot Mask"
	icon_state = "r_head"
	flags = FPRINT|TABLEPASS|MASKINTERNALS|MASKCOVERSMOUTH|MASKCOVERSEYES
	w_class = 3.0
	fb_filter = 5.0
	a_filter = 6.0
	see_face = 0.0
	s_istate = "r_head"
	s_fire = 7.5E7
	brute_protect = 1
	fire_protect = 1
/obj/item/weapon/clothing/mask/robot/swat
	name = "SWAT Mask"
/obj/item/weapon/clothing/mask/surgical
	name = "Sterile Mask"
	icon_state = "s_mask"
	w_class = 1.0
	flags = FPRINT|TABLEPASS|HALFMASK|MASKCOVERSMOUTH
	fb_filter = 5.0
	a_filter = 6.0
	s_istate = "s_mask"
	s_fire = 1.875E7
/obj/item/weapon/clothing/shoes
	name = "shoes"
	clothing_name = "shoes"
	var/chained = 0.0
	fb_filter = 1.0
	s_fire = 3.75E7
	brute_protect = 64
	fire_protect = 64
/obj/item/weapon/clothing/shoes/black
	name = "Black Shoes"
	icon_state = "bl_shoes"
/obj/item/weapon/clothing/shoes/brown
	name = "Brown Shoes"
	icon_state = "b_shoes"
/obj/item/weapon/clothing/shoes/orange
	name = "Orange Shoes"
	icon_state = "o_shoes"
/obj/item/weapon/clothing/shoes/robot
	name = "Robot Shoes"
	icon_state = "r_feet"
/obj/item/weapon/clothing/shoes/swat
	name = "SWAT shoes"
	icon_state = "swat_sh"
/obj/item/weapon/clothing/shoes/white
	name = "White Shoes"
	icon_state = "w_shoes"
	fb_filter = 5.0
/obj/item/weapon/clothing/suit
	name = "suit"
	clothing_name = "suit"
	var/fire_resist = T0C+100
/obj/item/weapon/clothing/suit/armor
	name = "armor"
	icon_state = "armor"
	s_istate = "armor"
	s_fire = 1.875E7
	brute_protect = 6
/obj/item/weapon/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio_suit"
	fb_filter = 9.0
	a_filter = 9.0
	h_filter = 9.0
	s_istate = "bio_suit"
	flags = FPRINT | TABLEPASS
	s_fire = 1350000.0
	fire_protect = 126
/obj/item/weapon/clothing/suit/firesuit
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "firesuit"
	fb_filter = 6.0
	h_filter = 6.0
	a_filter = 4.0
	s_istate = "fire_suit"
	flags = FPRINT | TABLEPASS
	s_fire = 7.5E7
	fire_protect = 126
	fire_resist = T0C+1300
obj/item/weapon/clothing/suit/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	s_istate = "labcoat"
	flags = FPRINT | TABLEPASS
	s_fire = 1000000.0
	fire_protect = 126
/obj/item/weapon/clothing/suit/robot_suit
	name = "robot suit"
	icon_state = "ro_suit"
	fb_filter = 9.0
	a_filter = 9.0
	h_filter = 9.0
	s_istate = "ro_suit"
	flags = FPRINT | TABLEPASS
	s_fire = 1.875E7
	fire_protect = 126
/obj/item/weapon/clothing/suit/sp_suit
	name = "sp suit"
	desc = "A suit that protects against low pressure environments."
	icon_state = "s_suit"
	fb_filter = 6.0
	h_filter = 6.0
	a_filter = 4.0
	s_istate = "s_suit"
	flags = FPRINT | TABLEPASS | SUITSPACE
	s_fire = 6.75E7
	fire_protect = 126
/obj/item/weapon/clothing/suit/straight_jacket
	name = "straight jacket"
	icon_state = "straight_jacket"
	s_istate = "straight_jacket"
	s_fire = 1.875E7
	fire_protect = 126
/obj/item/weapon/clothing/suit/swat_suit
	name = "swat suit"
	icon_state = "swat_suit"
	fb_filter = 6.0
	h_filter = 6.0
	a_filter = 4.0
	s_istate = "swat_suit"
	flags = FPRINT | TABLEPASS
	s_fire = 6.75E7
	brute_protect = 126
	fire_protect = 126

#define MAXCOIL 30
/obj/item/weapon/cable_coil
	name = "cable coil"
	var/amount = MAXCOIL
	icon = 'power.dmi'
	icon_state = "coil"
	desc = "A coil of power cable."
	w_class = 2
	flags = TABLEPASS|USEDELAY|FPRINT
	s_istate = "coil"

/obj/item/weapon/cable_coil/cut
	icon = 'power.dmi'
	icon_state = "coil2"

/obj/item/weapon/crowbar
	name = "crowbar"
	icon_state = "crowbar"
	flags = 322.0
	force = 5.0
	throwforce = 7.0
	s_istate = "wrench"
	w_class = 2.0
/obj/item/weapon/disk
	name = "disk"
/obj/item/weapon/disk/code
	name = "Code Disk"
	icon_state = "nucleardisk"
	s_istate = "card-id"
	w_class = 1.0
/obj/item/weapon/dropper
	name = "dropper"
	desc = "A dropper that can hold a small amount of liquid."
	icon_state = "dropper_0"
	var/obj/substance/chemical/chem = null
	var/mode = "inject"
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
/obj/item/weapon/dummy
	name = "dummy"
	invisibility = 101.0
	anchored = 1.0
	flags = 2.0
/obj/item/weapon/extinguisher
	desc = "The safety is on."
	name = "Fire Extinguisher"
	icon_state = "fire_extinguisher0"
	var/waterleft = 20.0
	var/last_use = 1.0
	flags = 274.0
	w_class = 2.0
	force = 17.0
	s_istate = "fire_extinguisher"
/obj/item/weapon/f_card
	name = "Finger Print Card"
	icon_state = "f_print_card0"
	var/amount = 10.0
	s_istate = "paper"
	w_class = 1.0
/obj/item/weapon/f_print_scanner
	name = "Finger Print Scanner"
	icon_state = "f_print_scanner0"
	var/amount = 20.0
	var/printing = 0.0
	w_class = 3.0
	s_istate = "electronic"
	flags = 450.0
/obj/item/weapon/fcardholder
	name = "Finger Print Case"
	icon_state = "fcardholder0"
	s_istate = "clipboard"
	w_class = 3.0
/obj/item/weapon/flash
	name = "flash"
	icon_state = "flash"
	var/l_time = 1.0
	var/shots = 5.0
	w_class = 1.0
	flags = 322.0
	s_istate = "electronic"
	throw_speed = 4
	throw_range = 20
/obj/item/weapon/flashbang
	desc = "It is set to detonate in 3 seconds."
	name = "flashbang"
	icon_state = "flashbang"
	var/state = null
	var/det_time = 30.0
	w_class = 2.0
	s_istate = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = 402.0
/obj/item/weapon/flasks
	name = "flask"
	icon = 'Cryogenic2.dmi'
	var/oxygen = 0.0
	var/plasma = 0.0
	var/coolant = 0.0
/obj/item/weapon/flasks/coolant
	name = "light blue flask"
	icon_state = "coolant-c"
	coolant = 1000.0
/obj/item/weapon/flasks/oxygen
	name = "blue flask"
	icon_state = "oxygen-c"
	oxygen = 500.0
/obj/item/weapon/flasks/plasma
	name = "orange flask"
	icon_state = "plasma-c"
	plasma = 500.0

/obj/item/weapon/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon_state = "flight0"
	var/on = 0
	w_class = 2
	s_istate = "flight"
	var/image/img
	var/lastHolder = null

/obj/item/weapon/game_kit
	name = "Gaming Kit"
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	s_istate = "sheet-metal"
	w_class = 5.0
/obj/item/weapon/gift
	name = "gift"
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	s_istate = "gift"
	w_class = 4.0
/obj/item/weapon/grab
	name = "grab"
	icon = 'screen1.dmi'
	icon_state = "grabbed"
	var/obj/screen/grab/hud1 = null
	var/mob/carbon/affecting = null
	var/mob/carbon/assailant = null
	var/state = 1.0
	var/killing = 0.0
	var/allow_upgrade = 1.0
	var/last_suffocate = 1.0
	abstract = 1.0
	s_istate = "nothing"
	w_class = 5.0
/obj/item/weapon/gun
	name = "gun"
	flags = 466.0
	s_istate = "gun"
/obj/item/weapon/gun/energy
	name = "energy"
	var/charges = 10.0
	var/maximum_charges = 10.0
/obj/item/weapon/gun/energy/laser_gun
	name = "laser gun"
	icon_state = "gun"
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 20
/obj/item/weapon/gun/energy/taser_gun
	name = "taser gun"
	icon_state = "t_gun"
	w_class = 3.0
	s_istate = "gun"
	force = 10.0
	throw_speed = 2
	throw_range = 10
	maximum_charges = 4
	charges = 4
/obj/item/weapon/gun/revolver
	desc = "There are 0 bullets left. Uses 357"
	name = "revolver"
	icon_state = "revolver"
	var/bullets = 0.0
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 60.0
/obj/item/weapon/handcuffs
	name = "handcuffs"
	icon_state = "handcuff"
	flags = 450.0
	w_class = 2.0
/obj/item/weapon/healthanalyzer
	name = "Health Analyzer"
	icon_state = "healthanalyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	flags = 450.0
	w_class = 1.0
/obj/item/weapon/implant
	name = "implant"
	var/implanted = null
	var/color = "b"
/obj/item/weapon/implant/freedom
	name = "freedom"
	var/uses = 1.0
	color = "r"
/obj/item/weapon/implantcase
	name = "Glass Case"
	icon_state = "implantcase-0"
	var/obj/item/weapon/implant/imp = null
	s_istate = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
/obj/item/weapon/implantcase/tracking
	name = "Glass Case- 'Tracking'"
	icon_state = "implantcase-b"
/obj/item/weapon/implanter
	name = "implanter"
	icon_state = "implanter0"
	var/obj/item/weapon/implant/imp = null
	s_istate = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
/obj/item/weapon/implantpad
	name = "implantpad"
	icon_state = "implantpad-0"
	var/obj/item/weapon/implantcase/case = null
	var/broadcasting = null
	var/listening = 1.0
	s_istate = "electronic"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
/obj/item/weapon/infra_sensor
	name = "Infrared Sensor"
	desc = "Scans for infrared beams in the vicinity."
	icon_state = "infra_sensor"
	var/passive = 1.0
	flags = 322.0
	s_istate = "electronic"

/obj/item/weapon/camera_jammer
	name = "Camera Jammer"
	desc = "Creates an EM field that blocks camera tracking."
	icon_state = "jammer0"
	flags = FPRINT|ONBELT
	w_class = 2
	s_istate = "electronic"
	var/on = 0

/obj/item/weapon/t_scanner
	name = "T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon_state = "t-scanner0"
	var/on = 0
	flags = FPRINT|ONBELT|TABLEPASS
	w_class = 2
	s_istate = "electronic"

/obj/item/weapon/locator
	name = "locator"
	icon_state = "locator"
	var/temp = null
	var/freq = 145.1
	var/broadcasting = null
	var/listening = 1.0
	flags = 322.0
	w_class = 2.0
	s_istate = "electronic"
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/m_pill
	name = "pill"
	icon_state = "pill"
	var/amount = 1.0
	var/s_time = 1.0
	w_class = 1.0
	s_istate = "pill"
	throw_speed = 4
	throw_range = 20
/obj/item/weapon/m_pill/Tourette
	name = "green pill"
	icon_state = "pill2"
/obj/item/weapon/m_pill/antitoxin
	name = "red/blue pill"
/obj/item/weapon/m_pill/cough
	name = "red pill"
	icon_state = "pill4"
/obj/item/weapon/m_pill/cyanide
	name = "orange pill"
	icon_state = "pill5"
/obj/item/weapon/m_pill/epilepsy
	name = "blue pill"
	icon_state = "pill3"
/obj/item/weapon/m_pill/sleep
	name = "red/blue pill"
/obj/item/weapon/m_pill/superpill
	name = "red/blue pill"
/obj/item/weapon/ointment
	name = "ointment"
	icon_state = "ointment"
	var/amount = 5.0
	throw_speed = 4
	throw_range = 20
	w_class = 1.0
/obj/item/weapon/paint
	name = "Paint Can"
	icon_state = "paint_neutral"
	var/color = "neutral"
	s_istate = "paintcan"
	w_class = 3.0
/obj/item/weapon/paper
	name = "Paper"
	icon_state = "paper"
	var/info = null
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
/obj/item/weapon/paper/Internal
	name = "paper- 'Internal Atmosphere Operating Instructions'"
	info = "Equipment:<BR>\n\t1+ Tank(s) with appropriate atmosphere<BR>\n\t1 Gas Mask w regulator (standard issue)<BR>\n<BR>\nProcedure:<BR>\n\t1. Wear mask<BR>\n\t2. Attach oxygen tank pipe to regulater (automatic))<BR>\n\t3. Set internal!<BR>\n<BR>\nNotes:<BR>\n\tDon't forget to stop internal when tank is low by<BR>\n\tremoving internal!<BR>\n<BR>\n\tDo not use a tank that has a high concentration of toxins.<BR>\n\tThe filters shut down on internal mode!<BR>\n<BR>\n\tWhen exiting a high danger environment it is advised<BR>\n\tthat you exit through a decontamination zone!<BR>\n<BR>\n\tRefill a tank at a oxygen canister by equiping the tank (Double Click)<BR>\n\tthen 'attacking' the canister (Double Click the canister)."
/obj/item/weapon/paper/Map
	name = "paper- 'Station Blueprint'"
	var/map_graphic = 'map/map.png'
	info = {"<IMG SRC="ss13mapd.png">
<BR>
CQ: Crew Quarters<BR>
L: Lounge<BR>
CH: Chapel<BR>
ENG: Engine Area<BR>
EC: Engine Control<BR>
ES: Engine Storage<BR>
GR: Generator Room<BR>
MB: Medical Bay<BR>
MR: Medical Research<BR>
TR: Toxin Research<BR>
TS: Toxin Storage<BR>
AC: Atmospheric Control<BR>
SEC: Security<BR>
SB: Shuttle Bay
SA: Shuttle Airlock<BR>
S: Storage<BR>
CR: Control Room<BR>
EV: EVA Storage<BR>
AE: Aux. Engine<BR>
P: Podbay<BR>
NA: North Airlock<BR>
SC: Solar Control<BR>
ASC: Aux. Solar Control<BR>
"}

/obj/item/weapon/paper/Toxin
	name = "paper- 'Chemical Information'"
	info = {"Known Onboard Toxins:<BR>
             Grade A Semi-Liquid Plasma:
             Highly poisonous. You cannot sustain concentrations above 15 units.<BR>
             A gas mask fails to filter plasma after 50 units.<BR>
             Will attempt to diffuse like a gas.<BR>
             Filtered by scrubbers.<BR>
             There is a bottled version which is very different from the version found in canisters!<BR><BR>
             WARNING: Highly Flammable. Keep away from heat sources except in a enclosed fire area!<BR>
             WARNING: It is a crime to use this without authorization.<BR>
             Known Onboard Anti-Toxin:<BR>
             Anti-Toxin Type 01P: Works against Grade A Plasma.<BR>
             Best if injected directly into bloodstream.<BR>
             A full injection is in every regular Med-Kit.<BR>
             Special toxin Kits hold around 7.<BR><BR>
             Known Onboard Chemicals (other):<BR>
             Rejuvenation T#001:<BR>
             Even 1 unit injected directly into the bloodstream will cure paralysis and sleep toxins.<BR>
             If administered to a dying patient it will prevent further damage for about units*3 seconds.<BR>
             It will not cure them or allow them to be cured.<BR>
             It can be administered to a non-dying patient, but the chemicals disappear just as fast.
             Sleep Toxin T#054:<BR>
             5 units wilkl induce precisely 1 minute of sleep.<BR>
             The effects are cumulative.<BR>
             WARNING: It is a crime to use this without authorization."}
/obj/item/weapon/paper/courtroom
	name = "paper- 'A Crash Course in Legal SOP on SS13'"
	info = {"<p><b>A crash course in legal standard operating procedure on the station:</b></p>
	<h3>Pre-trial:</h3>
	<p>Once a crime has been committed, the detective should investigate it and gather as much evidence as possible.
	Knowing security, the suspect will already be detained, but if not, he should be detained at this point. The
	suspect should be given a defense attorney if he does not wish to represent himself. While the suspect is in
	jail and while he is on trial, he is to be uncuffed, but he may be handcuffed during transport if necessary.
	Once enough evidence has been collected, the defendant is to be brought to the courtroom for trial.</p>
	<h3>Trial</h3>
	<p>The captain or highest-ranking officer on the station is the judge. If the defendant pleads guilty, proceed
	directly to sentencing. Otherwise, the prosecutor (generally the detective) may present any evidence gatherered
	and call any witnesses he wishes, with the defendant or defendant's lawyer cross-examining them afterwards. The
	defendant may then present evidence and call witnesses, with the prosecutor cross-examining them afterwards.
	Both sides then make closing arguments, and the judge decides whether the defendant is guilty and what sentence
	he should receive.</p>"}
/obj/item/weapon/paper/flag
	icon_state = "flag_neutral"
	s_istate = "paper"
	anchored = 1.0
/obj/item/weapon/paper/jobs
	name = "paper- 'Job Information'"
	New()
		info = "<b>Jobs: (job - responsibilities)</b><br>"
		for(var/datum/job/j in get_all_job_instances())
			if(j.max > 0)
				info += "<b>[j.name]</b> - [j.responsibilities]<br><br>"
/obj/item/weapon/paper/engine
	name = "paper- 'Generator Startup Procedure'"
	info = {"<B>Thermo-Electric Generator Startup Procedure for Mark I Plasma-Fired Engines</B>
<HR>
<i>Warning!</i> Improper engine and generator operation may cause exposure to hazardous gasses, extremes of heat and cold, and dangerous electrical voltages.<BR>
Only trained personnel should operate station systems. Follow all procedures carefully. Wear correct personal protective equipment at all times.<BR>
Refer to your supervisor or Head of Personnel for procedure updates and additional information.
<HR>
Standard checklist for engine and generator cold-start.<BR>
<ol>
<li>Perform visual inspection of external (cooling) and internal (heating) heat-exchange pipe loops.
Refer any breaks or cracks in the pipe to Station Maintenance for repair before continuing.
<li>Connect a CO<sub>2</sub> canister to the external (cooling) loop connector, and release the contents. Check loop pressurization is stable.<BR>
<i>Note:</i> Observe standard canister safety procedures.<BR>
<i>Note:</i> Other gasses may be substituted as a medium in the external (cooling) loop in the event that CO<sub>2</sub> is not available.
<li>Connect a CO<sub>2</sub> canister to the internal (heating) loop connector, and release the contents. Check loop pressurization is stable.<BR>
<i>Note:</i> Observe standard canister safety procedures.<BR>
<i>Note:</i> Nitrogen may be substituted as a medium in the internal (heating) loop in the event that CO<sub>2</sub> is not available.
<i>Do not use plasma in the internal (heating) pipe loop as an unsafe condition may result.</i>
<li>Using the thermo-electric generator (TEG) master control panel, engage the internal and external loop circulator pumps at 1% maximum rate.<BR>
<li>Ignite the engine. Refer to document NTRSN-113-H9-12939 for proper engine preparation, ignition, and plasma-oxygen loading procedures.<BR>
<i>Note:</i> Exceeding recommended plasma-oxygen concentrations can cause engine damage and potential hazards.
<li>Monitor engine temperatures until stable operation is achieved.
<li>Increase internal and external circulator pumps to 10% of maximum rate. Monitor the generated power output on the TEG control panel.<BR>
<i>Note:</i> Consult appendix A for expected electrical generation rates.
<li>Adjust circulator rates until required electrical demand is met.<BR>
<i>Note:</i> Generation rate varies with internal and external loop temperatures, exchange media pressure, and engine geometry. Refer to Appendix B or your supervisor for locally determined optimal settings.<BR>
<i>Note:</i> Do not exceed safety ratings for station power cabling and electrical equipment.
<li>With the power generation rate stable, engage charging of the superconducting magnetic energy storage (SMES) devices.
"}

/obj/item/weapon/paper_bin
	name = "Paper Bin"
	icon = 'stationobjs.dmi'
	icon_state = "paper_bin1"
	var/amount = 30.0
	s_istate = "sheet-metal"
	w_class = 5.0
/obj/item/weapon/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon_state = "pen"
	flags = 386.0
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
/obj/item/weapon/pen/sleepypen
	desc = "It's a normal black ink pen with a sharp point."
	var/obj/substance/chemical/chem = null
/obj/item/weapon/pill_canister
	name = "Pill Canister"
	icon_state = "pill_canister"
	w_class = 1.0
	s_istate = "brutepack"
/obj/item/weapon/pill_canister/Tourette
	desc = "<B>Tourette's Syndrome Remedy</B>\nAdminister as required to surpress Tourette syndrome induced twitching.\nAdminister only once every 15 minutes. Active for 20 at most.\n<B>WARNING</B>: Neurodepressant! Rebalances chemical alignment!\n<B>Warning</B>: May cause drowsyness.\nIf drowsyness persists for over 5 minutes contact medical professional."
	name = "Pill Canister- 'Tourette's Syndrome Remedy'"
/obj/item/weapon/pill_canister/antitoxin
	desc = "<B>Anti-toxins</B>\nAdminister as required to relieve of plasma burns.\nAdminister only once every 5 minutes.\n<B>Warning</B>: May cause drowsyness.\nIf drowsyness persists for over 5 minutes contact medical professional."
	name = "Pill Canister- 'Antitoxin Supplements'"
/obj/item/weapon/pill_canister/cough
	desc = "<B>Chronic Cough Syndrome Remedy</B>\nAdminister as required to surpress excessive coughs.\nAdminister only once every 15 minutes. Active for 20 at most.\n<B>Warning</B>: May cause drowsyness.\nIf drowsyness persists for over 5 minutes contact medical professional."
	name = "Pill Canister- 'CCS Remedy'"
/obj/item/weapon/pill_canister/epilepsy
	desc = "<B>Epilepsy Remedy</B>\nAdminister as required to surpress excessive coughs.\nAdminister only once every 15 minutes. Active for 20 at most.\n<B>WARNING</B>: Neurodepressant! Rebalances chemcial alignment!\n<B>Warning</B>: May cause drowsyness.\nIf drowsyness persists for over 5 minutes contact medical professional."
	name = "Pill Canister- 'Epilepsy Remedy'"
/obj/item/weapon/pill_canister/placebo
	desc = "<B>Placebos</B>\nThese pills do nothing phsyiologically."
	name = "Pill Canister- 'Placebos'"
/obj/item/weapon/pill_canister/sleep
	desc = "<B>Sleeping Pills</B>\nAdminister as required to calm person.\nCauses 10 minutes of drowsyness. MAY induce immediate sleep.\n<B>WARNING</B>: Neurodepressant! Do not overdose!\n<B>Warning</B>: Causes drowsiness!If drowsyness persists for over 15 minutes contact medical professional."
	name = "Pill Canister- 'Sleeping Pills'"
/obj/item/weapon/rack_parts
	name = "rack parts"
	icon_state = "rack_parts"
	flags = 322.0
/obj/item/weapon/rods
	name = "rods"
	icon_state = "rods"
	var/amount = 1.0
	flags = 322.0
	w_class = 4.0
	force = 9.0
	throwforce = 20.0
	throw_speed = 2
	throw_range = 10
/obj/item/weapon/screwdriver
	name = "screwdriver"
	icon_state = "screwdriver"
	flags = 322.0
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
/obj/item/weapon/shard
	name = "shard"
	icon = 'shards.dmi'
	icon_state = "large"
	w_class = 4.0
	force = 7.0
	throwforce = 10.0
	s_istate = "shard-glass"
/obj/item/weapon/storage
	name = "storage"
	var/obj/screen/storage/boxes = null
	var/obj/screen/close/closer = null
	w_class = 3.0
/obj/item/weapon/storage/backpack
	name = "backpack"
	icon_state = "backpack"
	w_class = 4.0
	flags = 259.0
/obj/item/weapon/storage/box
	name = "Box"
	icon_state = "box"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/disk_kit
	name = "Data Disks"
	icon_state = "id_kit"
	s_istate = "syringe_kit"

/obj/item/weapon/storage/disk_kit/disks

/obj/item/weapon/storage/disk_kit/disks2

/obj/item/weapon/storage/fcard_kit
	name = "Fingerprint Cards"
	icon_state = "id_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/firstaid
	name = "First-Aid"
	throw_speed = 2
	throw_range = 8
/obj/item/weapon/storage/firstaid/fire
	name = "Fire First Aid"
	icon_state = "firstaid-ointment"
/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"
/obj/item/weapon/storage/firstaid/syringes
	name = "Syringes (Biohazard Alert)"
	icon_state = "syringe_kit"
/obj/item/weapon/storage/firstaid/toxin
	name = "Toxin First Aid"
	icon_state = "firstaid-toxin"
/obj/item/weapon/storage/flashbang_kit
	desc = "<FONT color=red><B>WARNING: Do not use without reading these preautions!</B></FONT>\n<B>These devices are extremely dangerous and can cause blindness or deafness if used incorrectly.</B>\nThe chemicals contained in these devices have been tuned for maximal effectiveness and due to\nextreme safety precuaiotn shave been incased in a tamper-proof pack. DO NOT ATTEMPT TO OPEN\nFLASH WARNING: Do not use continually. Excercise extreme care when detonating in closed spaces.\n\tMake attemtps not to detonate withing range of 2 meters of the intended target. It is imperative\n\tthat the targets visit a medical professional after usage. Damage to eyes increases extremely per\n\tuse and according to range. Glasses with flash resistant filters DO NOT always work on high powered\n\tflash devices such as this. <B>EXERCISE CAUTION REGARDLESS OF CIRCUMSTANCES</B>\nSOUND WARNING: Do not use continually. Visit a medical professional if hearing is lost.\n\tThere is a slight chance per use of complete deafness. Exercise caution and restraint.\nSTUN WARNING: If the intended or unintended target is too close to detonation the resulting sound\n\tand flash have been known to cause extreme sensory overload resulting in temporary\n\tincapacitation.\n<B>DO NOT USE CONTINUALLY</B>\nOperating Directions:\n\t1. Pull detonnation pin. <B>ONCE THE PIN IS PULLED THE GRENADE CAN NOT BE DISARMED!</B>\n\t2. Throw grenade. <B>NEVER HOLD A LIVE FLASHBANG</B>\n\t3. The grenade will detonste 10 seconds hafter being primed. <B>EXCERCISE CAUTION</B>\n\t-<B>Never prime another grenade until after the first is detonated</B>\nNote: Usage of this pyrotechnic device without authorization is an extreme offense and can\nresult in severe punishment upwards of <B>10 years in prison per use</B>.\n\nDefault 3 second wait till from prime to detonation. This can be switched with a screwdriver\nto 10 seconds.\n\nCopyright of Nanotrasen Industries- Military Armnaments Division\nThis device was created by Nanotrasen Labs a member of the Expert Advisor Corporation"
	name = "Flashbangs (WARNING)"
	icon_state = "flashbang_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/gl_kit
	name = "Prescription Glasses"
	icon_state = "id_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/handcuff_kit
	name = "Spare Handcuffs"
	icon_state = "handcuff_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/id_kit
	name = "Spare IDs"
	icon_state = "id_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/lglo_kit
	name = "Latex Gloves"
	icon_state = "lglo_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/stma_kit
	name = "Sterile Masks"
	icon_state = "lglo_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/storage/toolbox
	name = "toolbox"
	icon_state = "toolbox"
	flags = 322.0
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
/obj/item/weapon/storage/toolbox/electrical
	name = "electical toolbox"
	icon_state = "toolbox_yellow"
	flags = 322.0
	force = 8.0
	w_class = 4.0
/obj/item/weapon/storage/trackimp_kit
	name = "Tracking Implant Kit"
	icon_state = "imp_kit"
	s_istate = "syringe_kit"
/obj/item/weapon/sword
	name = "sword"
	icon_state = "sword0"
	var/active = 0.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = 290.0
/obj/item/weapon/syndicate_uplink
	name = "Station Bounced Radio"
	icon_state = "radio"
	var/temp = null
	var/uses = 3
	var/selfdestruct = 0
	flags = 322
	w_class = 2
	s_istate = "electronic"
	throw_speed = 4
	throw_range = 20
	var/traitorfreq = 0
	var/obj/item/weapon/radio/origradio = null
	var/obj/item/weapon/radio/radio = null
/obj/item/weapon/syringe
	name = "syringe"
	icon_state = "syringe_0"
	var/obj/substance/chemical/chem = null
	var/mode = "inject"
	var/s_time = 1.0
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
/obj/item/weapon/table_parts
	name = "table parts"
	icon_state = "table_parts"
	flags = 322.0
/obj/item/weapon/tank
	name = "tank"
	var/maximum = null
	var/datum/substance/gas/gas = null
	var/i_used = 100
	flags = 323.0
	weight = 1000000.0
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
/obj/item/weapon/tank/anesthetic
	name = "anesthetic"
	icon_state = "an_tank"
	maximum = 1750000.0
	i_used = 250.0
/obj/item/weapon/tank/jetpack
	name = "jetpack"
	icon_state = "jetpack0"
	var/on = 0.0
	maximum = 300000
	w_class = 4.0
	s_istate = "jetpack"
/obj/item/weapon/tank/oxygentank
	name = "oxygentank"
	icon_state = "oxygen"
	maximum = 600000
/obj/item/weapon/tile
	name = "steel floor tile"
	icon_state = "tile"
	var/amount = 1.0
	w_class = 3.0
	throw_speed = 1
	throw_range = 5
	force = 6.0
	throwforce = 7.0
/obj/item/weapon/wire
	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon_state = "item_wire"
	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null
/obj/item/weapon/wirecutters
	name = "wirecutters"
	icon_state = "cutters"
	flags = 322.0
	force = 6.0
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
/obj/item/weapon/wrapping_paper
	name = "wrapping paper"
	icon_state = "wrap_paper"
	var/amount = 20.0
/obj/item/weapon/wrench
	name = "wrench"
	icon_state = "wrench"
	flags = 322.0
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
/obj/item/weapon/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'power.dmi'
	icon_state = "cell"
	s_istate = "cell"
	flags = FPRINT|TABLEPASS
	force = 10.0
	throwforce = 2.0
	throw_speed = 1
	throw_range = 1
	w_class = 3.0
	weight = 100000
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
/obj/landmark
	name = "landmark"
	icon = 'screen1.dmi'
	icon_state = "x2"
	anchored = 1.0
/obj/landmark/alterations
	name = "alterations"

/obj/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon = 'turfs2.dmi'
	icon_state = "lattice"
	density = 0
	anchored = 1.0
	layer = 2.5
	//	flags = 64.0

/obj/list_container
	name = "list container"
/obj/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/m_tray
	name = "morgue tray"
	icon = 'stationobjs.dmi'
	icon_state = "morguet"
	density = 1
	layer = 2.0
	var/obj/morgue/connected = null
	anchored = 1.0


/obj/machinery
	name = "machinery"
	var/p_dir = 0
	var/h_dir = 0		// used for heat-exchange
	var/capmult = 0
	var/stat = 0
	is_ai_interactable = 1

/obj/machinery/alarm
	name = "alarm"
	icon = 'stationobjs.dmi'
	icon_state = "alarm:0"
	anchored = 1.0
/obj/machinery/atmoalter
	name = "atmoalter"
	var/datum/substance/gas/gas = null
	var/maximum
	var/t_status
	var/t_per
	var/c_per
	var/c_status
	var/obj/item/weapon/tank/holding
	var/max_valve = 1e6
/obj/machinery/atmoalter/canister
	name = "canister"
	icon = 'canister.dmi'
	density = 1
	maximum = 1.3E8
	var/color = "blue"
	t_status = 3.0
	t_per = 50.0
	c_per = 50.0
	c_status = 0.0
	holding = null
	var/health = 20.0
	var/destroyed = null
	flags = FPRINT
	weight = 1.0E7
	var/filled = 1		//fractional fullness at spawn
/obj/machinery/atmoalter/canister/anesthcanister
	name = "Canister: \[N2O\]"
	icon_state = "redws"
	color = "redws"
/obj/machinery/atmoalter/canister/n2canister
	name = "Canister: \[N2\]"
	icon_state = "red"
	color = "red"
/obj/machinery/atmoalter/canister/oxygencanister
	name = "Canister: \[O2\]"
	icon_state = "blue"
/obj/machinery/atmoalter/canister/poisoncanister
	name = "Canister \[Plasma (Bio)\]"
	icon_state = "orange"
	color = "orange"
/obj/machinery/atmoalter/canister/co2canister
	name = "Canister \[CO2\]"
	icon_state = "black"
	color = "black"
/obj/machinery/atmoalter/canister/aircanister
	name = "Canister \[Air\]"
	icon_state = "grey"
	color = "grey"

/obj/machinery/atmoalter/heater
	name = "heater"
	icon = 'stationobjs.dmi'
	icon_state = "heater1"
	density = 1
	maximum = 1.3E8
	t_status = 3.0
	var/h_status = 0.0
	t_per = 50.0
	var/h_tar = 20.0
	c_per = 50.0
	c_status = 0.0
	holding = null
	anchored = 1.0
	var/heatrate = 1500000.0
/obj/machinery/atmoalter/siphs
	name = "siphs"
	density = 1
	var/alterable = 1.0
	var/f_time = 1.0
	var/location = null
	maximum = 1.3E8
	holding = null
	t_status = 3.0
	t_per = 50.0
	c_per = 50.0
	c_status = 0.0
	weight = 1.0E7
	anchored = 1.0
	var/empty =  null
/obj/machinery/atmoalter/siphs/fullairsiphon
	name = "Air siphon"
	icon = 'turfs.dmi'
	icon_state = "siphon:0"
/obj/machinery/atmoalter/siphs/fullairsiphon/port
	name = "Portable Siphon"
	icon = 'stationobjs.dmi'
	flags = FPRINT
	anchored = 0.0
/obj/machinery/atmoalter/siphs/scrubbers
	name = "scrubbers"
	icon = 'turfs2.dmi'
	icon_state = "siphon:0"
/obj/machinery/atmoalter/siphs/scrubbers/port
	name = "Portable Siphon"
	icon = 'stationobjs.dmi'
	icon_state = "scrubber:0"
	flags = FPRINT
	anchored = 0.0
/obj/machinery/camera/motion
/obj/machinery/circulator
	name = "circulator/heat exchanger"
	desc = "A gas circulator pump and heat exchanger."
	icon = 'pipes.dmi'
	icon_state = "circ1-off"
	p_dir = 3		// N & S
	var/side = 1 // 1=left 2=right
	var/status = 0
	var/rate = 1000000
	var/datum/substance/gas/gas1 = null
	var/datum/substance/gas/ngas1 = null
	var/datum/substance/gas/gas2 = null
	var/datum/substance/gas/ngas2 = null

	var/capacity = 6000000.0
	var/obj/machinery/node1 = null
	var/obj/machinery/node2 = null

	var/obj/machinery/vnode1
	var/obj/machinery/vnode2

	anchored = 1.0
	density = 1
	capmult = 1

	//var/obj/machinery/power/teg/master = null

/obj/machinery/computer
	name = "computer"
	density = 1
	anchored = 1.0

/obj/machinery/computer/aiupload
	name = "AI Upload"
	icon = 'stationobjs.dmi'
	icon_state = "comm_computer"

/obj/machinery/computer/atmosphere
	name = "atmosphere"
	icon = 'turfs.dmi'
/obj/machinery/computer/atmosphere/siphonswitch
	name = "Area Air Control"
	icon_state = "switch"
	req_access = list(access_atmospherics)
	var/otherarea
	var/area/area
/obj/machinery/computer/atmosphere/siphonswitch/mastersiphonswitch
	name = "Master Air Control"
/obj/machinery/computer/card
	name = "Identification Computer"
	icon = 'stationobjs.dmi'
	icon_state = "id_computer"
	var/obj/item/weapon/card/id/scan = null
	var/obj/item/weapon/card/id/modify = null
	var/authenticated = 0.0
	var/mode = 0.0
	var/printing = null
	req_access = list(access_change_ids)
/obj/machinery/computer/data
	name = "data"
	icon = 'weap_sat.dmi'
	icon_state = "computer"

	var/list/topics = list(  )

/obj/machinery/computer/data/weapon
	name = "weapon"
	req_access = list(access_heads)
/obj/machinery/computer/data/weapon/info
	name = "Research Computer"
/obj/machinery/computer/data/weapon/log
	name = "Log Computer"

/obj/machinery/computer/gasmonitor
	name = "Gas Monitor"
	icon = 'enginecomputer.dmi'
	var/id = null
	var/obj/machinery/gas_sensor/gs = null

/obj/machinery/computer/gasmonitor/engine
	name = "Engine Control"
	var/temp = null
	req_access = list(access_eject_engine)

/obj/machinery/computer/hologram_comp
	name = "Hologram Computer"
	icon = 'stationobjs.dmi'
	icon_state = "holo_console0"
	var/obj/machinery/hologram_proj/projector = null
	var/temp = null
	var/lumens = 0.0
	var/h_r = 245.0
	var/h_g = 245.0
	var/h_b = 245.0
/obj/machinery/computer/med_data
	name = "Medical Records"
	icon = 'weap_sat.dmi'
	icon_state = "computer"
	req_access = list(access_medical_records)
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/job = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null

/obj/machinery/computer/pod
	name = "Pod Launch Control"
	icon = 'escapepod.dmi'
	icon_state = "computer"
	var/id = 1.0
	var/obj/machinery/mass_driver/connected = null
	var/timing = 0.0
	var/time = 30.0


/obj/machinery/computer/secure_data
	name = "Security Records"
	icon = 'weap_sat.dmi'
	icon_state = "computer"
	req_access = list(access_security_records)
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/job = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
/obj/machinery/computer/security
	name = "Security Cameras"
	icon = 'stationobjs.dmi'
	icon_state = "sec_computer"
	var/obj/machinery/camera/current = null
	var/last_pic = 1.0
	var/network = "SS13"
	var/maplevel = 1
	req_access = list(access_security)

/obj/machinery/computer/sleep_console
	name = "Sleeper Console"
	icon = 'Cryogenic2.dmi'
	icon_state = "sleeperconsole"
	var/obj/machinery/sleeper/connected = null
/obj/machinery/computer/teleporter
	name = "Teleporter"
	icon = 'stationobjs.dmi'
	icon_state = "tele_computer"
	var/obj/item/weapon/radio/beacon/locked = null
	var/id = null
	req_access = list(access_teleporter)

/obj/machinery/connector
	name = "Connector"
	icon = 'pipes.dmi'
	desc = "A connector for gas canisters."
	icon_state = "connector"
	anchored = 1.0
	p_dir = 2
	var/obj/machinery/node = null
	var/obj/machinery/atmoalter/connected = null

	var/obj/machinery/vnode = null

	var/datum/substance/gas/gas = null
	var/datum/substance/gas/ngas = null

	//var/datum/substance/gas/agas

	var/capacity = 6000000.0
	capmult = 2
	var/flag = 0

/obj/machinery/inlet
	name = "inlet"
	icon = 'pipes.dmi'
	icon_state = "inlet"
	desc = "A gas pipe inlet."
	anchored = 1
	p_dir = 2
	var/obj/machinery/node
	var/obj/machinery/vnode
	var/datum/substance/gas/gas
	var/datum/substance/gas/ngas
	var/capacity = 6000000
	capmult = 2


/obj/machinery/vent
	name = "vent"
	icon = 'pipes.dmi'
	icon_state = "vent"
	desc = "A gas pipe outlet vent."
	anchored = 1
	p_dir = 2
	var/obj/machinery/node
	var/obj/machinery/vnode
	var/datum/substance/gas/gas
	var/datum/substance/gas/ngas
	var/capacity = 6000000
	capmult = 2


/obj/machinery/cryo_cell
	name = "cryo cell"
	icon = 'Cryogenic2.dmi'
	icon_state = "celltop"
	density = 1
	var/obj/machinery/line_in = null
	var/mob/carbon/occupant = null
	var/datum/substance/gas/gas = new()
	var/datum/substance/gas/ngas = new()
	anchored = 1.0
	p_dir = 8.0
	capmult = 1

	var/obj/overlay/O1 = null
	var/obj/overlay/O2 = null

	var/obj/machinery/vnode = null

/obj/machinery/dispenser
	desc = "A simple yet bulky one-way storage device for gas tanks. Holds 10 plasma and 10 oxygen tanks."
	name = "Tank Storage Unit"
	icon = 'turfs2.dmi'
	icon_state = "dispenser"
	density = 1
	var/o2tanks = 10.0
	var/pltanks = 10.0
	anchored = 1.0

/obj/machinery/door
	name = "Door"
	icon = 'doors.dmi'
	icon_state = "door1"
	opacity = 1
	density = 1
	var/visible = 1.0
	var/p_open = 0.0
	var/operating = null
	anchored = 1.0
	var/id = 1

/obj/machinery/door/poddoor
	name = "Podlock"
	icon = 'Door1.dmi'
	icon_state = "pdoor1"

/obj/machinery/door/window
	name = "interior door"
	icon = 'windoor.dmi'
	visible = 0.0
	flags = 512.0
	opacity = 0
	var/cellname = null
	var/delay = 50 // 5 seconds to close after being bumped. if 0, doesn't auto-close.

/obj/machinery/door/window/security
	name = "security door"
	icon = 'security.dmi'
	delay = 20 // secure doors close faster

/obj/machinery/door/window/alt
	name = "interior door"
	icon = 'windoor2.dmi'

/obj/machinery/door/window/alt/security
	name = "security door"
	icon = 'security2.dmi'
	delay = 20 // secure doors close faster

/obj/machinery/firealarm
	name = "Fire Alarm"
	icon = 'items.dmi'
	icon_state = "firealarm"
	var/detecting = 1
	var/working = 1
	var/time = 10
	var/timing = 0
	anchored = 1
/obj/machinery/freezer
	name = "Freezer"
	icon = 'Cryogenic2.dmi'
	icon_state = "freezer_0"
	density = 1
	var/connector = null
	var/obj/machinery/line_out = null
	var/obj/machinery/vnode = null
	var/list/rate = new()
	var/status = 0.0
	var/t_flags = 3.0
	var/transfer = 0.0
	var/temp = T0C + 60

	var/datum/substance/gas/gas = new()
	var/datum/substance/gas/ngas = new()
	p_dir = 4.0
	anchored = 1.0
	capmult = 1

/obj/machinery/gas_sensor
	name = "gas sensor"
	icon = 'stationobjs.dmi'
	icon_state = "gsensor"
	desc = "A remote sensor for atmospheric gas composition."
	var/id
	anchored = 1

/obj/machinery/hologram_proj
	name = "Hologram Projector"
	icon = 'stationobjs.dmi'
	icon_state = "hologram0"
	var/atom/projection = null
	anchored = 1.0

/obj/machinery/hologram_ai
	name = "Hologram Projector Platform"
	icon = 'stationobjs.dmi'
	icon_state = "hologram0"
	var/atom/projection = null
	var/temp = null
	var/lumens = 0.0
	var/h_r = 245.0
	var/h_g = 245.0
	var/h_b = 245.0
	anchored = 1.0

/obj/machinery/igniter
	name = "igniter"
	icon = 'stationobjs.dmi'
	icon_state = "igniter1"
	var/on = 1.0
	anchored = 1.0
/obj/machinery/mass_driver
	name = "mass driver"
	icon = 'stationobjs.dmi'
	icon_state = "mass_driver"
	var/power = 1.0
	var/code = 1.0
	var/id = 1.0
	anchored = 1.0
	var/drive_range = 50 //this is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.
/obj/machinery/meter
	name = "meter"
	icon = 'pipes.dmi'
	icon_state = "meterX"
	var/obj/machinery/pipes/target = null
	anchored = 1.0
	var/average = 0
/obj/machinery/valve
	var/datum/substance/gas/gas1 = null
	var/datum/substance/gas/ngas1 = null
	var/datum/substance/gas/gas2 = null
	var/datum/substance/gas/ngas2 = null
	var/capacity = 6000000.0
	var/obj/machinery/node1 = null
	var/obj/machinery/node2 = null
	var/obj/machinery/vnode1 = null
	var/obj/machinery/vnode2 = null
	var/id = "v1"
	var/open = 0
	anchored = 1.0
	capmult = 2
	icon = 'pipes.dmi'
/obj/machinery/valve/mvalve
	name = "valve"
	icon_state = "valve0"
	desc = "A gas valve."
	is_ai_interactable = 0
/obj/machinery/valve/dvalve
	name = "digital valve"
	icon_state = "dvalve0"
	desc = "A digital gas valve."
/obj/machinery/oneway
	name = "one-way pipe"
	desc = "A Pipe that only passes gas in one direction."
	var/datum/substance/gas/gas1 = null
	var/datum/substance/gas/ngas1 = null
	var/datum/substance/gas/gas2 = null
	var/datum/substance/gas/ngas2 = null
	var/capacity = 6000000.0
	var/obj/machinery/node1 = null
	var/obj/machinery/node2 = null
	var/obj/machinery/vnode1 = null
	var/obj/machinery/vnode2 = null
	anchored = 1.0
	capmult = 2
	icon = 'pipes.dmi'
	icon_state = "one-way"
/obj/machinery/oneway/pipepump
	name = "Pipe pump"
	desc = "A machine that pushes gas as hard as it can from one side to the other."
	icon = 'pipes2.dmi'
	icon_state = "pipepump-run"
	var/rate = 6000000.0
/obj/machinery/manifold
	name = "manifold"
	icon = 'pipes.dmi'
	icon_state = "manifold"
	desc = "A three-port gas manifold."
	anchored = 1
	dir = 2
	p_dir = 14
	var/n1dir
	var/n2dir

	var/datum/substance/gas/gas = null
	var/datum/substance/gas/ngas = null
	var/capacity = 6000000.0
	var/obj/machinery/node1 = null
	var/obj/machinery/node2 = null
	var/obj/machinery/node3 = null

	var/obj/machinery/vnode1
	var/obj/machinery/vnode2
	var/obj/machinery/vnode3


	capmult = 3

/obj/machinery/pipefilter
	name = "pipe filter"
	icon = 'pipes2.dmi'
	icon_state = "filter"
	desc = "A three-port gas filter."
	anchored = 1
	dir = 2
	p_dir = 14
	capmult = 3
	req_access = list(access_atmospherics)
	var/bypassed = 0
	var/locked = 0
	var/maxrate = 1000000.0
	var/capacity = 6000000.0
	var/n1dir
	var/n2dir

	var/datum/substance/gas/gas = null
	var/datum/substance/gas/ngas = null

	var/f_mask = 0
	var/f_per = 0
	var/datum/substance/gas/f_gas = null
	var/datum/substance/gas/f_ngas = null

	var/obj/machinery/node1 = null
	var/obj/machinery/node2 = null
	var/obj/machinery/node3 = null

	var/obj/machinery/vnode1
	var/obj/machinery/vnode2
	var/obj/machinery/vnode3

/obj/machinery/junction
	name = "junction"
	icon = 'junct-pipe.dmi'
	icon_state = "junction"
	desc = "A junction between regular and heat-exchanger pipework."
	var/capacity = 6000000
	anchored = 1
	dir = 2
	p_dir = 3

	var/datum/substance/gas/gas = null
	var/datum/substance/gas/ngas = null
	var/obj/machinery/node1 = null
	var/obj/machinery/node2 = null

	var/obj/machinery/vnode1
	var/obj/machinery/vnode2

	capmult = 2


/obj/machinery/pipes
	name = "pipes"
	icon = 'reg_pipe.dmi'
	icon_state = "12"
	var/capacity = 6000000.0
	var/obj/machinery/node1 = null
	var/obj/machinery/node2 = null
	anchored = 1.0
	var/termination = 0
	var/insulation = NORMPIPERATE
	var/plnum = 0
	var/obj/machinery/pipeline/pl



/obj/machinery/pipeline				// virtual pipeline consisting of multiple /obj/machinery/pipes

	name = "pipeline"
	var/list/nodes = list()
	var/numnodes = 0
	var/datum/substance/gas/gas = null
	var/datum/substance/gas/ngas = null

	var/obj/machinery/vnode1
	var/obj/machinery/vnode2

	invisibility = 101
	capmult = 0
	var/flow = 0


/obj/machinery/pipes/flexipipe
	desc = "Flexible hose-like piping."
	name = "flexipipe"
	icon = 'wire.dmi'
	capacity = 10.0
	p_dir = 12.0
/obj/machinery/pipes/high_capacity
	desc = "A large bore pipe with high capacity."
	name = "high capacity"
	icon = 'hi_pipe.dmi'
	density = 1
	capacity = 1.8E7
/obj/machinery/pipes/regular
	desc = "A stretch of pipe."
	name = "normal pipe"
/obj/machinery/pipes/heat_exch
	icon = 'heat_pipe.dmi'
	name = "heat exchange pipe"
	desc = "A bundle of small pipes designed for maximum heat transfer."
	insulation = HEATPIPERATE

/obj/machinery/vehicle
	name = "Vehicle Pod"
	icon = 'escapepod.dmi'
	icon_state = "podfire"
	density = 1
	flags = FPRINT
	anchored = 1.0
	var/speed = 10.0
	var/maximum_speed = 10.0
	var/can_rotate = 1
	var/can_maximize_speed = 0
	var/one_person_only = 0

/obj/machinery/vehicle/pod
	name = "Escape Pod"
	icon = 'escapepod.dmi'
	icon_state = "pod"
	can_rotate = 0
	var/id = 1.0

/obj/machinery/vehicle/recon
	name = "Reconaissance Pod"
	icon = 'escapepod.dmi'
	icon_state = "recon"
	speed = 1.0
	maximum_speed = 30.0
	can_maximize_speed = 1
	one_person_only = 1

/obj/machinery/sec_lock
	name = "Security Pad"
	icon = 'stationobjs.dmi'
	icon_state = "sec_lock"
	var/obj/item/weapon/card/id/scan = null
	var/a_type = 0.0
	var/obj/machinery/door/d1 = null
	var/obj/machinery/door/d2 = null
	anchored = 1.0
	req_access = list(access_brig)

//*****RM
/obj/machinery/door_control
	name = "Remote Door Control"
	icon = 'stationobjs.dmi'
	icon_state = "doorctrl0"
	desc = "A remote control switch for a door."
	var/id = null
	anchored = 1.0
//*****

/obj/machinery/sleeper
	name = "Sleeper"
	icon = 'Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	var/mob/carbon/occupant = null
	anchored = 1.0
/obj/machinery/teleport
	name = "teleport"
	icon = 'stationobjs.dmi'
	density = 1
	anchored = 1.0
/obj/machinery/teleport/hub
	name = "hub"
	icon_state = "tele0"
	req_access = list(access_teleporter)
/obj/machinery/teleport/station
	name = "station"
	icon_state = "controller"
	var/active = 0
	var/engaged = 0
	req_access = list(access_teleporter)
/obj/machinery/wire
	name = "wire"
	icon = 'wire.dmi'


/obj/machinery/power
	name = null
	icon = 'power.dmi'
	anchored = 1.0
	var/datum/powernet/powernet = null
	var/netnum = 0
	var/directwired = 1		// by default, power machines are connected by a cable in a neighbouring turf
							// if set to 0, requires a 0-X cable on this turf
/obj/machinery/power/terminal
	name = "terminal"
	icon_state = "term"
	desc = "An underfloor wiring terminal for power equipment"
	level = 1
	var/obj/machinery/power/master = null
	anchored = 1
	directwired = 0		// must have a cable on same turf connecting to terminal

/obj/machinery/power/generator
	name = "generator"
	desc = "A high efficiency thermoelectric generator."
	icon_state = "teg"
	anchored = 1
	density = 1

	var/obj/machinery/circulator/circ1
	var/obj/machinery/circulator/circ2

	var/c1on = 0
	var/c2on = 0
	var/c1rate = 10
	var/c2rate = 10
	var/lastgen = 0
	var/lastgenlev = -1

/obj/machinery/power/monitor
	name = "Power Monitoring Computer"
	icon = 'stationobjs.dmi'
	icon_state = "power_computer"
	density = 1
	anchored = 1

	req_access = list(access_engine)

#define SMESMAXCHARGELEVEL 200000
#define SMESMAXOUTPUT 200000

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = 1
	anchored = 1
	var/output = 30000
	var/lastout = 0
	var/loaddemand = 0
	var/capacity = 5e6
	var/charge = 1e6
	var/charging = 0
	var/chargemode = 0
	var/chargecount = 0
	var/chargelevel = 30000
	var/online = 1
	var/n_tag = null
	var/obj/machinery/power/terminal/terminal = null

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'power.dmi'
	icon_state = "sp_base"
	anchored = 1
	density = 1
	directwired = 1
	var/health = 10.0
	var/id = 1
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH
	var/ndir = SOUTH
	var/obj/machinery/power/solar_control/control

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'enginecomputer.dmi'
	icon_state = "solar_con"
	anchored = 1
	density = 1
	directwired = 1
	var/id = 1
	var/cdir = 0
	var/gen = 0
	var/lastgen = 0
	var/track = 0			// on/off
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0

/obj/machinery/power/portable_gen
	name = "portable generator"
	desc = "A plasma-powered portable power generator."
	var/obj/item/weapon/tank/holding
	anchored = 0
	netnum = -1
	directwired = 0

/obj/machinery/compressor
	name = "compressor"
	desc = "The compressor stage of a gas turbine generator."
	icon = 'pipes.dmi'
	icon_state = "compressor"
	anchored = 1
	density = 1
	var/obj/machinery/power/turbine/turbine
	var/datum/substance/gas/gas
	var/turf/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6

/obj/machinery/power/turbine
	name = "gas turbine generator"
	desc = "A gas turbine used to for backup power generation."
	icon = 'pipes.dmi'
	icon_state = "turbine"
	anchored = 1
	density = 1
	var/obj/machinery/compressor/compressor
	directwired = 1
	var/turf/outturf
	var/lastgen



/obj/machinery/cell_charger
	name = "cell charger"
	desc = "A charging unit for power cells."
	icon = 'power.dmi'
	icon_state = "ccharger0"
	var/obj/item/weapon/cell/charging = null
	var/charge_level = -1
	var/charge_rate = 5
	anchored = 1

/obj/machinery/light_switch
	desc = "A light switch"
	name = null
	icon = 'power.dmi'
	icon_state = "light1"
	anchored = 1.0
	var/on = 1
	var/area/area = null
	var/otherarea = null
	luminosity = 2
/obj/cable
	level = 1
	anchored =1
	var/netnum = 0
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer."
	icon = 'power_cond.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	layer = 2.5

/obj/manifest
	name = "manifest"
	icon = 'screen1.dmi'
	icon_state = "x"
/obj/morgue
	name = "morgue"
	icon = 'stationobjs.dmi'
	icon_state = "morgue1"
	density = 1
	var/obj/m_tray/connected = null
	anchored = 1.0

/obj/overlay
	name = "overlay"
/obj/point
	name = "point"
	icon = 'screen1.dmi'
	icon_state = "arrow"
	layer = 16.0
/obj/portal
	name = "portal"
	icon = 'stationobjs.dmi'
	icon_state = "portal"
	density = 1
	var/obj/item/weapon/radio/beacon/target = null
	anchored = 1.0
	var/creator = null
/obj/projection
	name = "Projection"
	anchored = 1.0
/obj/rack
	name = "rack"
	icon = 'icons.dmi'
	icon_state = "rack"
	density = 1
	flags = FPRINT
	anchored = 1.0
/obj/screen
	name = "screen"
	icon = 'screen1.dmi'
	layer = 20.0
	var/id = 0.0
	var/obj/master
/obj/screen/close
	name = "close"
	master = null
/obj/screen/grab
	name = "grab"
	master = null
/obj/screen/storage
	name = "storage"
	master = null

/obj/shut_controller
	name = "shut controller"
	var/moving = null

	var/list/parts = list(  )

/obj/sp_start
	name = "sp start"
	icon = 'grashaboras.dmi'
	icon_state = "male_base"
	var/special = null
	anchored = 1.0
/obj/start
	name = "start"
	icon = 'screen1.dmi'
	icon_state = "x"
	anchored = 1.0
/obj/stool
	name = "stool"
	icon = 'icons.dmi'
	icon_state = "stool"
	flags = FPRINT
	weight = 100000
/obj/stool/bed
	name = "bed"
	icon_state = "bed"
	anchored = 1.0
/obj/stool/chair
	name = "chair"
	icon_state = "chair"
	var/status = 0.0
	anchored = 1.0
/obj/stool/chair/e_chair
	name = "electrified chair"
	icon_state = "e_chair0"
	var/atom/movable/overlay/overl = null
	var/on = 0.0
	var/obj/item/weapon/shock_kit/part1 = null
	var/last_time = 1.0
/obj/substance
	name = "substance"
	var/maximum
	var/temp
	var/co2
	var/n2
	var/oxygen
	var/plasma
	var/sl_gas
/obj/substance/chemical
	name = "chemical"
	maximum = null
	var/list/chemicals = list(  )		// contains /datum/chemical

/obj/table
	name = "table"
	icon = 'table.dmi'
	icon_state = "alone"
	density = 1
	anchored = 1.0
/obj/watertank
	name = "watertank"
	icon = 'stationobjs.dmi'
	icon_state = "watertank"
	density = 1
	flags = FPRINT
	weight = 5000000.0
/obj/weldfueltank
	name = "weldfueltank"
	icon = 'items.dmi'
	icon_state = "weldtank"
	density = 1
	flags = FPRINT
	weight = 5000000.0
/obj/window
	name = "window"
	icon = 'turfs2.dmi'
	icon_state = "window"
	desc = "A window."
	density = 1
	var/health = 14.0
	var/ini_dir = null
	var/state = 0
	var/reinf = 0
	weight = 2500000.0
	anchored = 1.0
	flags = 512.0


/obj/item/weapon/mouse_drag_pointer = MOUSE_ACTIVE_POINTER
/mob/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/item/weapon/clothing/mask/gasmask/voice_changer