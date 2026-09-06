const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib_dep = b.dependency("raylib", .{});
    const raylib_include = raylib_dep.path("src");

    const docking = true;

    const cimgui_zig_dep = b.dependency("cimgui_zig", .{
        .target = target,
        .optimize = optimize,
        .no_platform = true,
        .no_renderer = true,

        .docking = docking,

        .link_libc = true,
    });

    var cimgui_path: std.Build.LazyPath = cimgui_zig_dep.path("dcimgui/master");

    if (docking) {
        cimgui_path = cimgui_zig_dep.path("dcimgui/docking");
    } else {
        cimgui_path = cimgui_zig_dep.path("dcimgui/master");
    }

    const cimgui_zig_include = cimgui_path;

    _ = b.addModule("cimgui", .{
        .root_source_file = b.path("src/cimgui.zig"),
        .target = target,
        .optimize = optimize,
    });

    const cimgui_lib = cimgui_zig_dep.artifact("cimgui");

    b.installArtifact(cimgui_lib);

    const rl_imgui_dep = b.dependency("rlImGui", .{});
    const rl_imgui_include = rl_imgui_dep.path("");

    _ = b.addModule("rl_imgui", .{
        .root_source_file = b.path("src/rl_imgui.zig"),
        .target = target,
        .optimize = optimize,
    });

    const rl_imgui_cpp = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    rl_imgui_cpp.addCSourceFile(.{
        .file = rl_imgui_dep.path("rlImGui.cpp"),
        .flags = &.{},
    });

    rl_imgui_cpp.addCSourceFile(.{
        .file = b.path("src/rl_imgui_zig.cpp"),
        .flags = &.{},
    });

    rl_imgui_cpp.addIncludePath(raylib_include);
    rl_imgui_cpp.addIncludePath(cimgui_zig_include);
    rl_imgui_cpp.addIncludePath(rl_imgui_include);

    const rl_imgui_lib = b.addLibrary(.{
        .name = "rl_imgui",
        .root_module = rl_imgui_cpp,
    });

    b.installArtifact(rl_imgui_lib);
}
