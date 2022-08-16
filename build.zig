const std = @import("std");
const path = std.fs.path;
const Builder = std.build.Builder;
const LibExeObjStep = std.build.LibExeObjStep;

const imgui_build = @import("zig-imgui/imgui_build.zig");

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable("finv", "src/main.zig");
    setDependencies(exe, mode, target);
    exe.install();
}

fn setDependencies(step: *LibExeObjStep, mode: std.builtin.Mode, target: std.zig.CrossTarget) void {
    step.setBuildMode(mode);
    step.linkLibCpp();

    imgui_build.link(step, "zig-imgui/imgui");

    if (target.getOs().tag == .windows) {
        step.addObjectFile(if (target.getAbi() == .msvc) "lib/win/glfw3.lib" else "lib/win/libglfw3.a");
        step.addObjectFile("lib/win/vulkan-1.lib");
        step.linkSystemLibrary("gdi32");
        step.linkSystemLibrary("shell32");
        if (step.kind == .exe) {
            step.subsystem = .Windows;
        }
    } else {
        step.linkSystemLibrary("glfw");
        step.linkSystemLibrary("vulkan");
    }
}