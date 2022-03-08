const std = @import("std");
const net = std.net;
const fs = std.fs;
const os = std.os;
const system = std.system;
const print = std.debug.print;

// pub const io_mode = .evented

pub fn discover() void {
    print("doing a discover for some servers\n", .{});

    // TODO - run this as a thread, looping forever, and
    // updating the list of servers to connect to

    const family = os.AF.INET;
    const flags = os.SOCK.DGRAM | os.SOCK.CLOEXEC;
    const proto = os.IPPROTO.UDP;

    const buffer: []u8 = "";

    if (os.socket(family, flags, proto)) |fd| discover: {
        defer os.closeSocket(fd);
        print("socket fd {}\n", .{fd});

        var addr = net.Address.parseIp4("224.0.0.1", 9090) catch unreachable;
        var remote_addr: net.Address = undefined;
        var ra_len: os.socklen_t = undefined;

        print("addr {}\n", .{addr});

        if (os.bind(fd, &addr.any, addr.getOsSockLen())) |_| {
            print("bound socket {} to address {}\n", .{ fd, addr });

            // TODO - loop forever, getting adverts for servers and adding them to the list
            //if (os.listen(fd, 1)) |l| {
            //print("listening {}\n", .{l});

            // var sockLen: u32 = 0;
            // if (os.accept(fd, &remote_addr.any, &sockLen, 0)) |new_socket| {
            // _ = sockLen;
            // print("New Socket {} from {}\n", .{ new_socket, remote_addr });
            // } else |err| {
            // print("accept error {}\n", .{err});
            // break :discover;
            // }
            //} else |err| {
            //print("listen error {}\n", .{err});
            //break :discover;
            //}

            if (os.recvfrom(fd, buffer, 0x0100, &remote_addr.any, &ra_len)) |got| {
                _ = got;
                print("got something ... {}\n", .{got});
                break :discover;
                //print("Got {} bytes from {}\n", .{ got, remote_addr });
            } else |err| {
                print("got recv error {}\n", .{err});
                break :discover;
            }
        } else |err| {
            print("got bind error {}\n", .{err});
            break :discover;
        }
        break :discover;
    } else |_| {
        print("no discover for you\n", .{});
    }
}
