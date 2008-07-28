/var/const
	BLOOD_OPOS = "O+"
	BLOOD_APOS = "A+"
	BLOOD_BPOS = "B+"
	BLOOD_ABPOS = "AB+"
	BLOOD_ONEG = "O-"
	BLOOD_ANEG = "A-"
	BLOOD_BNEG = "B-"
	BLOOD_ABNEG = "AB-"

/datum/gene/bloodtype
	is_noticeable = 0
	default = BLOOD_OPOS

	New()
		attributes = get_blood_types()
	
	apply(mob/carbon/M, attribute)
		M.bloodtype = attribute

	pick_attribute(mob/carbon/M)
		return M.bloodtype

/proc/get_blood_types()
	return list(BLOOD_OPOS, BLOOD_APOS, BLOOD_BPOS, BLOOD_ABPOS, BLOOD_ONEG, BLOOD_ANEG, BLOOD_BNEG, BLOOD_ABNEG)

/proc/get_random_blood_type()
	return pick(
		374; BLOOD_OPOS,
		357; BLOOD_APOS,
		85; BLOOD_BPOS,
		34; BLOOD_ABPOS,
		66; BLOOD_ONEG,
		63; BLOOD_ANEG,
		15; BLOOD_BNEG,
		6; BLOOD_ABNEG
	)

