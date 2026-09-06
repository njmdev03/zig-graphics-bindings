const std = @import("std");

const cimgui = @import("src/cimgui/build.zig");
const rl_imgui = @import("src/rl_imgui/build.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cimgui_output = cimgui.build(
        b,
        b.path("src/cimgui"),
        target,
        optimize,
        .{ .docking = false }
    );

    _ = rl_imgui.build(
        b,
        b.path("src/rl_imgui"),
        target,
        optimize,
        cimgui_output
    );
}
