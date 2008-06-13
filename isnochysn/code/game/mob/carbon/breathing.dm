/mob/carbon/proc/aircheck(obj/substance/gas/G as obj)

	src.t_oxygen = 0
	src.t_plasma = 0
	if (G)
		var/a_oxygen = G.oxygen * 0.7
		var/a_plasma = G.plasma
		var/a_sl_gas = G.sl_gas * 0.7
		G.oxygen -= a_oxygen
		G.plasma -= a_plasma
		G.sl_gas -= a_sl_gas
		if (a_oxygen < 67.032)
			src.t_oxygen = round( (67.032 - a_oxygen) / 5) + 1
		if (G.co2 > 5)
			var/t = round((G.co2 - 5) / 5) + 1
			if (G.co2 > 25)
				src.paralysis = max(src.paralysis, 3)
				if (G.co2 > 50)
					t = 50
			src.t_oxygen = max(src.t_oxygen, t)
		if (a_plasma > 5)
			src.t_plasma = round(a_plasma / 10) + 1
			if ((src.wear_mask && src.wear_mask.a_filter >= 4))
				src.t_plasma = max(src.t_plasma - 40, 0)
		if (a_sl_gas > 10)
			src.weakened = max(src.weakened, 3)
			if (a_sl_gas > 40)
				src.paralysis = max(src.paralysis, 3)

		G.co2 += a_oxygen  // was * 0.6  - changed to increase CO2 output rate of breathing

	return