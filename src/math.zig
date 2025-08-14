pub const Float3 = struct {
    x: f32, y: f32, z: f32,

    pub fn init(x: f32, y: f32, z: f32) Float3 {
        return Float3 {
            .x = x,
            .y = y,
            .z = z,

        };
    }
};