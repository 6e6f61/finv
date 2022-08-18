const std = @import("std");
const fmt = std.fmt;

const ig = @import("imgui");

const crypto = @import("crypto.zig");
const ig_util = @import("ig_util.zig");

const heap_allocator = std.heap.c_allocator;

// python -c "print(len('2147483647.2147483647'))"
const max_holding_value_len = 21;

pub const Holding = struct {
    name: []const u8,
    ticker: []const u8,
    // Though we're not modifying the stored value at all, I'm avoiding using a float here.
    // Different cryptocurrencies care for different levels of decimal precision so storing a single
    // int and dividing it by (8, 12, etc.), wouldn't be scalable.
    // This is an okay solution for now.
    integer: u32,
    decimal: u32,

    pub fn valueMany(self: Holding) [*]const u8 {
        var value: [max_holding_value_len]u8 = undefined;
        var buf_stream = std.io.fixedBufferStream(&value);

        try fmt.bufPrint(buf_stream, "{d}.{d}", .{self.integer, self.decimal});

        return value[0..value.len];
    }
};

pub const Positions = struct {
    crypto: []Holding,

    pub fn init() Positions {
        return Positions {
            .crypto = std.mem.zeroes([]Holding),
        };
    }
};

pub fn showPositionsView(positions: *Positions) !void {
    const open = ig.Begin("Positions");
    defer ig.End();

    if (!open) return;

    if (ig.TreeNodeEx_Str("Cryptocurrency")) {
        defer ig.TreePop();

        if (ig.Button("Add")) {
            ig.OpenPopup_Str("Add Cryptocurrency Holding");
        }

        ig_util.finvSensibleSize();
        ig_util.centerNextWindow();
        if (ig.BeginPopupModal("Add Cryptocurrency Holding")) {
            defer ig.EndPopup();

            if (ig.BeginCombo("Ticker", "XMR")) {
                defer ig.EndCombo();

                _ = ig.Selectable_Bool("XMR");
                _ = ig.Selectable_Bool("BTC");
                _ = ig.Selectable_Bool("ETH");
            }

            var quantity_buf: *[max_holding_value_len]u8 = undefined;

            if (ig.InputTextExt("Quantity", quantity_buf, max_holding_value_len,
                    ig.InputTextFlags{ .CharsDecimal = true }, null, null)) {
            }
        }

        _ = ig.BeginTable("Cryptocurrency", 3);
        defer ig.EndTable();

        _ = ig.TableSetupColumn("Ticker");
        _ = ig.TableSetupColumn("Quantity");
        _ = ig.TableSetupColumn("Modify");
        _ = ig.TableHeadersRow();

        for (positions.crypto) |position| {
            _ = ig.TableNextRow();

            _ = ig.TableSetColumnIndex(0);
            _ = ig.Text("%s", position.ticker);
            _ = ig.TableSetColumnIndex(1);
            _ = ig.Text("%d.%d", position.integer, position.decimal);
            _ = ig.TableSetColumnIndex(2);
            if (ig.Button("Remove")) {

            }
            
            //_ = ig.TextUnformatted(position.ticker);
            //_ = ig.TextUnformatted(position.valueMany());
        }
    }
}