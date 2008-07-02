/var/const/
	ALLELE_AA = "AA"
	ALLELE_AC = "AC"
	ALLELE_AG = "AG"
	ALLELE_AT = "AT"
	ALLELE_CA = "CA"
	ALLELE_CC = "CC"
	ALLELE_CG = "CG"
	ALLELE_CT = "CT"
	ALLELE_GA = "GA"
	ALLELE_GC = "GC"
	ALLELE_GG = "GG"
	ALLELE_GT = "GT"
	ALLELE_TA = "TA"
	ALLELE_TC = "TC"
	ALLELE_TG = "TG"
	ALLELE_TT = "TT"
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
	if(RANDOMIZE_DNA)
		return pick(get_all_alleles())
	else
		return ALLELE_AA

/proc/pick_allele_except(val)
	if(RANDOMIZE_DNA)
		return pick(get_all_alleles() - val)
	else
		var/list/L = get_all_alleles() - val
		return L[1]