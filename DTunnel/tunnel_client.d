module dtunnel.tunnel_client;

import std.socket;
import dtunnel.tunnel_session;
import dtunnel.client_details;
import dtunnel.input_channel;
import dtunnel.output_channel;
import dtunnel.tuntap;
import dtunnel.socket_extentions;

class TunnelClient {
	this(InternetAddress addr, ushort localPort) {
		m_remoteAddr = addr;
		m_localPort = localPort;
		m_handshakeSock = new TcpSocket();
	}
	
	this(string ip, ushort port, ushort localPort) {
		this(new InternetAddress(ip, port), localPort);
	}
	
	TunnelSession connect(DeviceMode mode) {
		m_handshakeSock.connect(m_remoteAddr);
		ClientDetails details;
		details.clientPort = m_localPort;
		details.deviceMode = mode;
		Socket tcpSock = cast(Socket)(m_handshakeSock);
		writeObject!(ClientDetails)(tcpSock, details);
		TunTapDevice dev = new TunTapDevice(mode);
		DatagramInputChannel input = new DatagramInputChannel(m_localPort);
		DatagramOutputChannel output = new DatagramOutputChannel(m_remoteAddr);
		return new TunnelSession(dev, input, output);
	}
	
	
	private InternetAddress m_remoteAddr;
	private ushort 			m_localPort;
	private TcpSocket		m_handshakeSock;
}