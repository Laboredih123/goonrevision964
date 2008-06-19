/obj/machinery/computer/dna
	name = "DNA operations computer"
	icon = 'Cryogenic2.dmi'
	icon_state = "dna_computer"
	var/obj/item/weapon/card/data/scan = null
	var/obj/item/weapon/card/data/modify = null
	var/obj/item/weapon/card/data/modify2 = null
	var/mode = null
	var/temp = null

/obj/machinery/computer/dna/interact(mob/user as mob)
	. = ..()
	if(!.) return

	user.machine = src
	var/dat = {"<I>Please Insert the cards into the slots</I>
		<BR>Function Disk: <A href='?src=\ref[src];scan=1'>[src.scan ? src.scan.name : "----------"]</A>
		<BR>Target Disk: <A href='?src=\ref[src];modify=1'>[src.modify ? src.modify.name : "----------"]</A>
		<BR>Aux. Data Disk: <A href='?src=\ref[src];modify2=1'>[src.modify2 ? src.modify2.name : "----------"]</A>
		<BR>[src.scan ? "<A href='?src=\ref[src];execute=1'>Execute Function</A>" : "No function disk inserted!"]"}
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='?src=\ref[src];clear=1'>Clear Message</A>"
	user << browse(dat, "window=dna_comp")

/obj/machinery/computer/dna/Topic(href, href_list)
	. = ..()
	if(!.) return
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.loc = src.loc
			src.modify = null
			src.mode = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/weapon/card/data))
				usr.drop_item()
				I.loc = src
				src.modify = I
			src.mode = null
	//TODO: update
	src.add_fingerprint(usr)
	src.updateUsrDialog()

	return

/obj/machinery/computer/dna/ex_act(severity)
	switch(severity)
		if(1)
			del(src)
			return
		if(2)
			if (prob(50))
				del(src)
				return

/obj/machinery/computer/dna/New()
	..()
	spawn( 5 )
		for(var/obj/machinery/dna_scanner/x in oview(src, 1)) //connect it to the first one it sees
			src.connected = x
			return
	return