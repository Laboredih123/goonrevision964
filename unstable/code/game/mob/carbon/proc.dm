/mob/carbon/is_muzzled()
	return istype(src.mask, /obj/item/weapon/clothing/mask/muzzle)

/mob/carbon/is_blindfolded()
	return istype(src.glasses, /obj/item/weapon/clothing/glasses/blindfold)

/mob/carbon/is_handcuffed()
	if (istype(src.handcuffs, /obj/item/weapon/handcuffs))
		return 1
	if(istype(src.suit, /obj/item/weapon/clothing/suit/straight_jacket))
		return 1
	return ..()

/mob/carbon/can_use_hands()
	if(src.is_handcuffed())
		return 0
	if(src.buckled && istype(src.buckled, /obj/stool/bed)) // buckling does not restrict hands
		return 0
	return ..()

/mob/carbon/is_active()
	if(src.knockdown > 0)
		return 0
	return ..()

/mob/carbon/is_conscious()
	if(src.knockout > 0)
		return 0
	return ..()

/mob/carbon/abiotic()
	if (src.l_hand && !( src.l_hand.abstract ))
		return 1
	if (src.r_hand && !( src.r_hand.abstract ))
		return 1
	if (src.back)
		return 1
	if (src.mask)
		return 1
	if (src.helmet)
		return 1
	if (src.shoes)
		return 1
	if (src.jumpsuit)
		return 1
	if (src.suit)
		return 1
	if (src.headset)
		return 1
	if (src.glasses)
		return 1
	if (src.gloves)
		return 1

/mob/carbon/verb/succumb()
	set hidden = 1

	if (src.get_damage() > src.unconsciousness_threshold)
		src.take_damage(suffocation = 200)
		usr << "\blue You have given up life and succumbed to death."

/mob/carbon/verb/show_dna()
	variables(canonical_dna)

/mob/carbon/verb/show_genes()
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			var/datum/canonical_locus/L = canonical_dna.data[i][j]
			if(!L.is_junk && L.associated_gene)
				usr << "at [i],[j] is [L.associated_gene.type]"
				for(var/a in L.alleles)
					if(L.alleles[a] != L.associated_gene.default)
						usr << "\tSet to [a] for [L.alleles[a]]"