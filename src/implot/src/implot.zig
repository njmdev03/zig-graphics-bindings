const std = @import("std");

const ImPlotContext = opaque {};

pub fn showDemoWindow(open: *bool) void {
    implot_ShowDemoWindow(open);
}

pub fn createContext() *ImPlotContext {
    return implot_CreateContext();
}

pub fn destroyContext(ctx: *ImPlotContext) void {
    implot_DestroyContext(ctx);
}

extern fn implot_ShowDemoWindow(p_open: *bool) void;
extern fn implot_CreateContext() *ImPlotContext;
extern fn implot_DestroyContext(ctx: *ImPlotContext) void;