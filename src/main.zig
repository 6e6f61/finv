const std = @import("std");
const ig = @import("imgui");
const vk = @import("vk");

const engine = @import("imgui/engine.zig");

const crypto = @import("crypto.zig");
const settings = @import("settings.zig");
const positions = @import("positions.zig");
const ig_util = @import("ig_util.zig");

const Allocator = std.mem.Allocator;

const heap_allocator = std.heap.c_allocator;

pub fn main() !void {
    try engine.init("FinV", heap_allocator);
    defer engine.deinit();

    var show_stocks_view = false;
    var show_crypto_view = false;

    var show_positions = false;

    var show_settings = false;
    var show_demo_window = false;

    var instance_settings = settings.Settings.init();
    var instance_positions = positions.Positions.init();

    // Main loop
    while (try engine.beginFrame()) : (engine.endFrame()) {
        //
        // Build frame
        //
        // Menubar
        {
            _ = ig.BeginMainMenuBar();
            {
                if (ig.BeginMenu("View")) {
                    defer ig.EndMenu();

                    _ = ig.MenuItem_BoolPtr("Stocks", "Ctrl+Shift+S", &show_stocks_view);
                    _ = ig.MenuItem_BoolPtr("Crypto", "Ctrl+Shift+C", &show_crypto_view);
                }

                _ = ig.MenuItem_BoolPtr("Positions", "Ctrl+P", &show_positions);

                _ = ig.MenuItem_BoolPtr("Settings", "", &show_settings);
                _ = ig.MenuItem_BoolPtr("Demo", "", &show_demo_window);
            }
            ig.EndMainMenuBar();
        }

        //
        // Logic
        //
        if (show_demo_window) ig.ShowDemoWindowExt(&show_demo_window);

        if (show_crypto_view) crypto.showCryptoView(&instance_positions.crypto);
        if (show_positions) {
            ig_util.finvSensibleSize();
            ig_util.centerNextWindow();
            try positions.showPositionsView(&instance_positions);
        }

        if (show_settings) {
            ig_util.finvSensibleSize();
            ig_util.centerNextWindow();
            settings.showSettingsView(&instance_settings);
        }

        //
        // Draw frame
        //
        var frame = try engine.render.beginRender();
        defer frame.end();
        var colorRender = try frame.beginColorPass(ig.Vec4 {
            .x = instance_settings.background_colour[0],
            .y = instance_settings.background_colour[1],
            .z = instance_settings.background_colour[2],
            .w = 1,
        });
        defer colorRender.end();

        try engine.render.renderImgui(&colorRender);
    }
}

pub export fn WinMain(
    hInstance: ?*anyopaque,
    hPrevInstance: ?*anyopaque,
    lpCmdLine: ?[*:0]const u8,
    nShowCmd: c_int,
) void {
    _ = nShowCmd;
    _ = lpCmdLine;
    _ = hPrevInstance;
    _ = hInstance;
    std.debug.maybeEnableSegfaultHandler();
    main() catch |err| {
        std.log.err("{s}", .{@errorName(err)});
        if (@errorReturnTrace()) |trace| {
            std.debug.dumpStackTrace(trace.*);
        }
        std.os.exit(1);
    };
    std.os.exit(0);
}
