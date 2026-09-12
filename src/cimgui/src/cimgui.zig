const std = @import("std");

pub const windowFlags = i32;
pub const treeNodeFlags = i32;

pub const terminatedString = [*:0]const u8;

pub fn showDemoWindow(open: *bool) void {
    ImGui_ShowDemoWindow(open);
}

extern fn ImGui_ShowDemoWindow(*bool) void;

pub fn begin(name: terminatedString, open: *bool, flags: windowFlags) bool {
    return ImGui_Begin(name, open, @as(c_int, flags));
}

pub fn end() void {
    ImGui_End();
}

extern fn ImGui_Begin(name: terminatedString, p_open: *bool, flags: c_int) bool;
extern fn ImGui_End() void;

pub fn textUnformatted(text: terminatedString) void {
    ImGui_TextUnformatted(text);
}

pub fn textZigFMT(alloc: std.mem.Allocator, comptime fmt: []const u8, args: anytype) !void {
    const string = try alloc.printSentinel(fmt, args, 0);
    defer alloc.free(string);
    textUnformatted(string);

    // const string = try std.fmt.allocPrint(
    //     alloc,
    //     text,
    //     args,
    // );
    // defer alloc.free(string);

    // textUnformatted(string);
}

// test "fmt" {
//     const string = try std.fmt.allocPrint(
//         test_allocator,
//         "{d} + {d} = {d}",
//         .{ 9, 10, 19 },
//     );
//     defer test_allocator.free(string);

//     try expect(eql(u8, string, "9 + 10 = 19"));
// }

extern fn ImGui_TextUnformatted(text: terminatedString) void;

pub fn spacing() void {
    ImGui_Spacing();
}

extern fn ImGui_Spacing() void;

pub fn collapsingHeader(label: terminatedString, flags: treeNodeFlags) bool {
    return ImGui_CollapsingHeader(label, flags);
}

pub fn collapsingHeaderBoolPtr(label: terminatedString, visible: *bool, flags: treeNodeFlags) bool {
    return ImGui_CollapsingHeaderBoolPtr(label, visible, flags);
}

extern fn ImGui_CollapsingHeader(label: terminatedString, flags: treeNodeFlags) bool;
extern fn ImGui_CollapsingHeaderBoolPtr(label: terminatedString, p_visible: *bool, flags: treeNodeFlags) bool;

pub fn separatorText(label: terminatedString) void {
    ImGui_SeparatorText(label);
}

extern fn ImGui_SeparatorText(label: terminatedString) void;

pub fn sameLine() void {
    ImGui_SameLine();
}

extern fn ImGui_SameLine() void;

pub fn labelText(label: terminatedString, fmt: terminatedString, args: anytype) void {
    ImGui_LabelText(label, fmt, args);
}

extern fn ImGui_LabelText(label: terminatedString, fmt: terminatedString, ...) void;

// extern fn ImGui_CreateContext(*ImFontAtlas) *ImGuiContext;
// extern fn ImGui_DestroyContext(*ImGuiContext) void;