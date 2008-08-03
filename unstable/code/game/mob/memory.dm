/mob/verb/memory()

	ss13_browse(src, text("<B>Memory:</B>:<HR>[]", src.memory), "window=memory")
	return

/mob/verb/add_memory(msg as message)

	src.memory += text("[]<BR>", msg)
	ss13_browse(src, text("<B>Memory:</B>:<HR>[]", src.memory), "window=memory")
	return
