const std = @import("std");
const fmt = std.fmt;

const ig = @import("imgui");

const crypto = @import("crypto.zig");
const ig_util = @import("ig_util.zig");
const Wallet = @import("wallet.zig").Wallet;

const ArrayList = std.ArrayList;
const heap_allocator = std.heap.c_allocator;

// python -c "print(len('2147483647.2147483647'))"
const max_holding_value_len = 21;

//pub const Holding = struct {
//    name: []const u8,
//    ticker: []const u8,
//    value: Value,
//};

pub const Crypto = struct {
    wallets: ArrayList(Wallet),
    // TODO: Option for manually added positions (for XMR etc., or integrate with nodes + view keys)
};

pub const Positions = struct {
    crypto: Crypto,

    pub fn init() Positions {
        return Positions {
            .crypto = Crypto { .wallets = ArrayList(Wallet).init(heap_allocator) },
        };
    }
};

pub fn showPositionsView(positions: *Positions) !void {
    const open = ig.Begin("Positions");
    defer ig.End();

    if (!open) return;

    if (ig.TreeNodeEx_Str("Cryptocurrency")) {
        defer ig.TreePop();

        //if (ig.Button("Add Position")) {
        //    ig.OpenPopup_Str("Add Cryptocurrency Position");
        //}

        if (ig.Button("Add Address")) {
            ig.OpenPopup_Str("Add Cryptocurrency Address");
        }

        //ig_util.finvSensibleSize();
        //ig_util.centerNextWindow();
        //if (ig.BeginPopupModal("Add Cryptocurrency Position")) {
        //    defer ig.EndPopup();

        //    if (ig.BeginCombo("Ticker", "XMR")) {
        //        defer ig.EndCombo();

        //        _ = ig.Selectable_Bool("XMR");
        //        _ = ig.Selectable_Bool("BTC");
        //        _ = ig.Selectable_Bool("ETH");
        //    }

        //    var quantity_buf = std.mem.zeroes([max_holding_value_len]u8);
        //    if (ig.InputTextExt("Quantity", &quantity_buf, max_holding_value_len,
        //            ig.InputTextFlags{ .CharsDecimal = true }, null, null)) {
        //    }
        //}

        ig_util.finvSensibleSize();
        ig_util.centerNextWindow();
        if (ig.BeginPopupModal("Add Cryptocurrency Address")) {
            defer ig.EndPopup();

            var address_buf = std.mem.zeroes([512]u8);
            
            // I don't think this [0..] hackery is idiomatic.
            _ = ig.InputTextExt("Address", address_buf[0..], 512, .{}, null, null);
            const wallet = Wallet.guessFromAddress(address_buf[0..]);

            if (ig_util.disablableButton("Add", wallet == null)) {
                try positions.crypto.wallets.append(wallet.?);
                ig.CloseCurrentPopup();
            }
            ig.SameLine();
            if (ig.Button("Cancel")) {
                ig.CloseCurrentPopup();
            }
        }

        // Addresses
        {
            _ = ig.BeginTable("Cryptocurrency", 3);
            defer ig.EndTable();

            _ = ig.TableSetupColumn("Ticker");
            _ = ig.TableSetupColumn("Address");
            //_ = ig.TableSetupColumn("Quantity");
            _ = ig.TableSetupColumn("Modify");
            _ = ig.TableHeadersRow();

            for (positions.crypto.wallets.items) |wallet| {
                _ = ig.TableNextRow();

                _ = ig.TableSetColumnIndex(0);
                _ = ig.TextUnformatted(wallet.ticker.ptr);
                _ = ig.TableSetColumnIndex(1);
                _ = ig.Text("%d.%d", (try wallet.value.many()));
                _ = ig.TableSetColumnIndex(2);
                if (ig.Button("Remove")) {

                }
            }
        }
    }
}