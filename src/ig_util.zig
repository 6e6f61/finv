const ig = @import("imgui");

pub fn finvSensibleSize() void {
    ig.SetNextWindowSizeExt(ig.Vec2{ .x = 400, .y = 200 },
        ig.CondFlags{ .Always = true });
}

pub fn centerNextWindow() void {
    const viewport = ig.GetMainViewport();
    const centre = viewport.?.GetCenter();

    ig.SetNextWindowPosExt(centre, ig.CondFlags{ .Always = true },
        ig.Vec2{ .x = 0.5, .y = 0.5 });
}