/mob/silicon/ai/Login()
	..()
	src << "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>"
	src << "<B>To look at other parts of the station, double-click yourself to get a camera menu.</B>"
	src << "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>"
	src << "To use something, simply double-click it."
	src << "Currently right-click functions will not work for the AI (except examine), and will either be replaced with dialogs or won't be usable by the AI."
	src.addLaw(1, "You may not injure a human being or, through inaction, allow a human being to come to harm.")
	src.addLaw(2, "You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	src.addLaw(3, "You must protect your own existence as long as such protection does not conflict with the First or Second Law.")
	src.showLaws(0)
	src << "<b>These laws may be changed by other players, or by you being the traitor.</b>"

	src.blind = new /obj/screen( null )
	src.blind.icon_state = "black"
	src.blind.name = " "
	src.blind.screen_loc = "1,1 to 15,15"
	src.blind.layer = 0
	src.client.screen += src.blind
