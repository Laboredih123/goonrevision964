/datum/gene
	// is a string instead of a more sensible int because theres a good chance it'll be used as hash key
	// and byond is dumb
	var/const/JUNK = "junk"

	var/list/attributes = list(JUNK)
	var/num_loci = 1

	// if this is set to 1, changing this gene makes you "unknown"
	var/is_noticeable = 0

	// what you get if you choose an otherwise unassigned allele for this
	var/default = JUNK

	proc/pre_apply(mob/carbon/M)
		// first all the genes get pre_apply()ed, then they get apply()ed
		// for instance, if there were separate baldness and hair style genes,
		// both of their pre_apply would set hair_style to "short" or something like that
		// in apply(), baldness would do nothing or set it to "bald" depending on the attribute
		// in apply(), hair style would do nothing (if it were already "bald") or set it to the given hairstyle
		// this eliminates issues with one being apply()ed first
		return

	proc/apply(mob/carbon/M, attribute) //grants attribute to M
		return

	proc/choose_allele(mob/carbon/M, datum/canonical_locus/L)
		var/attribute = src.pick_attribute(M)
		if(attribute == default)
			return L.default_allele
		for(var/allele in L.alleles)
			if(L.alleles[allele] == attribute)
				return allele
		return L.default_allele

	proc/pick_attribute(mob/carbon/M)
		return JUNK

	proc/associate_with_loci(datum/dna/canonical/D)
		for(var/i = 0; i < src.num_loci; i++)
			var/datum/canonical_locus/L = D.get_random_junk_locus()
			src.associate_with_locus(L)
			L.is_junk = 0

	proc/associate_with_locus(datum/canonical_locus/L)
		L.associated_gene = src

		//fill with the default value
		for(var/allele in get_all_alleles())
			L.alleles[allele] = src.default

		//add in 1 copy each of the rest
		var/used = list(L.default_allele)
		for(var/attr in src.attributes)
			var/allele = pick_allele_except(used)
			L.alleles[allele] = attr
			used += allele