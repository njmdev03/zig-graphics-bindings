#pragma once
#include "rlImGui.h"

extern "C" {
    void zig_rlImGuiSetup(bool darkTheme) {
        rlImGuiSetup(darkTheme);
    }

    void zig_rlImGuiBegin(void) {
        rlImGuiBegin();
    }

    void zig_rlImGuiEnd(void) {
        rlImGuiEnd();
    }

    void zig_rlImGuiShutdown(void) {
        rlImGuiShutdown();
    }
}