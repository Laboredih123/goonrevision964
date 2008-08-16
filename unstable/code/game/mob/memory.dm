/mob/verb/memory()
	ss13_browse(src, text("<B>Memory:</B>:<HR>[]", src.memory), "window=memory")

/mob/verb/add_memory(msg as message)
	store_memory(msg,1)

/mob/proc/store_memory(msg as message, popup)
	src.memory += "[sanitize(copytext(msg,1,MAX_MESSAGE_LEN))]<BR>"
	if(popup) src.memory()
