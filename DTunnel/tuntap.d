module dtunnel.tuntap;

import core.sys.posix.net.if_;
import std.stdio;
import dtunnel.aliases;
import dtunnel.file_descriptor;

enum uint TUNSETIFF = 0x400454ca;
enum DeviceMode : short { tun = 1, tap = 2 };

struct TunTapIoctl {
	// fields
	char[IF_NAMESIZE] ifaceName;
	short ifaceFlags;
	
	// ioctl
	int ioctl(int fd) {
		auto ret = linux.ioctl(fd, TUNSETIFF, &this);
		if (0 != ret) {
			perror("errno()");
			throw new Exception("ioctl(TUNSETIFF) failed!");
		}
		
		return ret;
	}
	
	int ioctl(File file) {
		return this.ioctl(file.fileno());
	}
	
	// helper functions
	void setName(string name) {
		immutable(char)* cstring = std.string.toStringz(name);
		libc.strncpy(this.ifaceName.ptr, cstring, this.ifaceName.length);
	}
	
	string getName() {
		return cast(string)(this.ifaceName);
	}
	
	void setFlags(DeviceMode mode) {
		this.ifaceFlags = mode;
	}
	
	void setFlags(short flags) {
		this.ifaceFlags = flags;
	}
	
	DeviceMode getFlags() {
		return cast(DeviceMode)(this.ifaceFlags);
	}
	
	short getFlags() {
		return this.ifaceFlags;
	}
}

class TunTapDevice : FileDescriptor {
	// user defined name
	this(string name, DeviceMode mode) {
		m_name = name;
		m_mode = mode;
		m_fd = linux.open("/dev/net/tun", linux.O_RDWR);
		
		TunTapIoctl ifreq;
		ifreq.setName(m_name);
		ifreq.setFlags(m_mode);
		ifreq.ioctl(m_fd);
	}
	
	// the name is tun%d for tun mode, tap%d for tap mode
	this(DeviceMode mode) {
		string name = std.format.format("%s%%d", mode);
		this(name, mode);
	}
	
	~this() {
		this.close();
	}
	
	void close() {
		linux.close(m_fd);
	}
	
	byte[] read(uint size) {
		// alloc the needed size to read
		byte[] buf;
		buf.reserve(size);
		buf.length = size;
		
		writefln("Device::read() buf.sizeof = %d", size);
		// actually read from device
		auto ret = linux.read(this.fileno(), buf.ptr, size);
		if (0 > ret) {
			perror("read()");
			throw new Exception("failed to read from fd");
		}
		
		writefln("Device::read() read() = %d", ret);
		// cut down the length to the actuall len read received
		buf.length = ret;
		return buf;
	}
	
	long write(ref byte[] buf) {
		writefln("Device::write() buf.length = %d", buf.length);
		auto ret = linux.write(this.fileno(), buf.ptr, buf.length);
		if (0 > ret) {
			perror("write()");
			throw new Exception("failed to write to fd");
		}
		
		writefln("Device::write() write() = %d", ret);
		return ret;
	}
	
	const int fileno() {
		writefln("Device::fileno() = %d", m_fd);
		return m_fd;
	}
	
	private const string 	 m_name;
	private const DeviceMode m_mode;
	private int 			 m_fd;
}
