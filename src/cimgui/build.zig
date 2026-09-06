const std = @import("std");

pub const Output = struct {
    include_path: std.Build.LazyPath,
    dependency: *std.Build.Dependency,
    module: *std.Build.Module,
    library: *std.Build.Step.Compile
};

pub const CimguiOptions = struct {
    docking: bool,
};

pub fn build(
    b: *std.Build,
    p: std.Build.LazyPath,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize,
    options: CimguiOptions,
) Output {
    const cimgui_zig_dep = b.dependency("cimgui_zig", .{
        .target = target,
        .optimize = optimize,
        .no_platform = true,
        .no_renderer = true,

        .docking = options.docking,

        .link_libc = true,
    });

    const cimgui_mod = b.addModule("cimgui", .{
        .root_source_file = p.path(b, "src/cimgui.zig"),
        .target = target,
        .optimize = optimize,
    });

    const cimgui_lib = cimgui_zig_dep.artifact("cimgui");

    b.installArtifact(cimgui_lib);

    var cimgui_zig_include: std.Build.LazyPath = cimgui_zig_dep.path("dcimgui/master");

    if (options.docking) {
        cimgui_zig_include = cimgui_zig_dep.path("dcimgui/docking");
    } else {
        cimgui_zig_include = cimgui_zig_dep.path("dcimgui/master");
    }

    return .{
        .include_path = cimgui_zig_include,
        .dependency = cimgui_zig_dep,
        .module = cimgui_mod,
        .library = cimgui_lib,
    };
}
