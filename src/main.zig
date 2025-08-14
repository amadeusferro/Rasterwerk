const Std = @import("std");

const IMG = @import("image.zig").IMG;

pub fn main() !void {

    var arena = Std.heap.ArenaAllocator.init(Std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();


     const pixels = IMG.get_test_pixels(allocator, 1920, 1080);

     const my_img = IMG.init(1920, 1080, pixels);
     defer my_img.deinit(&allocator);

     my_img.save_as_bmp("my_img");
}
