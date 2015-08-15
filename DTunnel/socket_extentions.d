module dtunnel.socket_extentions;

import std.socket;
import dtunnel.aliases;

T readObject(T)(Socket sock) {
	byte[] buf;
	buf.reserve(T.sizeof);
	buf.length = T.sizeof;
	
	//TODO: check retval
	sock.receive(buf);
	T* objPtr = cast(T*)(buf.ptr);
	return *objPtr;
}

void writeObject(T)(Socket sock, T obj) {
	byte[] buf;
	buf.length = obj.sizeof;
	libc.memcpy(buf.ptr, cast(void*)(&obj), buf.length);
	//TODO: check retval
	sock.send(buf);
}