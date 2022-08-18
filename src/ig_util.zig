const std = @import("std");
const ig = @import("imgui");

pub const invalid_colour = ig.Vec4 {
    .x = 0,
    .y = 100,
    .z = 0,
    .w = 0,
};

pub fn finvSensibleSize() void {
    ig.SetNextWindowSizeExt(ig.Vec2{ .x = 400, .y = 200 },
        ig.CondFlags{ .FirstUseEver = true });
}

pub fn centerNextWindow() void {
    const viewport = ig.GetMainViewport();
    const centre = viewport.?.GetCenter();

    ig.SetNextWindowPosExt(centre, ig.CondFlags{ .FirstUseEver = true },
        ig.Vec2{ .x = 0.5, .y = 0.5 });
}

/// Creates a button that is disabled when condition is true
pub inline fn disablableButton(label: [*:0]const u8, condition: bool) bool {
    // Supposedly imgui doesn't have a function to disable the functionality
    // of a button, only to change its styling to appear disabled. (There's
    // a function in imgui_internal, but it's not exposed by zig-imgui),
    // so we'll hack around and that and always return false if we're expecting to disable
    // the button.
    if (condition) ig.BeginDisabled();
    const r = ig.Button(label);
    std.log.debug("{}", .{r});
    if (condition) {
        ig.EndDisabled();
        return false;
    }

    return r;
}