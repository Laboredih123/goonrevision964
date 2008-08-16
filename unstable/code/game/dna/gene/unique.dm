//gene that's unique for every mob, so they're identifiable
//there will be multiple copies of this gene

/datum/gene/unique
	is_noticeable = 1
	default = "0"
	var/salt

	New()
		//attributes consist of "0" to "14"
		//because you can't have an integer key to a hash (dammit byond)
		//there are only 15 because otherwise there are problems with pick_allele_except
		attributes = list()
		for(var/i = 0; i < NUM_ALLELES - 1; i++)
			attributes += num2text(i)

	pick_attribute(mob/carbon/M)
		return num2text(rand(14))