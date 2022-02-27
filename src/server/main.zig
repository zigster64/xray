const std = @import("std");
const http = @import("http");

// use evented mode for event loop support
// pub const io_mode = .evented;

// optional root constant to define max stack buffer size per request
pub const buffer_size: usize = 4096;
// optional root constant to define max header size per request
pub const request_buffer_size: usize = 4096;

/// Context variable, accessible by all handlers, allowing to access data objects
/// without requiring them to be global. Thread-safety must be handled by the user.
const Context = struct {
    data: []const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const my_context: Context = .{ .data = "Hello, world!" };

    var port: u16 = 8000;

    const stdout = std.io.getStdOut().writer();
    while (true) {
        try stdout.print("Listen on port {} ...", .{port});
        http.listenAndServe(
            gpa.allocator(),
            try std.net.Address.parseIp("0.0.0.0", port),
            my_context,
            index,
        ) catch |err| {
            switch (err) {
                error.AddressInUse => {
                    try stdout.print(" (already in use)\n", .{});
                    port += 1;
                },
                else => {
                    std.debug.print("got an error {}\n", .{err});
                    break;
                },
            }
        };
    }
}

fn index(ctx: Context, response: *http.Response, request: http.Request) !void {
    _ = request;
    try response.writer().print("{s}", .{ctx.data});
}
