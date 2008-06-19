/mob/verb/memory()

	src << browse(text("<B>Memory:</B>:<HR>[]", src.memory), "window=memory")
	return

/mob/verb/add_memory(msg as message)

	src.memory += text("[]<BR>", msg)
	src << browse(text("<B>Memory:</B>:<HR>[]", src.memory), "window=memory")
	return
