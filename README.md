# Zig Graphics Bindings

A collection of bindings for interfacing with various graphics libraries using Zig.

Currently the focus is on supporting Raylib and Dear ImGui together via rlImGui, alongside a few extensions for Dear ImGui.

**NOTE:** These bindings are experimental and still under development. The APIs are currently incomplete, and there is no guarantee that the zig side of the APIs will remain the same. I am developing these for personal projects as a learning exercise, so they will not be as well developed as alternatives.

## Features/Libraries

- rlImGui
- Dear ImGui (via cimgui.zig)
- ImPlot
- ImPlot3D
- ImGuizmo
- ImKnobs _(Planned)_
- ImSpinner _(Planned)_
- ImNodes _(Planned)_

## Examples

<!-- TODO -->

## Usage

These bindings assume the use of a raylib backend, although cimgui and the ImGui extensions are bound without any dependency on raylib. If you plan to use raylib, first add raylib to your project by following the instructions on the [raylib-zig project](https://github.com/raylib-zig/raylib-zig#building-and-using) and setup a basic raylib window. If you plan on using your own backend, you are braver than I am.

Add the bindings as a dependency to your project

```bash
zig fetch --save git+https://github.com/njmdev03/zig-graphics-bindings
```

Then add the modules in your `build.zig`

```zig
// build.zig

// ...

// Add the bindings project as a dependency
const bindings_dep = b.dependency("zig_graphics_bindings", .{
    .target = target,
    .optimize = optimize,
});

// Get the bindings for rlImGui and the C build artifact
const rlimgui = bindings_dep.module("rl_imgui");
const rlimgui_artifact = bindings_dep.artifact("rl_imgui");

// Get the bindings for cimgui and the C build artifact
const cimgui = bindings_dep.module("cimgui");
const cimgui_artifact = bindings_dep.artifact("cimgui");

// Get the bindings for ImPlot and the C build artifact
const implot = bindings_dep.module("implot");
const implot_artifact = bindings_dep.artifact("implot");

// Get the bindings for ImPlot3D and the C build artifact
const implot3d = bindings_dep.module("implot3d");
const implot3d_artifact = bindings_dep.artifact("implot3d");

// ...

// Add the modules to your executable
const exe = b.addExecutable(.{
    .name = "executable-name",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),

        .target = target,
        .optimize = optimize,

        .imports = &.{
            // ...

            // Add the modules from above
            .{ .name = "rl_imgui", .module = rlimgui },
            .{ .name = "cimgui", .module = cimgui },
            .{ .name = "implot", .module = implot },
            .{ .name = "implot3d", .module = implot3d },
        },
    }),
});

// Link your executable against the C build artifacts from above
exe.root_module.linkLibrary(raylib_artifact);
exe.root_module.linkLibrary(rlimgui_artifact);
exe.root_module.linkLibrary(cimgui_artifact);
exe.root_module.linkLibrary(implot_artifact);
exe.root_module.linkLibrary(implot3d_artifact);

// Output your exe
b.installArtifact(exe);
```

## Building

<!-- TODO -->

## Contributing

You are welcome to open issues if anything seems off or to discuss changes, or open a pull request with reasonable fixes or changes.

## TODO

### Cimgui

- [ ] DragFloat
- [ ] DragInt
- [ ] SliderFloat
- [ ] SliderInt
- [ ] SliderAngle
- [ ] InputText
- InputTextWithHint
- [ ] InputInt
- [ ] InputFloat
- [ ] InputDouble
- [ ] InputFloat2
- [ ] InputFloat3
- [ ] InputFloat4
- [ ] ColorEdit3
- [ ] ColorEdit4
- [ ] Combo
- ListBox
