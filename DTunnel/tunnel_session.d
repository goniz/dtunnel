module dtunnel.tunnel_session;

import std.socket;
import std.stdio;

import dtunnel.tuntap;
import dtunnel.input_channel;
import dtunnel.output_channel;

class TunnelSession {
	this(	TunTapDevice dev,
		DatagramInputChannel input,
		DatagramOutputChannel output) {
		
		m_input = input;
		m_output = output;
		m_dev = dev;
	}
	
	~this() {
		this.close();
	}
	
	void close() {
		m_input.close();
		m_output.close();
		m_dev.close();
	}
	
	InternetAddress getClientAddress() {
		return m_output.getRemoteAddress();
	}
	
	void do_tunnel() {
		SocketSet inputs = new SocketSet();
		SocketSet outputs = new SocketSet();
		SocketSet excepts = new SocketSet();
		
		while(true) {
			inputs.reset();
			outputs.reset();
			excepts.reset();
			
			inputs.add(m_input.getSocket());
			inputs.add(cast(socket_t)(m_dev.fileno()));
			//TODO: find out why this select does not pop
			auto ret = Socket.select(inputs, outputs, excepts, Duration.max);
			writefln("select() = %d", ret);
			if (0 > ret) {
				perror("select() failed");
				throw new Exception("select() syscall failed");
			}
			
			if (inputs.isSet(m_input.getSocket())) {
				writefln("DatagramInputChannel::read(1500)");
				byte[] buf = m_input.read(1500);
				m_dev.write(buf);
			}
			
			if (inputs.isSet(cast(socket_t)(m_dev.fileno()))) {
				writefln("TunTapDevice::read(1500)");
				byte[] buf = m_dev.read(1500);
				m_output.write(buf);
			}
		}
	}
	
	private DatagramInputChannel 	m_input;
	private DatagramOutputChannel 	m_output;
	private TunTapDevice			m_dev;
}