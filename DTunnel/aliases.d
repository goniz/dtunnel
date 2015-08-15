module dtunnel.aliases;

import core.sys.posix.unistd;
import core.sys.posix.sys.select;
import core.sys.posix.sys.time;
import core.sys.posix.sys.ioctl;
import core.sys.posix.fcntl;

struct linux {
	alias open = core.sys.posix.fcntl.open;
	alias close = core.sys.posix.unistd.close;
	alias read = core.sys.posix.unistd.read;
	alias write = core.sys.posix.unistd.write;
	alias O_RDWR = core.sys.posix.fcntl.O_RDWR;
	alias ioctl = core.sys.posix.sys.ioctl.ioctl;
	alias select = core.sys.posix.sys.select.select;
	alias timeval = core.sys.posix.sys.time.timeval;
}

struct libc {
	alias strncpy = core.stdc.string.strncpy;
	alias memcpy = core.stdc.string.memcpy;
}
