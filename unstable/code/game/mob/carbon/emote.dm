/mob/carbon/var/const/SENSE_SOUND = 1
/mob/carbon/var/const/SENSE_SIGHT = 2

/mob/carbon/proc/emote(message, medium)
	if (!message)
		return
	if(!medium)
		medium = SENSE_SIGHT
	var/list/mobs_seen = list()
	if(medium & SENSE_SIGHT)
		for(var/mob/M in viewers())
			if(!M in mobs_seen)
				if(M.see("[src] [message]"))
					mobs_seen += M
	if(medium & SENSE_SOUND)
		for(var/mob/M in hearers())
			if(!M in mobs_seen)
				if(M.hear("someone [message]"))
					mobs_seen += M

/mob/carbon/verb/emote_help()
	src << "The valid emotes are: blink, blush, bow \[at person\], choke, chuckle, clap, cough, cry,  eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,\ngrin, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,\nwink, yawn"

/mob/carbon/verb/chuckle()
	set name = ".chuckle"
	if(!src.is_muzzled())
		src.emote("chuckles", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a noise", SENSE_SOUND & SENSE_SIGHT)
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

/mob/carbon/verb/bow(mob/M as mob in oview(src))
	set name = ".bow"
	if(src.is_handcuffed())
		return
	if(M)
		src.emote("bows to [M]")
	else
		src.emote("bows")

/mob/carbon/verb/choke()
	set name = ".choke"
	src.emote("chokes", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/clap()
	set name = ".clap"
	if(src.can_use_hands())
		src.emote("claps", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/cry()
	set name = ".cry"
	src.emote("cries", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/cough()
	set name = ".cough"
	if(!src.is_muzzled())
		src.emote("coughs", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a noise", SENSE_SOUND & SENSE_SIGHT)

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
		src.emote("gasps!", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a weak noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/glare(mob/M as mob in oview(src))
	set name = ".glare"
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
		src.emote("groans", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/grumble()
	set name = ".grumble"
	if(!src.is_muzzled())
		src.emote("grumbles", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/laugh()
	set name = ".laugh"
	if(!src.is_muzzled())
		src.emote("laughs", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/look(mob/M as mob in oview(src))
	set name = ".look"
	if(src.is_blindfolded())
		return
	if(M)
		src.emote("looks at [M]")
	else
		src.emote("looks")

/mob/carbon/verb/moan()
	set name = ".moan"
	if(!src.is_muzzled())
		src.emote("moans", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/mumble()
	set name = ".mumble"
	if(!src.is_muzzled())
		src.emote("mumbles", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/nod()
	set name = ".nod"
	src.emote("nods")

/mob/carbon/verb/twitch()
	set name = ".twitch"
	src.emote("twitches")

/mob/carbon/verb/salute(mob/M as mob in oview(src))
	set name = ".salute"
	if(src.is_handcuffed())
		return
	if(M)
		src.emote("salutes [M]")
	else
		src.emote("salutes")

/mob/carbon/verb/shake()
	set name = ".shake"
	src.emote("shakes [src.gender == MALE ? "his" : "her"] head")

/mob/carbon/verb/shiver()
	set name = ".shiver"
	src.emote("shivers")

/mob/carbon/verb/shrug()
	set name = ".shrug"
	src.emote("shrugs")

/mob/carbon/verb/sigh()
	set name = ".sigh"
	if(!src.is_muzzled())
		src.emote("sighs", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a weak noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/smile()
	set name = ".smile"
	if(!src.is_muzzled())
		src.emote("smiles")

/mob/carbon/verb/snore()
	set name = ".snore"
	if(!src.is_muzzled())
		src.emote("snores", SENSE_SOUND & SENSE_SIGHT)
	else
		src.emote("makes a loud noise", SENSE_SOUND & SENSE_SIGHT)

/mob/carbon/verb/wink(mob/M as mob in oview(src))
	set name = ".wink"
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

/mob/carbon/verb/tail()
	set name = ".tail"
	if(src.appearance == APPEARANCE_MONKEY)
		src.emote("waves [src.gender == MALE ? "his" : "her"] tail")