const std = @import("std");

// know when a step doesn't need to be re-run).
pub fn build(b: *std.Build) void {
 
    const target = b.standardTargetOptions(.{});
   
    const optimize = b.standardOptimizeOption(.{});
 
    const exe = b.addExecutable(.{
        .name = "Rasterwerk",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);
}
