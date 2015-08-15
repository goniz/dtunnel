module main;

import std.stdio;
import std.socket;

import dtunnel.aliases;
import dtunnel.options;
import dtunnel.tunnel_session;
import dtunnel.tunnel_server;
import dtunnel.tunnel_client;

TunnelSession createTunnelSession(Options opts) {
	switch(opts.opMode) {

		case OperationMode.client:
			TunnelClient tunnelClient = new TunnelClient(opts.ip, opts.port, opts.port);
			writefln("Trying to connect to %s:%d", opts.ip, opts.port);
			return tunnelClient.connect(opts.deviceMode);

		case OperationMode.server:
			TunnelServer factory = new TunnelServer(opts.port);
			writeln("Waiting for connection!");
			TunnelSession tunnelSession = factory.acceptNewClient();
			InternetAddress remoteAddr = tunnelSession.getClientAddress();
			writefln("Got a new connection from: %s", remoteAddr);
			return tunnelSession;

		default:
			throw new Exception("invalid operation mode!");
	}
}

void main(string[] args)
{
	Options opts;

	try {
		 opts = parseArgs(args);
	} catch (Exception e) {
		writefln(e.msg);
		return;
	}

	TunnelSession tunnelSession = createTunnelSession(opts);
	try {
		tunnelSession.do_tunnel();
	} finally {
		tunnelSession.close();
	}
}