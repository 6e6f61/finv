const Api = enum {
    coin_gecko,
};

const Holding = struct {
    name: []const u8,
    ticker: []const u8,
    quantity: f64,
};

const Crypto = struct {
    api: Api,
    holdings: []Holding,
};

pub fn show_crypto_view(crypto: *Crypto) void {
    _ = crypto;
}