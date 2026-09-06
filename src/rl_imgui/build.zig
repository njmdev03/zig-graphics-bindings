const std = @import("std");
const cimgui = @import("../cimgui/build.zig");

pub const Output = struct {
    module: *std.Build.Module,
    library: *std.Build.Step.Compile
};

pub fn build(
    b: *std.Build,
    path: std.Build.LazyPath,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize,
    cimgui_output: cimgui.Output,
) Output {
    const raylib_dep = b.dependency("raylib", .{});
    const raylib_include = raylib_dep.path("src");

    const cimgui_zig_include = cimgui_output.include_path;

    const rl_imgui_dep = b.dependency("rlImGui", .{});
    const rl_imgui_include = rl_imgui_dep.path("");

    const rl_imgui_mod = b.addModule("rl_imgui", .{
        .root_source_file = path.path(b, "src/rl_imgui.zig"),
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
        .file = path.path(b, "src/rl_imgui_zig.cpp"),
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

    return .{
        .module = rl_imgui_mod,
        .library = rl_imgui_lib,
    };
}
