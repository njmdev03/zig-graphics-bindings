const std = @import("std");

pub fn showDemoWindow(open: *bool) void {
    ImGui_ShowDemoWindow(open);
}

extern fn ImGui_ShowDemoWindow(*bool) void;

// extern fn ImGui_CreateContext(*ImFontAtlas) *ImGuiContext;
// extern fn ImGui_DestroyContext(*ImGuiContext) void;