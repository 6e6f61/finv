const fmt = @import("std").fmt;

pub const Value = struct {
    // Though we're not modifying the stored value at all, I'm avoiding using a float here.
    // Different cryptocurrencies care for different levels of decimal precision so storing a single
    // int and dividing it by (8, 12, etc.), wouldn't be scalable.
    // This is an okay solution for now.
    integer: u32,
    decimal: u32,

    pub fn many(self: Value) ![*]const u8 {
        var value: *[21]u8 = undefined;

        _ = try fmt.bufPrint(value, "{d}.{d}", .{self.integer, self.decimal});

        return value[0..value.len];
    } 
};