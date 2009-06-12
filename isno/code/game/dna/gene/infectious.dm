/var/const/INFECTIOUS = "virusy"

/datum/gene/infectious
	default = JUNK

	New()
		attributes = list(INFECTIOUS)

	apply(mob/carbon/M, attribute)
		M.is_infectious = (attribute == INFECTIOUS)

	pick_attribute(mob/carbon/M)
		if(M.is_infectious)
			return INFECTIOUS
		else
			return JUNK

/mob/carbon/proc/infected_by(mob/carbon/M)
	//TODO: make this not be instantaneous
	src.dna = M.dna
	src.dna.apply()