const std = @import("std");

const Tool = enum {
    Select,
    Pen,
};

const HitPart = enum {
    None,
    Anchor,
    HandleIn,
    HandleOut,
};

const HandleMode = enum {
    Corner,
    Mirrored,
    Aligned,
    Free,
};

const ControlPointShape = enum {
    Circle,
    Square,
    Diamond,
};

const EditKind = enum {
    MoveAnchor,
    MoveHandle,
    AddAnchor,
    DeleteAnchor,
    AddHandle,
    DeleteHandle,
    ChangePointMode,
    PathOperation,
};

