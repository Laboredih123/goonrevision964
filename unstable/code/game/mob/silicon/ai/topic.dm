/mob/silicon/ai/Topic(href, href_list)
	..()
	if(href_list["mach_close"] && href_list["mach_close"] == "aialerts")
		src.viewalerts = 0
	if(href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"]))
	if (href_list["showalerts"])
		ai_alerts()