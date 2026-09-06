const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib = b.dependency("raylib", .{});
    const raylib_include = raylib.path("src");

    const docking = true;

    const cimgui_zig = b.dependency("cimgui_zig", .{
        .target = target,
        .optimize = optimize,
        .no_platform = true,
        .no_renderer = true,

        .docking = docking,

        .link_libc = true,
    });

    var cimgui_path: std.Build.LazyPath = cimgui_zig.path("dcimgui/master");

    if (docking) {
        cimgui_path = cimgui_zig.path("dcimgui/docking");
    } else {
        cimgui_path = cimgui_zig.path("dcimgui/master");
    }

    const cimgui_zig_include = cimgui_path;

    _ = b.addModule("cimgui", .{
        .root_source_file = b.path("src/cimgui.zig"),
        .target = target,
        .optimize = optimize,
    });

    const rlimgui = b.dependency("rlImGui", .{});
    const rlimgui_include = rlimgui.path("");

    _ = b.addModule("rlImGui", .{
        .root_source_file = b.path("src/rlImGui.zig"),
        .target = target,
        .optimize = optimize,
    });

    const rlimgui_cpp = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    rlimgui_cpp.addCSourceFile(.{
        .file = rlimgui.path("rlImGui.cpp"),
        .flags = &.{},
    });

    rlimgui_cpp.addCSourceFile(.{
        .file = b.path("src/rlimgui_zig.cpp"),
        .flags = &.{},
    });

    rlimgui_cpp.addIncludePath(raylib_include);
    rlimgui_cpp.addIncludePath(cimgui_zig_include);
    rlimgui_cpp.addIncludePath(rlimgui_include);

    const rlimgui_lib = b.addLibrary(.{
        .name = "rlImGui",
        .root_module = rlimgui_cpp,
    });

    b.installArtifact(rlimgui_lib);

    const cimgui_lib = cimgui_zig.artifact("cimgui");

    b.installArtifact(cimgui_lib);
}
