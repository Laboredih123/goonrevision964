/var/const/
	ALLELE_AA = 1
	ALLELE_AC = 2
	ALLELE_AG = 3
	ALLELE_AT = 4
	ALLELE_CA = 5
	ALLELE_CC = 6
	ALLELE_CG = 7
	ALLELE_CT = 8
	ALLELE_GA = 9
	ALLELE_GC = 10
	ALLELE_GG = 11
	ALLELE_GT = 12
	ALLELE_TA = 13
	ALLELE_TC = 14
	ALLELE_TG = 15
	ALLELE_TT = 16
	TOTAL_NUM_ALLELES = 16

/proc/get_all_alleles()
	return list(
		ALLELE_AA,
		ALLELE_AC,
		ALLELE_AG,
		ALLELE_AT,
		ALLELE_CA,
		ALLELE_CC,
		ALLELE_CG,
		ALLELE_CT,
		ALLELE_GA,
		ALLELE_GC,
		ALLELE_GG,
		ALLELE_GT,
		ALLELE_TA,
		ALLELE_TC,
		ALLELE_TG,
		ALLELE_TT
	)

/proc/pick_allele()
	return rand(get_all_alleles())

/proc/pick_allele_except(val)
	return rand(get_all_alleles() - val)