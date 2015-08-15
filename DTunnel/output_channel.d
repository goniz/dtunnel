module dtunnel.output_channel;

import std.socket;
import std.stdio;
import dtunnel.file_descriptor;

class DatagramOutputChannel : FileDescriptor {
	this(InternetAddress address) {
		m_addr = address;
		m_sock = new UdpSocket();
	}
	
	~this() {
		this.close();
	}
	
	const int fileno() {
		const int fd = m_sock.handle();
		writefln("DatagramOutputChannel::fileno() = %d", fd);
		return fd;
	}
	
	Socket getSocket() {
		return m_sock;
	}
	
	void close() {
		m_sock.close();
	}
	
	long write(ref byte[] buf) {
		return m_sock.sendTo(buf, m_addr);
	}
	
	InternetAddress getRemoteAddress() {
		return m_addr;
	}
	
	private InternetAddress m_addr;
	private UdpSocket		m_sock;
}