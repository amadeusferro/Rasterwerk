const Std = @import("std");

const Float3 = @import("math.zig").Float3;

pub const IMG = struct {
    width: u32,
    height: u32,
    pixels: []Float3,

    pub fn init(width: u32, height: u32, pixels: []Float3) IMG {
        return IMG {
            .width = width,
            .height = height,
            .pixels = pixels
        };
    }

    pub fn deinit(self: *const @This(), allocator: *const Std.mem.Allocator) void {
        allocator.free(self.pixels);
    }

    pub fn get_test_pixels(allocator: Std.mem.Allocator, width: u32, height: u32) []Float3 {
        const pixels = allocator.alloc(Float3, width * height) catch unreachable;  // TODO: Remove unreachable

        for (0..height) |y| {
            for (0..width) |x| {
                const g = @as(f32, @floatFromInt(y)) / @as(f32, @floatFromInt(height - 1));
                const b = @as(f32, @floatFromInt(x)) / @as(f32, @floatFromInt(width - 1));
                pixels[y * width + x] = Float3.init(b, g, 0.0);
            }
        }
        return pixels;
    }

    pub fn save_as_bmp(self: *const @This(), comptime path: []const u8) void {
        const tag = [_]u8{'B', 'M'};
        const header = [_]u32{
            0x36 + @as(u32, @intCast(self.width * self.height * 3)),    // File size
            0x00,                                                       // Unused
            0x36,                                                       // Byte offset of pixel data
            0x28,                                                       // Header size
            self.width, self.height,                                    // Image dimensions
            0x180001,                                                   // 24 bits/pixel
            0,                                                          // No compression
            0,                                                          // Pixel data size
            0x002e23, 0x002e23,                                         // Print resolution
            0, 0,                                                       // No color palette
        };



        const file = Std.fs.cwd().createFile(path ++ ".bmp", .{}) catch unreachable;  // TODO: Remove unreachable
        defer file.close();

        var buffered_writer = Std.io.bufferedWriter(file.writer());
        const writer = buffered_writer.writer();



        writer.writeAll(&tag) catch unreachable;  // TODO: Remove unreachable
        writer.writeAll(Std.mem.asBytes(&header)) catch unreachable;  // TODO: Remove unreachable

        for (self.pixels) |pixel| {
            writer.writeByte(@as(u8, @intFromFloat(pixel.x * 255.0))) catch unreachable;  // TODO: Remove unreachable
            writer.writeByte(@as(u8, @intFromFloat(pixel.y * 255.0))) catch unreachable;  // TODO: Remove unreachable
            writer.writeByte(@as(u8, @intFromFloat(pixel.z * 255.0))) catch unreachable;  // TODO: Remove unreachable
        }

        buffered_writer.flush() catch unreachable;  // TODO: Remove unreachable
    }
};
