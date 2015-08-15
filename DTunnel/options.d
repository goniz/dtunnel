module dtunnel.options;

import std.stdio;
import std.getopt;
import dtunnel.tuntap;

enum OperationMode { client, server };
enum ushort DefaultPort = 9999;

struct Options {
	bool verbose = false;
	DeviceMode deviceMode = DeviceMode.tap;
	OperationMode opMode = OperationMode.server;
	string ip = "0.0.0.0";
	ushort port = DefaultPort;
};

Options parseArgs(ref string[] args) {
	Options options;
	GetoptResult ret = getopt(args,
		std.getopt.config.caseSensitive,
		"verbose|v", &options.verbose,
		std.getopt.config.required,
		"dev|d", &options.deviceMode,
		std.getopt.config.required,
		"mode|m", &options.opMode,
		"ip|i", &options.ip,
		"port|p", &options.port);
	
	if (ret.helpWanted) {
		defaultGetoptPrinter("Some information about the program.", ret.options);
		return options;
	}
	
	writefln("verbose:    %s", options.verbose);
	writefln("deviceMode: %s", options.deviceMode);
	writefln("opMode:     %s", options.opMode);
	writefln("ip:         %s", options.ip);
	writefln("port:       %d", options.port);
	return options;
}