/mob/var/suiciding = 0
/mob/verb/suicide()
	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return
	
	if (istype(src.loc, /turf) && istype(src.loc.loc, /area/start))
		src << "You can't commit suicide before you enter the game!"
		return
	
	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return
	
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	
	if(confirm == "Yes")
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] is holding \his breath. It looks like \he's trying to commit suicide.</b>"
		src.oxyloss = max(175 - src.toxloss - src.fireloss - src.bruteloss, src.oxyloss)
		src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
