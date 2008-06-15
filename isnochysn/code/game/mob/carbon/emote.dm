/mob/carbon/var/const/sound = 1
/mob/carbon/var/const/sight = 2

/mob/carbon/proc/emote(message, medium)
	if (!message)
		return
	if(!medium)
		medium = sight
	var/list/mobs_seen = list()
	if(medium & sight)
		for(var/mob/M in viewers())
			if(!M in mobs_seen)
				if(M.see("[src] [message]"))
					mobs_seen += M
	if(medium & sound)
		for(var/mob/M in hearers())
			if(!M in mobs_seen)
				if(M.hear("someone [message]"))
					mobs_seen += M

/mob/carbon/proc/is_muzzled()
	return istype(src.mask, /obj/item/weapon/clothing/mask/muzzle)

/mob/carbon/proc/is_blindfolded()
	return istype(src.glasses, /obj/item/weapon/clothing/glasses/blindfold)

/mob/carbon/proc/is_handcuffed() //in cuffs or straitjacket
	return istype(src.handcuffs, /obj/item/weapon/handcuffs) || istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket)

/mob/carbon/proc/is_restrained()
	if(src.buckled)
		return 1
	return 0

/mob/carbon/verb/emote_help()
	src << "The valid emotes are: blink, blush, bow \[at person\], choke, chuckle, clap, cough, cry,  eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,\ngrin, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,\nwink, yawn"

/mob/carbon/verb/chuckle()
	set name = ".chuckle"
	if(!src.is_muzzled())
		src.emote("chuckles", sound & sight)
	else
		src.emote("makes a noise", sound & sight)
	//freedom implant!
	for(var/obj/item/weapon/implant/I in src)
		if(I.implanted)
			I.trigger(src)

/mob/carbon/verb/blink()
	set name = ".blink"
	if(!src.is_blindfolded())
		src.emote("blinks")

/mob/carbon/verb/blush()
	set name = ".blush"
	src.emote("blushes")

/mob/carbon/verb/bow(mob/M as mob)
	set name = ".bow"
	set M in oview(src)
	if(src.is_restrained())
		return
	if(M)
		src.emote("bows to [M]")
	else
		src.emote("bows")

/mob/carbon/verb/choke()
	set name = ".choke"
	src.emote("chokes", sound & sight)

/mob/carbon/verb/clap()
	set name = ".clap"
	if(!src.is_handcuffed() && !src.is_restrained())
		src.emote("claps", sound & sight)

/mob/carbon/verb/cry()
	set name = ".cry"
	src.emote("cries", sound & sight)

/mob/carbon/verb/cough()
	set name = ".cough"
	if(!src.is_muzzled())
		src.emote("coughs", sound & sight)
	else
		src.emote("makes a noise", sound & sight)

/mob/carbon/verb/eyebrow()
	set name = ".eyebrow"
	if(!src.is_blindfolded())
		src.emote("raises an eyebrow")

/mob/carbon/verb/frown()
	set name = ".frown"
	if(!src.is_muzzled())
		src.emote("frowns")

/mob/carbon/verb/faint()
	set name = ".faint"
	src.emote("faints")
	src.sleeping = 1

/mob/carbon/verb/gasp()
	set name = ".gasp"
	if(!src.is_muzzled())
		src.emote("gasps!", sound & sight)
	else
		src.emote("makes a weak noise", sound & sight)

/mob/carbon/verb/glare(mob/M as mob)
	set name = ".glare"
	set M in oview(src)
	if(src.is_blindfolded())
		return
	if(M)
		src.emote("glares at [M]")
	else
		src.emote("glares")

/mob/carbon/verb/grin()
	set name = ".grin"
	if(!src.is_muzzled())
		src.emote("grins")

/mob/carbon/verb/groan()
	set name = ".groan"
	if(!src.is_muzzled())
		src.emote("groans", sound & sight)
	else
		src.emote("makes a noise", sound & sight)

/mob/carbon/verb/grumble()
	set name = ".grumble"
	if(!src.is_muzzled())
		src.emote("grumbles", sound & sight)
	else
		src.emote("makes a noise", sound & sight)

/mob/carbon/verb/laugh()
	set name = ".laugh"
	if(!src.is_muzzled())
		src.emote("laughs", sound & sight)
	else
		src.emote("makes a noise", sound & sight)

/mob/carbon/verb/look(mob/M as mob)
	set name = ".look"
	set M in oview(src)
	if(src.is_blindfolded())
		return
	if(M)
		src.emote("looks at [M]")
	else
		src.emote("looks")

/mob/carbon/verb/moan()
	set name = ".moan"
	if(!src.is_muzzled())
		src.emote("moans", sound & sight)
	else
		src.emote("makes a noise", sound & sight)

/mob/carbon/verb/mumble()
	set name = ".mumble"
	if(!src.is_muzzled())
		src.emote("mumbles", sound & sight)
	else
		src.emote("makes a noise", sound & sight)

/mob/carbon/verb/nod()
	set name = ".nod"
	src.emote("nods")

/mob/carbon/verb/twitch()
	set name = ".twitch"
	src.emote("twitches")

/mob/carbon/verb/salute(mob/M as mob)
	set name = ".salute"
	set M in oview(src)
	if(src.is_restrained())
		return
	if(M)
		src.emote("salutes [M]")
	else
		src.emote("salutes")

/mob/carbon/verb/shake()
	set name = ".shake"
	src.emote("shakes [src.gender == MALE ? "his" : "her"] head") //can't use a macro here, sadly

/mob/carbon/verb/shiver()
	set name = ".shiver"
	src.emote("shivers")

/mob/carbon/verb/shrug()
	set name = ".shrug"
	src.emote("shrugs")

/mob/carbon/verb/sigh()
	set name = ".sigh"
	if(!src.is_muzzled())
		src.emote("sighs", sound & sight)
	else
		src.emote("makes a weak noise", sound & sight)

/mob/carbon/verb/smile()
	set name = ".smile"
	if(!src.is_muzzled())
		src.emote("smiles")

/mob/carbon/verb/snore()
	set name = ".snore"
	if(!src.is_muzzled())
		src.emote("snores", sound & sight)
	else
		src.emote("makes a loud noise", sound & sight)

/mob/carbon/verb/wink(mob/M as mob)
	set name = ".wink"
	set M in oview(src)
	if(src.is_blindfolded())
		return
	if(M)
		src.emote("winks at [M]")
	else
		src.emote("winks")

/mob/carbon/verb/yawn()
	set name = ".yawn"
	if(!src.is_muzzled())
		src.emote("yawns")