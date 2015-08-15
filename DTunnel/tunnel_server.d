module dtunnel.tunnel_server;

import std.socket;
import dtunnel.tunnel_session;
import dtunnel.client_details;
import dtunnel.input_channel;
import dtunnel.output_channel;
import dtunnel.tuntap;
import dtunnel.socket_extentions;

class TunnelServer {
	this(ushort port) {
		m_listenAddr = new InternetAddress(port);
		m_listenSock = new TcpSocket();
		m_listenSock.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
		m_listenSock.bind(m_listenAddr);
		m_listenSock.listen(1);
	}
	
	TunnelSession acceptNewClient() {
		Socket client = m_listenSock.accept();
		ClientDetails details = this.clientHandshake(client);
		TunTapDevice dev = new TunTapDevice(details.deviceMode);
		DatagramInputChannel input = new DatagramInputChannel(m_listenAddr);
		InternetAddress clientAddr = new InternetAddress(client.remoteAddress.toAddrString(), details.clientPort);
		DatagramOutputChannel output = new DatagramOutputChannel(clientAddr);
		return new TunnelSession(dev, input, output);
	}
	
	
	private ClientDetails clientHandshake(Socket client) {
		return readObject!(ClientDetails)(client);
	}
	
	private InternetAddress m_listenAddr;
	private TcpSocket 		m_listenSock;
}
