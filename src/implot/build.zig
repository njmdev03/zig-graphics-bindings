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

    const implot_dep = b.dependency("implot", .{});
    const implot_include = implot_dep.path("");

    const implot_mod = b.addModule("implot", .{
        .root_source_file = path.path(b, "src/implot.zig"),
        .target = target,
        .optimize = optimize,
    });

    const implot_cpp = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    implot_cpp.addCSourceFile(.{
        .file = implot_dep.path("implot.cpp"),
        .flags = &.{},
    });

    implot_cpp.addCSourceFile(.{
        .file = implot_dep.path("implot_items.cpp"),
        .flags = &.{},
    });

    implot_cpp.addCSourceFile(.{
        .file = implot_dep.path("implot_demo.cpp"),
        .flags = &.{},
    });

    implot_cpp.addCSourceFile(.{
        .file = path.path(b, "src/implot_zig.cpp"),
        .flags = &.{},
    });

    implot_cpp.addIncludePath(cimgui_zig_include);
    implot_cpp.addIncludePath(implot_include);

    const implot_lib = b.addLibrary(.{
        .name = "implot",
        .root_module = implot_cpp,
    });

    b.installArtifact(implot_lib);

    return .{
        .module = implot_mod,
        .library = implot_lib,
    };
}
