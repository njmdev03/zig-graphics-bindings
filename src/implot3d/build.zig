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
    const cimgui_zig_include = cimgui_output.include_path;

    const implot3d_dep = b.dependency("implot3d", .{});
    const implot3d_include = implot3d_dep.path("");

    const implot3d_mod = b.addModule("implot3d", .{
        .root_source_file = path.path(b, "src/implot3d.zig"),
        .target = target,
        .optimize = optimize,
    });

    const implot3d_cpp = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    implot3d_cpp.addCSourceFile(.{
        .file = implot3d_dep.path("implot3d.cpp"),
        .flags = &.{},
    });

    implot3d_cpp.addCSourceFile(.{
        .file = implot3d_dep.path("implot3d_demo.cpp"),
        .flags = &.{},
    });

    implot3d_cpp.addCSourceFile(.{
        .file = implot3d_dep.path("implot3d_items.cpp"),
        .flags = &.{},
    });

    implot3d_cpp.addCSourceFile(.{
        .file = implot3d_dep.path("implot3d_meshes.cpp"),
        .flags = &.{},
    });

    implot3d_cpp.addCSourceFile(.{
        .file = path.path(b, "src/implot3d_zig.cpp"),
        .flags = &.{},
    });

    implot3d_cpp.addIncludePath(cimgui_zig_include);
    implot3d_cpp.addIncludePath(implot3d_include);

    const implot3d_lib = b.addLibrary(.{
        .name = "implot3d",
        .root_module = implot3d_cpp,
    });

    b.installArtifact(implot3d_lib);

    return .{
        .module = implot3d_mod,
        .library = implot3d_lib,
    };
}
