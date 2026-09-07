const std = @import("std");

const cimgui = @import("src/cimgui/build.zig");
const rl_imgui = @import("src/rl_imgui/build.zig");

const implot = @import("src/implot/build.zig");
const implot3d = @import("src/implot3d/build.zig");
const imguizmo = @import("src/imguizmo/build.zig");

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

    _ = implot.build(
        b,
        b.path("src/implot/"),
        target,
        optimize,
        cimgui_output
    );

    _ = implot3d.build(
        b,
        b.path("src/implot3d/"),
        target,
        optimize,
        cimgui_output
    );

    // _ = imguizmo.build(
    //     b,
    //     b.path("src/imguizmo/"),
    //     target,
    //     optimize,
    //     cimgui_output
    // );
}
