/obj/machinery/cell_charger/New(location,charge_rate)
	..(location)
	if(charge_rate != null) src.charge_rate = charge_rate

/obj/machinery/cell_charger/attackby(obj/item/weapon/W, mob/carbon/user)
	if(stat & BROKEN) return
	if(!istype(W,/obj/item/weapon/cell)) return
	if(src.charging)
		user << "There is already a cell in the charger."
		return

	user.drop_item()
	src.charging = W
	W.loc = src
	user << "You insert the cell into the charger."
	src.charge_level = -1
	src.updateicon()

/obj/machinery/cell_charger/proc/updateicon()
	icon_state = "ccharger[charging ? 1 : 0]"
	if(!charging || (stat & (BROKEN|NOPOWER)))
		overlays = null
		return

	var/newlevel = round(charging.percent() * 4.0 / 99)
	if(charge_level == newlevel) return
	overlays = null
	overlays += image('power.dmi', "ccharger-o[newlevel]")
	charge_level = newlevel

/obj/machinery/cell_charger/interact(mob/carbon/user)
	if(!istype(user, /mob/carbon))	return
	add_fingerprint(user)
	if(!charging || stat & (NOPOWER|BROKEN)) return

	charging.loc = usr
	charging.layer = 20
	var/holder
	if(user.hand)	holder = user.l_hand
	else			holder = user.r_hand
	if(holder) return
	holder = charging
	charging.add_fingerprint(user)
	charging.updateicon()
	src.charging = null
	user << "You remove the cell from the charger."
	charge_level = -1
	updateicon()

/obj/machinery/cell_charger/process()
	if(!charging || (stat & (BROKEN|NOPOWER))) return
	var/newch = min(src.charge_rate, charging.maxcharge-charging.charge)
	if(!newch) charging = 0
	else
		use_power(newch / CELLRATE)
		charging.recharge(newch)
	updateicon()
