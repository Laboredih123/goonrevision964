/mob/carbon/var/const
	ATTACK_BITE = 1
	ATTACK_PUNCH = 2


/mob/carbon/interact_cuffed(mob/carbon/M as mob)
	if((M.a_intent == "hurt" || M.a_intent == "disarm") && M.attack_type == ATTACK_BITE) //can still bite while cuffed
		return src.interact(M)
	return

/mob/carbon/interact(mob/M as mob)
	if(M.is_dead())
		return
	if (src.jumpsuit)
		src.jumpsuit.add_fingerprint(M)
	if (M.a_intent == "help")
		if (src.get_damage() > src.unconsciouness_threshold)
			src.sleeping = 0
			src.resting = 0
			src.show_viewers("\blue [M] shakes [src] trying to wake \him[src] up!")
		else if (src.death_threshold - src.get_damage() > 25) // still can survive
			if ((M.helmet && M.helmet.flags & HEADSPACE) || M.mask || (src.helmet && src.helmet.flags & HEADSPACE) || src.mask)
				M.think("\blue <B>Remove that mask!</B>")
				return
			var/obj/equip_e/O = new /obj/equip_e()
			O.source = M
			O.target = src
			O.s_loc = M.loc
			O.t_loc = src.loc
			O.place = "CPR"
			src.requests += O
			spawn( 0 )
				O.process()
	else if(M.a_intent == "grab")
		if (M == src)
			return
		var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M )
		G.assailant = M
		if (M.hand)
			M.l_hand = G
		else
			M.r_hand = G
		G.layer = 20
		G.affecting = src
		src.grabbed_by += G
		G.synch()
		src.show_viewers("\red [M] has grabbed [src] passively!")
	else if(M.a_intent == "disarm")
		if(!M.can_use_hands())
			return
		if(!M.has_super_strength())
			var/randn = rand(1, 100)
			if (randn <= 25)
				if (!src.lying)
					src.show_viewers("\red <B>[M] has pushed down [src]!</B>")
				src.knockdown_until(3)
			else if (randn <= 60)
				src.drop_item()
				src.show_viewers("\red <B>[M] has disarmed [src]!</B>")
			else
				src.show_viewers("\red <B>[M] has attempted to disarm [src]!</B>")
		else
			src.knockout_until(20)
			src.show_viewers("\red <b>[M] has punched out [src] with superhuman strength!</b>
	else if(M.a_intent == "harm")
		if(M.attack_type == ATTACK_BITE)
			if(M.is_muzzled())
				return
			var/success = 1
			if(istype(src.suit, /obj/item/weapon/clothing/suit/sp_suit) && prob(95))
				success = 0
			else if(istype(src.suit, /obj/item/weapon/clothing/suit/armor) && prob(60))
				success = 0
			else if(istype(src.suit, /obj/item/weapon/clothing/suit/bio_suit) && prob(90))
				success = 0
			else if(istype(src.suit, /obj/item/weapon/clothing/suit/swat_suit) && prob(95))
				success = 0
			else if(prob(25))
				success = 0
			if(!success)
				src.show_viewers("\red <b>[M] has attempted to bite [src]!</b>")
			else
				src.show_viewers("\red <B>[M] has bitten [src]!</B>")
				src.take_damage(brute = 5)
				if(M.is_infectious)
					src.infected_by(M)
		else if(M.attack_type == ATTACK_PUNCH)
			if (M.can_use_hands())
				return
			if(!M.has_super_strength())
				var/success = 1
				if(istype(src.suit, /obj/item/weapon/clothing/suit/sp_suit) && prob(50))
					success = 0
				else if(istype(src.suit, /obj/item/weapon/clothing/suit/armor) && prob(60))
					success = 0
				else if(istype(src.suit, /obj/item/weapon/clothing/suit/swat_suit) && prob(80))
					success = 0
				else if(prob(25))
					success = 0
				if(!success)
					src.show_viewers("\red <b>[M] has attempted to punch [src]!</b>")
				else
					src.show_viewers("\red <B>[M] has punched [src]!</B>")
					src.take_damage(brute = 5)
					if(M.is_infectious)
						src.infected_by(M)
			else
				src.knockout_until(20)
				src.show_viewers("\red <b>[M] has punched out [src] with superhuman strength!</b>
				src.take_damage(brute = 20)
				if(M.is_infectious)
						src.infected_by(M)
