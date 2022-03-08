const std = @import("std");
const Builder = std.build.Builder;
const Step = std.build.Step;
const Mode = std.builtin.Mode;
const Target = std.zig.CrossTarget;

const raylib = @import("raylib-zig/lib.zig").Pkg("raylib-zig"); //call .Pkg() with the folder raylib-zig is in relative to project build.zig

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const clientStep = addClient(b, mode, target);
    const serverStep = addServer(b, mode, target);

    addRunAll(b, clientStep, serverStep);
}

fn addRunAll(b: *Builder, clientStep: *Step, serverStep: *Step) void {
    const run_step = b.step("run", "Run both client and server");
    run_step.dependOn(clientStep);
    run_step.dependOn(serverStep);
}

fn addClient(b: *Builder, mode: Mode, target: Target) *Step {
    const system_lib = b.option(bool, "system-raylib", "link to preinstalled raylib libraries") orelse false;

    const exe = b.addExecutable("xray", "src/client/main.zig");
    exe.setBuildMode(mode);
    exe.setTarget(target);

    raylib.link(exe, system_lib);
    raylib.addAsPackage("raylib", exe);
    raylib.math.addAsPackage("raylib-math", exe);

    exe.addPackagePath("disco", "src/disco/discovery.zig");

    const run_cmd = exe.run();
    const run_step = b.step("run-client", "run xclient");
    run_step.dependOn(&run_cmd.step);

    exe.install();
    return run_step;
}

fn addServer(b: *Builder, mode: Mode, target: Target) *Step {
    const exe = b.addExecutable("xserver", "src/server/main.zig");
    exe.setBuildMode(mode);
    exe.setTarget(target);
    exe.addPackage(.{
        .name = "http",
        .path = .{ .path = "apple_pie/src/apple_pie.zig" },
    });

    const run_cmd = exe.run();
    const run_step = b.step("run-server", "run xserver");
    run_step.dependOn(&run_cmd.step);

    exe.install();
    return run_step;
}
