const std = @import("std");

const ImPlot3DContext = opaque {};

pub fn showDemoWindow(open: *bool) void {
    implot3d_ShowDemoWindow(open);
}

pub fn createContext() *ImPlot3DContext {
    return implot3d_CreateContext();
}

pub fn destroyContext(ctx: *ImPlot3DContext) void {
    implot3d_DestroyContext(ctx);
}

extern fn implot3d_CreateContext() *ImPlot3DContext;
extern fn implot3d_DestroyContext(ctx: *ImPlot3DContext) void;
extern fn implot3d_ShowDemoWindow(p_open: *bool) void;