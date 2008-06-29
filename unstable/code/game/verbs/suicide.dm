/mob/var/suiciding = 0
/mob/carbon/verb/suicide()
	if (src.is_dead)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is holding \his breath. It looks like \he's trying to commit suicide.</b>"
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		src.take_damage(suffocation = 175 - src.get_damage())
		spawn(200) //in case they get revived by cryo chamber or something stupid like that, let them suicide again in 20 seconds
			src.suiciding = 0

/mob/silicon/verb/suicide()
	if (src.is_dead)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is powering down. It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		src.take_damage(electricity = 175 - src.get_damage())
		spawn(200) //let them suicide again in 20 seconds
			src.suiciding = 0
