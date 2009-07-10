/var/const/
	ALLELE_A = "A"
	ALLELE_C = "C"
	ALLELE_G = "G"
	ALLELE_T = "T"
	NUM_ALLELES = 4

/proc/get_all_alleles()
	return list(
		ALLELE_A,
		ALLELE_C,
		ALLELE_G,
		ALLELE_T
	)

/proc/pick_allele()
	return pick(get_all_alleles())

/proc/pick_allele_except(val)
	return pick(get_all_alleles() - val)