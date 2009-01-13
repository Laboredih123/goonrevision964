/var/const
	BLOOD_O = "O"
	BLOOD_A = "A"
	BLOOD_B = "B"
	BLOOD_AB = "AB"

/datum/gene/bloodtype
	is_noticeable = 0
	default = BLOOD_O

	New()
		attributes = get_blood_types()

	apply(mob/carbon/M, attribute)
		M.bloodtype = attribute

	pick_attribute(mob/carbon/M)
		return M.bloodtype

/proc/get_blood_types()
	return list(BLOOD_O, BLOOD_A, BLOOD_B, BLOOD_AB)

/proc/get_random_blood_type()
	//based on blood type distributions in USA, from wikipedia/Blood Type
	return pick(
		374+66; BLOOD_O,
		357+63; BLOOD_A,
		85+15; BLOOD_B,
		34+6; BLOOD_AB
	)

