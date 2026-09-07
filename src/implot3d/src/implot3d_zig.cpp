#include "implot3d.h"

extern "C" {
    void implot3d_ShowDemoWindow(bool *p_open) {
        ImPlot3D::ShowDemoWindow(p_open);
    }

    ImPlot3DContext* implot3d_CreateContext() {
        return ImPlot3D::CreateContext();
    }

    void implot3d_DestroyContext(ImPlot3DContext* ctx) {
        ImPlot3D::DestroyContext(ctx);
    }
}