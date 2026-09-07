const std = @import("std");
const cimgui = @import("../cimgui/build.zig");

pub fn build(
    b: *std.Build,
    path: std.Build.LazyPath,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize,
    cimgui_output: cimgui.Output,
) void {
    const cimgui_zig_include = cimgui_output.include_path;

    const mods = []const struct{
        // .{ .name = "GraphEditor", .mod = "graph_editor" },
        // .{ .name = "ImCurveEdit", .mod = "im_curve_edit" },
        // .{ .name = "ImGradient", .mod = "im_gradient" },
        .{ .name = "ImGuizmo", .mod = "im_guizmo" },
        // .{ .name = "ImLightRig", .mod = "im_light_rig" },
        // .{ .name = "ImSequencer", .mod = "im_sequencer" },
        .{ .name = "ImVectorEditor", .mod = "im_vector_editor" },
        // .{ .name = "ImZoomSlider", .mod = "im_zoom_slider" },
    };

    for (mods) |mod| {
        const dep = b.dependency(mod.mod, .{});
        const include = dep.path("src");

        _ = b.addModule(mod.mod, .{
            .root_source_file = path.path(b, "src/" ++ mod.mod ++ ".zig"),
            .target = target,
            .optimize = optimize,
        });

        const cpp = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        });

        cpp.addCSourceFile(.{
            .file = dep.path("src/" ++ mod.name ++ ".cpp"),
            .flags = .{},
        });

        cpp.addCSourceFile(.{
            .file = path.path(b, "src/" ++ mod.mod ++ "_zig.cpp"),
            .flags = .{},
        });

        cpp.addIncludePath(cimgui_zig_include);
        cpp.addIncludePath(include);

        const lib = b.addLibrary(.{
            .name = mod.mod,
            .root_module = cpp,
        });

        b.installArtifact(lib);
    }

    // const imguizmo_dep = b.dependency("imguizmo", .{});
    // const imguizmo_include = imguizmo_dep.path("");

    // _ = b.addModule("imguizmo", .{
    //     .root_source_file = path.path(b, "src/imguizmo.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });

    // const imguizmo_cpp = b.createModule(.{
    //     .target = target,
    //     .optimize = optimize,
    //     .link_libcpp = true,
    // });

    // imguizmo_cpp.addCSourceFile(.{
    //     .file = imguizmo_dep.path("src/ImGuizmo.cpp"),
    //     .flags = &.{},
    // });

    // imguizmo_cpp.addCSourceFile(.{
    //     .file = path.path(b, "src/imguizmo_zig.cpp"),
    //     .flags = &.{},
    // });

    // imguizmo_cpp.addIncludePath(cimgui_zig_include);
    // imguizmo_cpp.addIncludePath(imguizmo_include);

    // const imguizmo_lib = b.addLibrary(.{
    //     .name = "imguizmo",
    //     .root_module = imguizmo_cpp,
    // });

    // b.installArtifact(imguizmo_lib);
}
