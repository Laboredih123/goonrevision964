/mob/carbon/human/get_default_radio()
	return src.w_radio

/mob/carbon/proc/get_fave_radio(id)
	if(id == "h")
		return src.w_radio