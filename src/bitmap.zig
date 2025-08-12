const Std = @import("std");

const Float3 = @import("types.zig").Float3;


pub const IMG = struct {

    width: u32,
    height: u32,

    image: []Float3,

    pub fn init(width: u32, height: u32, ) IMG {



        return IMG {
            .width = width,
            .height = height,
        };
    }






};

pub fn testImage() !void {
    const width = 64;
    const height = 64;
    var image: [width * height]Float3 = undefined;

    for (0..height) |y| {
        for (0..width) |x| {
            const g = @as(f32, @floatFromInt(y)) / (height - 1);
            const b = @as(f32, @floatFromInt(x)) / (width - 1);

            image[y * width + x] = Float3.init(b, g, 0.0);
        }
    }



    try write_image_to_file(&image);

}

fn write_image_to_file(image: []Float3) !void {
    Std.debug.print("{d}", .{image.len});

    const file = try Std.fs.cwd().createFile("xuu.bmp", .{});
    defer file.close();

    var buffered_writer = Std.io.bufferedWriter(file.writer());
    const writer = buffered_writer.writer();

    const my_data: u32 = 0xDEADBEEF;
    try writer.writeInt(u32, my_data, Std.builtin.Endian.little);

    const my_string = "Hello, Zig!";
    try writer.writeAll(my_string);

    try buffered_writer.flush();
}