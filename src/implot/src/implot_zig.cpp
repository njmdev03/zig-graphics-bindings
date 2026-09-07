#include "implot.h"

extern "C" {
    void implot_ShowDemoWindow(bool* p_open) {
        ImPlot::ShowDemoWindow(p_open);
    }

    ImPlotContext* implot_CreateContext() {
        return ImPlot::CreateContext();
    }

    void implot_DestroyContext(ImPlotContext* ctx) {
        ImPlot::DestroyContext(ctx);
    }
}