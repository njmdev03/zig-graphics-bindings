const std = @import("std");

pub const WindowFlags = enum (i32) {
    none                   = 0,
    noTitleBar             = 1 << 0,   // Disable title-bar
    noResize               = 1 << 1,   // Disable user resizing with the lower-right grip
    noMove                 = 1 << 2,   // Disable user moving the window
    noScrollbar            = 1 << 3,   // Disable scrollbars (window can still scroll with mouse or programmatically)
    noScrollWithMouse      = 1 << 4,   // Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
    noCollapse             = 1 << 5,   // Disable user collapsing window by double-clicking on it. Also referred to as Window Menu Button (e.g. within a docking node).
    alwaysAutoResize       = 1 << 6,   // Resize every window to its content every frame
    noBackground           = 1 << 7,   // Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
    noSavedSettings        = 1 << 8,   // Never load/save settings in .ini file
    noMouseInputs          = 1 << 9,   // Disable catching mouse, hovering test with pass through.
    menuBar                = 1 << 10,  // Has a menu-bar
    horizontalScrollbar    = 1 << 11,  // Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    noFocusOnAppearing     = 1 << 12,  // Disable taking focus when transitioning from hidden to visible state
    noBringToFrontOnFocus  = 1 << 13,  // Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
    alwaysVerticalScrollbar= 1 << 14,  // Always show vertical scrollbar (even if ContentSize.y < Size.y)
    alwaysHorizontalScrollbar= 1 << 15,  // Always show horizontal scrollbar (even if ContentSize.x < Size.x)
    noNavInputs            = 1 << 16,  // No keyboard/gamepad navigation within the window
    noNavFocus             = 1 << 17,  // No focusing toward this window with keyboard/gamepad navigation (e.g. skipped by Ctrl+Tab)
    unsavedDocument        = 1 << 18,  // Display a dot next to the title. When used in a tab/docking context, tab is selected when clicking the X + closure is not assumed (will wait for user to stop submitting the tab). Otherwise closure is assumed when pressing the X, so if you keep submitting the tab may reappear at end of tab bar.
    noNav                  = 1 << 16 | 1 << 17, // .NoNavInputs | .NoNavFocus,
    noDecoration           = 1 << 0 | 1 << 1 | 1 << 3 | 1 << 5, // .NoTitleBar | .NoResize | .NoScrollbar | .NoCollapse,
    noInputs               = 1 << 9 | 1 << 16 | 1 << 17, // .NoMouseInputs | .NoNavInputs | .NoNavFocus,

    // [Internal]
    childWindow            = 1 << 24,  // Don't use! For internal use by BeginChild()
    tooltip                = 1 << 25,  // Don't use! For internal use by BeginTooltip()
    popup                  = 1 << 26,  // Don't use! For internal use by BeginPopup()
    modal                  = 1 << 27,  // Don't use! For internal use by BeginPopupModal()
    childMenu              = 1 << 28,  // Don't use! For internal use by BeginMenu()

    // Obsolete names
    //ImGuiWindowFlags_NavFlattened           = 1 << 29,  // Obsoleted in 1.90.9: moved to ImGuiChildFlags. BeginChild(name, size, 0, ImGuiWindowFlags_NavFlattened)           --> BeginChild(name, size, ImGuiChildFlags_NavFlattened, 0)
    //ImGuiWindowFlags_AlwaysUseWindowPadding = 1 << 30,  // Obsoleted in 1.90.0: moved to ImGuiChildFlags. BeginChild(name, size, 0, ImGuiWindowFlags_AlwaysUseWindowPadding) --> BeginChild(name, size, ImGuiChildFlags_AlwaysUseWindowPadding, 0)
    _,
};

pub const Cond = enum (i32) {
    none         = 0,     // No condition (always set the variable), same as _Always
    always       = 1<<0,  // No condition (always set the variable), same as _None
    once         = 1<<1,  // Set the variable once per runtime session (only the first call will succeed)
    firstUseEver = 1<<2,  // Set the variable if the object/window has no persistently saved data (no entry in .ini file)
    appearing    = 1<<3,  // Set the variable if the object/window is appearing after being hidden/inactive (or the first time)
};

pub const ImGuiColorEditFlags = enum (i32) {
    None             = 0,
    NoAlpha          = 1<<1,   //              // ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
    NoPicker         = 1<<2,   //              // ColorEdit: disable picker when clicking on color square.
    NoOptions        = 1<<3,   //              // ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
    NoSmallPreview   = 1<<4,   //              // ColorEdit, ColorPicker: disable color square preview next to the inputs. (e.g. to show only the inputs)
    NoInputs         = 1<<5,   //              // ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview color square).
    NoTooltip        = 1<<6,   //              // ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
    NoLabel          = 1<<7,   //              // ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
    NoSidePreview    = 1<<8,   //              // ColorPicker: disable bigger color preview on right side of the picker, use small color square preview instead.
    NoDragDrop       = 1<<9,   //              // ColorEdit: disable drag and drop target/source. ColorButton: disable drag and drop source.
    NoBorder         = 1<<10,  //              // ColorButton: disable border (which is enforced by default)
    NoColorMarkers   = 1<<11,  //              // ColorEdit: disable rendering R/G/B/A color marker. May also be disabled globally by setting style.ColorMarkerSize = 0.

    // Alpha preview
    // - Prior to 1.91.8 (2025/01/21): alpha was made opaque in the preview by default using old name ImGuiColorEditFlags_AlphaPreview.
    // - We now display the preview as transparent by default. You can use ImGuiColorEditFlags_AlphaOpaque to use old behavior.
    // - The new flags may be combined better and allow finer controls.
    AlphaOpaque      = 1<<12,  //              // ColorEdit, ColorPicker, ColorButton: disable alpha in the preview,. Contrary to _NoAlpha it may still be edited when calling ColorEdit4()/ColorPicker4(). For ColorButton() this does the same as _NoAlpha.
    AlphaNoBg        = 1<<13,  //              // ColorEdit, ColorPicker, ColorButton: disable rendering a checkerboard background behind transparent color.
    AlphaPreviewHalf = 1<<14,  //              // ColorEdit, ColorPicker, ColorButton: display half opaque / half transparent preview.

    // User Options (right-click on widget to change some of them)
    // Current settings are stored in style.ColorEditFlags.
    AlphaBar         = 1<<18,  //              // ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
    HDR              = 1<<19,  //              // (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
    DisplayRGB       = 1<<20,  // [Display]    // ColorEdit: override _display_ type among RGB/HSV/Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
    DisplayHSV       = 1<<21,  // [Display]    // "
    DisplayHex       = 1<<22,  // [Display]    // "
    Uint8            = 1<<23,  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
    Float            = 1<<24,  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
    PickerHueBar     = 1<<25,  // [Picker]     // ColorPicker: bar for Hue, rectangle for Sat/Value.
    PickerHueWheel   = 1<<26,  // [Picker]     // ColorPicker: wheel for Hue, triangle for Sat/Value.
    PickerNoRotate   = 1<<27,  // [Picker]     // ColorPicker: disable rotating Sat/Value triangle. Best set in io.ConfigColorEditFlags once.
    InputRGB         = 1<<28,  // [Input]      // ColorEdit, ColorPicker: input and output data in RGB format.
    InputHSV         = 1<<29,  // [Input]      // ColorEdit, ColorPicker: input and output data in HSV format.

    // Defaults Options copied to io.ConfigColorEditFlags during initialization.
    // The intent is that you probably don't want to override them in most of your calls.
    // Let the user choose via the option menu and/or modify io.ConfigColorEditFlags directly during startup if you want.
    DefaultOptions_  = 1<<23 | 1<<20 | 1<<28 | 1<<25,

    // [Internal] Masks
    AlphaMask_       = 1<<1 | 1<<12 | 1<<13 | 1<<14,
    DisplayMask_     = 1<<20 | 1<<21 | 1<<22,
    DataTypeMask_    = 1<<23 | 1<<24,
    PickerMask_      = 1<<26 | 1<<25,
    InputMask_       = 1<<28 | 1<<29,

    // Obsolete names
    AlphaPreview     = 0,      // Removed in 1.91.8. This is the default now. Will display a checkerboard unless ImGuiColorEditFlags_AlphaNoBg is set.
    //ImGuiColorEditFlags_RGB = ImGuiColorEditFlags_DisplayRGB, ImGuiColorEditFlags_HSV = ImGuiColorEditFlags_DisplayHSV, ImGuiColorEditFlags_HEX = ImGuiColorEditFlags_DisplayHex  // [renamed in 1.69]

    _,
};

pub const ImGuiInputTextFlags = enum (i32) {
    // Basic filters (also see ImGuiInputTextFlags_CallbackCharFilter)
    None                = 0,
    CharsDecimal        = 1<<0,   // Allow 0123456789.+-*/
    CharsHexadecimal    = 1<<1,   // Allow 0123456789ABCDEFabcdef
    CharsScientific     = 1<<2,   // Allow 0123456789.+-*/eE (Scientific notation input)
    CharsUppercase      = 1<<3,   // Turn a..z into A..Z
    CharsNoBlank        = 1<<4,   // Filter out spaces, tabs

    // Inputs
    AllowTabInput       = 1<<5,   // Pressing TAB input a '\t' character into the text field
    EnterReturnsTrue    = 1<<6,   // Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider disabling LiveEdit! or using IsItemDeactivatedAfterEdit() instead!
    EscapeClearsAll     = 1<<7,   // Escape key clears content if not empty, and deactivate otherwise (contrast to default behavior of Escape to revert)
    CtrlEnterForNewLine = 1<<8,   // In multi-line mode: validate with Enter, add new line with Ctrl+Enter (default is opposite: validate with Ctrl+Enter, add line with Enter). Note that Shift+Enter always enter a new line either way.

    // Other options
    ReadOnly            = 1<<9,   // Read-only mode
    Password            = 1<<10,  // Password mode, display all characters as '*', disable copy
    AlwaysOverwrite     = 1<<11,  // Overwrite mode
    AutoSelectAll       = 1<<12,  // Select entire text when first taking mouse focus
    ParseEmptyRefVal    = 1<<13,  // InputFloat(), InputInt(), InputScalar() etc. only: parse empty string as zero value.
    DisplayEmptyRefVal  = 1<<14,  // InputFloat(), InputInt(), InputScalar() etc. only: when value is zero, do not display it. Generally used with ImGuiInputTextFlags_ParseEmptyRefVal.
    NoHorizontalScroll  = 1<<15,  // Disable following the cursor horizontally
    NoUndoRedo          = 1<<16,  // Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
    //ImGuiInputTextFlags_NoLiveEdit        = 1 << 25,  // Disable applying output to backing variable while typing. Same as setting ImGuiItemFlags_LiveEditOnInput to false.

    // Elide display / Alignment
    ElideLeft           = 1<<17,  // When text doesn't fit, elide left side to ensure right side stays visible. Useful for path/filenames. Single-line only!

    // Callback features
    CallbackCompletion  = 1<<18,  // Callback on pressing TAB (for completion handling)
    CallbackHistory     = 1<<19,  // Callback on pressing Up/Down arrows (for history handling)
    CallbackAlways      = 1<<20,  // Callback on each iteration. User code may query cursor position, modify text buffer.
    CallbackCharFilter  = 1<<21,  // Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
    CallbackResize      = 1<<22,  // Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
    CallbackEdit        = 1<<23,  // Callback on any edit. Note that InputText() already returns true on edit + you can always use IsItemEdited(). The callback is useful to manipulate the underlying buffer while focus is active.

    // Multi-line Word-Wrapping [BETA]
    // - Not well tested yet. Please report any incorrect cursor movement, selection behavior etc. bug to https://github.com/ocornut/imgui/issues/3237.
    // - Wrapping style is not ideal. Wrapping of long words/sections (e.g. words larger than total available width) may be particularly unpleasing.
    // - Wrapping width needs to always account for the possibility of a vertical scrollbar.
    // - It is much slower than regular text fields.
    //   Ballpark estimate of cost on my 2019 desktop PC: for a 100 KB text buffer: +~0.3 ms (Optimized) / +~1.0 ms (Debug build).
    //   The CPU cost is very roughly proportional to text length, so a 10 KB buffer should cost about ten times less.
    WordWrap            = 1<<24,  // InputTextMultiline(): word-wrap lines that are too long.

    // Obsolete names
    //ImGuiInputTextFlags_AlwaysInsertMode  = ImGuiInputTextFlags_AlwaysOverwrite   // [renamed in 1.82] name was not matching behavior
};

// pub const WindowFlags = i32;
pub const TreeNodeFlags = i32;

pub const ID = u32;
pub const ViewportFlags = i32;
// pub const Cond = i32;

pub const TerminatedString = [*:0]const u8;

pub const Vec2 = extern struct {
    x: f32,
    y: f32,
};

pub const Viewport = extern struct {
    ID: ID,
    flags: ViewportFlags,
    pos: Vec2,
    size: Vec2,
    framebufferScale: Vec2,
    workPos: Vec2,
    workSize: Vec2,

    platformHandle: *void,
    platformHandleRaw: *void,

    // ImGuiViewport()     { memset((void*)this, 0, sizeof(*this)); }

    // Helpers
    /// Implementation of getCenter within zig bindings
    pub fn getCenterZ(v: Viewport) Vec2 {
        return .{
            .x = v.Pos.x + v.Size.x * 0.5,
            .y = v.Pos.y + v.Size.y * 0.5
        };
    }

    /// Implementation of getWorkCenter within zig bindings
    pub fn getWorkCenterZ(v: Viewport) Vec2 {
        return .{
            .x = v.WorkPos.x + v.WorkSize.x * 0.5,
            .y = v.WorkPos.y + v.WorkSize.y * 0.5
        };
    }
};

pub fn getMainViewport() *Viewport {
    return ImGui_GetMainViewport();
}

extern fn ImGui_GetMainViewport() *Viewport;

pub fn setNextWindowPos(pos: Vec2, cond: Cond) void {
    ImGui_SetNextWindowPos(pos, cond);
}

pub fn setNextWindowSize(size: Vec2, cond: Cond) void {
    ImGui_SetNextWindowSize(size, cond);
}

extern fn ImGui_SetNextWindowPos(pos: Vec2, cond: Cond) void;
extern fn ImGui_SetNextWindowSize(size: Vec2, cond: Cond) void;

pub fn setNextWindowSizeConstraints(size_min: Vec2, size_max: Vec2) void {
    return ImGui_SetNextWindowSizeConstraints(size_min, size_max, null, null);
}

// TODO Add callback types
extern fn ImGui_SetNextWindowSizeConstraints(size_min: Vec2, size_max: Vec2, custom_callback: ?*void, custom_callback_data: ?*void) void;

pub fn getWindowSize() Vec2 {
    return ImGui_GetWindowSize();
}

extern fn ImGui_GetWindowSize() Vec2;

pub fn dragFloat(label: TerminatedString, v: *f32) bool {
    return ImGui_DragFloat(label, v);
}

pub fn dragInt(label: TerminatedString, v: *i32) bool {
    return ImGui_DragInt(label, v);
}

extern fn ImGui_DragFloat(label: TerminatedString, v: *f32) bool;
extern fn ImGui_DragInt(label: TerminatedString, v: *i32) bool;

pub fn sliderFloat(label: TerminatedString, v: *f32, v_min: f32, v_max: f32) bool {
    return ImGui_SliderFloat(label, v, v_min, v_max);
}

pub fn sliderInt(label: TerminatedString, v: *i32, v_min: i32, v_max: i32) bool {
    return ImGui_SliderInt(label, v, v_min, v_max);
}

pub fn sliderAngle(label: TerminatedString, v: *f32) bool {
    return ImGui_SliderAngle(label, v);
}

extern fn ImGui_SliderFloat(label: TerminatedString, v: *f32, v_min: f32, v_max: f32) bool;
extern fn ImGui_SliderInt(label: TerminatedString, v: *i32, v_min: i32, v_max: i32) bool;
extern fn ImGui_SliderAngle(label: TerminatedString, v_rad: *f32) bool;

pub fn inputFloat(label: TerminatedString, v: *f32) bool {
    return ImGui_InputFloat(label, v);
}

pub fn inputInt(label: TerminatedString, v: *i32) bool {
    return ImGui_InputInt(label, v);
}

pub fn inputDouble(label: TerminatedString, v: *f64) bool {
    return ImGui_InputDouble(label, v);
}

extern fn ImGui_InputFloat(label: TerminatedString, v: *f32) bool;
extern fn ImGui_InputInt(label: TerminatedString, v: *i32) bool;
extern fn ImGui_InputDouble(label: TerminatedString, v: *f64) bool;

pub fn inputFloat2(label: TerminatedString, v: *[2]f32) bool {
    return ImGui_InputFloat2(label, v);
}

pub fn inputFloat3(label: TerminatedString, v: *[3]f32) bool {
    return ImGui_InputFloat3(label, v);
}

pub fn inputFloat4(label: TerminatedString, v: *[4]f32) bool {
    return ImGui_InputFloat4(label, v);
}

extern fn ImGui_InputFloat2(label: TerminatedString, v: *[2]f32) bool;
extern fn ImGui_InputFloat3(label: TerminatedString, v: *[3]f32) bool;
extern fn ImGui_InputFloat4(label: TerminatedString, v: *[4]f32) bool;

pub fn colorEdit3(label: TerminatedString, col: *[3]f32, flags: ImGuiColorEditFlags) bool {
    return ImGui_ColorEdit3(label, col, flags);
}

pub fn colorEdit44(label: TerminatedString, col: *[4]f32, flags: ImGuiColorEditFlags) bool {
    return ImGui_ColorEdit4(label, col, flags);
}

extern fn ImGui_ColorEdit3(label: TerminatedString, col: *[3]f32, flags: ImGuiColorEditFlags) bool;
extern fn ImGui_ColorEdit4(label: TerminatedString, col: *[4]f32, flags: ImGuiColorEditFlags) bool;

pub fn combo(label: TerminatedString, current_item: *i32, items_separated_by_zeros: TerminatedString) bool {
    return ImGui_Combo(label, current_item, items_separated_by_zeros);
}

extern fn ImGui_Combo(label: TerminatedString, current_item: *i32, items_separated_by_zeros: TerminatedString) bool;

pub fn listBox(label: TerminatedString, current_item: *i32, items: *[]TerminatedString, items_count: i32, height_in_items: i32) bool {
    return ImGui_ListBox(label, current_item, items, items_count, height_in_items);
}

extern fn ImGui_ListBox(label: TerminatedString, current_item: *i32, items: *[]TerminatedString, items_count: i32, height_in_items: i32) bool;

pub fn inputText(label: TerminatedString, buf: *[]u8, buf_size: usize, flags: ImGuiInputTextFlags) bool {
    return ImGui_InputText(label, buf, buf_size, flags);
}

extern fn ImGui_InputText(label: TerminatedString, buf: *[]u8, buf_size: usize, flags: ImGuiInputTextFlags) bool;

pub fn showDemoWindow(open: *bool) void {
    ImGui_ShowDemoWindow(open);
}

extern fn ImGui_ShowDemoWindow(*bool) void;

pub fn begin(name: TerminatedString, open: *bool, flags: WindowFlags) bool {
    return ImGui_Begin(name, open, @as(c_int, @intFromEnum(flags)));
}

pub fn end() void {
    ImGui_End();
}

extern fn ImGui_Begin(name: TerminatedString, p_open: *bool, flags: c_int) bool;
extern fn ImGui_End() void;

pub fn textUnformatted(text: TerminatedString) void {
    ImGui_TextUnformatted(text);
}

pub fn textZigFMT(alloc: std.mem.Allocator, comptime fmt: []const u8, args: anytype) !void {
    const string = try alloc.printSentinel(fmt, args, 0);
    defer alloc.free(string);
    textUnformatted(string);
}

extern fn ImGui_TextUnformatted(text: TerminatedString) void;

pub fn spacing() void {
    ImGui_Spacing();
}

extern fn ImGui_Spacing() void;

pub fn collapsingHeader(label: TerminatedString, flags: TreeNodeFlags) bool {
    return ImGui_CollapsingHeader(label, flags);
}

pub fn collapsingHeaderBoolPtr(label: TerminatedString, visible: *bool, flags: TreeNodeFlags) bool {
    return ImGui_CollapsingHeaderBoolPtr(label, visible, flags);
}

extern fn ImGui_CollapsingHeader(label: TerminatedString, flags: TreeNodeFlags) bool;
extern fn ImGui_CollapsingHeaderBoolPtr(label: TerminatedString, p_visible: *bool, flags: TreeNodeFlags) bool;

pub fn separatorText(label: TerminatedString) void {
    ImGui_SeparatorText(label);
}

extern fn ImGui_SeparatorText(label: TerminatedString) void;

pub fn sameLine() void {
    ImGui_SameLine();
}

extern fn ImGui_SameLine() void;

pub fn labelText(label: TerminatedString, fmt: TerminatedString, args: anytype) void {
    ImGui_LabelText(label, fmt, args);
}

extern fn ImGui_LabelText(label: TerminatedString, fmt: TerminatedString, ...) void;

// extern fn ImGui_CreateContext(*ImFontAtlas) *ImGuiContext;
// extern fn ImGui_DestroyContext(*ImGuiContext) void;