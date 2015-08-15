module dtunnel.input_channel;

import std.socket;
import std.stdio;
import dtunnel.file_descriptor;

class DatagramInputChannel : FileDescriptor {
	this(InternetAddress address) {
		m_addr = address;
		m_sock = new UdpSocket();
		m_sock.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
		m_sock.bind(m_addr);
		m_sock.blocking = false;
	}
	
	this(ushort port) {
		InternetAddress addr = new InternetAddress(port);
		this(addr);
	}
	
	~this() {
		this.close();
	}
	
	const int fileno() {
		const int fd = m_sock.handle();
		writefln("DatagramInputChannel::fileno() = %d", fd);
		return fd;
	}
	
	Socket getSocket() {
		return m_sock;
	}
	
	void close() {
		m_sock.close();
	}
	
	//long read(ref byte[] buf) {
	byte[] read(uint size) {
		// alloc the needed size to read
		byte[] buf;
		buf.length = size;
		
		auto ret = m_sock.receiveFrom(buf);
		if (0 > ret) {
			perror("receiveFrom()");
			throw new Exception("failed to receiveFrom from socket");
		}
		
		buf.length = ret;
		return buf;
	}
	
	private InternetAddress 	m_addr;
	private UdpSocket 			m_sock;
}