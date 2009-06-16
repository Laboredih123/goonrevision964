/obj/closet/secure
	desc = "An immobile card-locked storage closet."
	name = "Security Locker"
	icon = 'stationobjs.dmi'
	icon_state = "1secloset0"
	var/orig_icon_state = "secloset"
	density = 1
	var/locked = 1.0
	var/broken = 0

/obj/closet/secure/get_closed_icon_state()
	return "[src.locked ? 1 : null][src.orig_icon_state]0"

/obj/closet/secure/get_open_icon_state()
	return "[src.orig_icon_state]1"

/obj/closet/secure/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W)
			W.loc = src.loc
	else if(src.broken)
		user << "\red It appears to be broken."
		return
	else if(istype(W, /obj/item/weapon/card/emag) && !src.broken)
		src.broken = 1
		src.locked = 0
		src.icon = 'secloset_broken.dmi'
		src.icon_state = "[orig_icon_state]0"
		user.show_viewers(text("\blue The locker has been broken by [user] with an electromagnetic card!"))
	else if(src.allowed(user))
		src.locked = !( src.locked )
		user.show_viewers(text("\blue The locker has been []locked by [].", (src.locked ? null : "un"), user))
		src.icon_state = text("[][orig_icon_state]0", (src.locked ? "1" : null))
	else
		user << "\red Access Denied"
	return

/obj/closet/secure/relaymove(mob/user as mob)

	if (!user.is_active())
		return
	if (!( src.locked ))
		src.open()
	else
		user << "\blue It's welded shut!"
		if(usr.can_use_hands()) //handcuffed folk can't bang
			for(var/mob/M in hearers(null, src))
				M << text("<FONT size=[]>BANG, bang!</FONT>", max(0, 5 - get_dist(src, M)))
	return

/obj/closet/secure/interact(mob/user as mob)

	src.add_fingerprint(user)
	if (!src.opened && !src.locked)
		src.open()
	else if(src.opened)
		src.close()
	else
		return src.attackby(null, user)
	return

/obj/closet/secure/animal
	name = "Animal Control"
	req_access = list(access_medical_supplies)
/obj/closet/secure/highsec
	name = "Experimental Technology"
	req_access = list(access_heads)
/obj/closet/secure/captains
	name = "Captain's Closet"
	req_access = list(access_captain)
/obj/closet/secure/medical1
	name = "Medicine Closet"
	req_access = list(access_medical_supplies)
/obj/closet/secure/medical2
	name = "Anesthetic"
	req_access = list(access_medical_supplies)
/obj/closet/secure/personal
	desc = "The first card swiped gains control."
	name = "Personal Closet"
	icon_state = "0secloset0"
	req_access = list(access_all_personal_lockers)
	var/registered = null
/obj/closet/secure/security1
	name = "Security Equipment"
	req_access = list(access_security_lockers)
/obj/closet/secure/security2
	name = "Forensics Locker"
	req_access = list(access_forensics_lockers)
/obj/closet/secure/toxin
	name = "Toxin Researcher Locker"
	req_access = list(access_tox_storage)

/obj/closet/secure/emergency
	desc = "A bulky (yet mobile) closet. Comes prestocked with a gasmask and o2 tank for emergencies."
	name = "Emergency Closet"
	req_access = list(access_emergency)
	icon_state = "1emcloset0"
	orig_icon_state = "emcloset"

	New()
		..()
		sleep(2)
		new /obj/item/weapon/tank/oxygentank(src)
		new /obj/item/weapon/clothing/mask/gasmask(src)

/obj/closet/secure/personal/New()

	..()
	sleep(2)
	new /obj/item/weapon/radio/signaller( src )
	new /obj/item/weapon/pen( src )
	new /obj/item/weapon/storage/backpack( src )
	new /obj/item/weapon/radio/headset( src )
	return

/obj/closet/secure/personal/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)

	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W)
			W.loc = src.loc
	else if (istype(W, /obj/item/weapon/card/id))
		if(src.broken)
			user << "\red It appears to be broken."
			return
		var/obj/item/weapon/card/id/I = W
		if (src.allowed(user) || !src.registered || (istype(W, /obj/item/weapon/card/id) && src.registered == I.registered))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !( src.locked )
			user.show_viewers(text("\blue The locker has been []locked by [].", (src.locked ? null : "un"), user))
			src.icon_state = text("[][orig_icon_state]0", (src.locked ? "1" : null))
			if (!src.registered)
				src.registered = I.registered
				src.desc = "Owned by [I.registered]."
		else
			user << "\red Access Denied"
	else if(istype(W, /obj/item/weapon/card/emag) && !src.broken)
		src.broken = 1
		src.locked = 0
		src.desc = "It appears to be broken."
		src.icon = 'secloset_broken.dmi'
		src.icon_state = "[orig_icon_state]0"
		user.show_viewers(text("\blue The locker has been broken by [user] with an electromagnetic card!"))
	else
		user << "\red Access Denied"
	return

/obj/closet/secure/security2/New()
	..()
	sleep(2)
	new /obj/item/weapon/clothing/under/red( src )
	new /obj/item/weapon/storage/fcard_kit( src )
	new /obj/item/weapon/storage/fcard_kit( src )
	new /obj/item/weapon/storage/fcard_kit( src )
	new /obj/item/weapon/storage/lglo_kit( src )
	new /obj/item/weapon/storage/lglo_kit( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/fcardholder( src )
	new /obj/item/weapon/f_print_scanner( src )
	new /obj/item/weapon/f_print_scanner( src )
	new /obj/item/weapon/f_print_scanner( src )
	return

/obj/closet/secure/security1/New()
	..()
	sleep(2)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/gun/energy/taser_gun(src)
	new /obj/item/weapon/flash(src)
	new /obj/item/weapon/clothing/under/red(src)
	new /obj/item/weapon/clothing/shoes/brown(src)
	new /obj/item/weapon/clothing/suit/armor(src)
	new /obj/item/weapon/clothing/head/helmet(src)
	new /obj/item/weapon/clothing/glasses/sunglasses(src)
	new /obj/item/weapon/baton(src)
	return

/obj/closet/secure/highsec/New()

	..()
	sleep(2)
	new /obj/item/weapon/gun/energy/laser_gun( src )
	new /obj/item/weapon/gun/energy/taser_gun( src )
	new /obj/item/weapon/flash( src )
	new /obj/item/weapon/storage/id_kit( src )
	new /obj/item/weapon/clothing/under/hopgreen( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/glasses/sunglasses( src )
	new /obj/item/weapon/clothing/suit/armor( src )
	new /obj/item/weapon/clothing/head/helmet( src )
	return

/obj/closet/secure/captains/New()

	..()
	sleep(2)
	new /obj/item/weapon/gun/energy/laser_gun( src )
	new /obj/item/weapon/gun/energy/taser_gun( src )
	new /obj/item/weapon/storage/id_kit( src )
	new /obj/item/weapon/clothing/under/darkgreen( src )
	new /obj/item/weapon/clothing/shoes/brown( src )
	new /obj/item/weapon/clothing/glasses/sunglasses( src )
	new /obj/item/weapon/clothing/suit/armor( src )
	new /obj/item/weapon/clothing/head/helmet/swat_hel( src )
	return

/obj/closet/secure/animal/New()

	..()
	sleep(2)
	new /obj/item/weapon/radio/signaller( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	new /obj/item/weapon/radio/electropack( src )
	return

/obj/closet/secure/medical1/New()

	..()
	sleep(2)
	new /obj/item/weapon/bottle/toxins( src )
	new /obj/item/weapon/bottle/rejuvenators( src )
	new /obj/item/weapon/bottle/s_tox( src )
	new /obj/item/weapon/bottle/s_tox( src )
	new /obj/item/weapon/bottle/toxins( src )
	new /obj/item/weapon/bottle/r_epil( src )
	new /obj/item/weapon/bottle/r_ch_cough( src )
	new /obj/item/weapon/pill_canister/Tourette( src )
	new /obj/item/weapon/pill_canister/cough( src )
	new /obj/item/weapon/pill_canister/epilepsy( src )
	new /obj/item/weapon/pill_canister/sleep( src )
	new /obj/item/weapon/pill_canister/antitoxin( src )
	new /obj/item/weapon/pill_canister/placebo( src )
	new /obj/item/weapon/storage/firstaid/syringes( src )
	new /obj/item/weapon/storage/gl_kit( src )
	new /obj/item/weapon/dropper( src )
	return

/obj/closet/secure/medical2/New()

	..()
	sleep(2)
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	new /obj/item/weapon/clothing/mask/m_mask( src )
	return

/obj/closet/secure/toxin/New()

	..()
	sleep(2)
	new /obj/item/weapon/tank/oxygentank( src )
	new /obj/item/weapon/clothing/mask/gasmask( src )
	new /obj/item/weapon/clothing/suit/bio_suit( src )
	new /obj/item/weapon/clothing/under/toxinswhite( src )
	new /obj/item/weapon/clothing/shoes/white( src )
	new /obj/item/weapon/clothing/head/bio_hood( src )
	new /obj/item/weapon/clothing/suit/labcoat(src)

	return