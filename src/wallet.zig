const std = @import("std");
const mem = @import("std").mem;

const Value = @import("value.zig").Value;

pub const Wallet = struct {
    ticker: []const u8,
    address: []const u8,
    value: Value,

    /// Attempt to identify the currency of a wallet based on an address.
    pub fn guessFromAddress(address: []const u8) ?Wallet {
        if (mem.startsWith(u8, address, "test")) {
            return Wallet {
                .ticker = "ETH",
                .address = address,
                .value = Value {
                    .integer = 1,
                    .decimal = 4859,
                }
            };
        }

        return null;
    }
};
