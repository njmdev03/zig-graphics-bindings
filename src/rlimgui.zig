const std = @import("std");

pub fn begin() void {
    zig_rlImGuiBegin();
}

pub fn end() void {
    zig_rlImGuiEnd();
}

pub fn setup(dark: bool) void {
    zig_rlImGuiSetup(dark);
}

pub fn shutdown() void {
    zig_rlImGuiShutdown();
}

extern fn zig_rlImGuiSetup(bool) void;
extern fn zig_rlImGuiBegin() void;
extern fn zig_rlImGuiEnd() void;
extern fn zig_rlImGuiShutdown() void;
