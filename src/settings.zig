const ig = @import("imgui");

pub const Theme = enum {
    dark,
    light,
    classic,

    pub fn name(self: Theme) [*:0]const u8 {
        return switch (self) {
            .dark => "Dark",
            .light => "Light",
            .classic => "Classic",
        };
    }
};

pub const CryptoApi = enum {
    coin_gecko,

    fn name(self: CryptoApi) [*:0]const u8 {
        return switch (self) {
            .coin_gecko => "Coin Gecko [https://coingecko.com/]",
        };
    }
};

pub const Crypto = struct {
    api: CryptoApi,

    fn init() Crypto {
        return Crypto {
            .api = CryptoApi.coin_gecko,
        };
    }
};

pub const Settings = struct {
    theme: Theme,
    background_colour: [3]f32,
    crypto: Crypto,

    pub fn init() Settings {
        return Settings {
            .theme = Theme.dark,
            .background_colour = [3]f32{ 0.2, 0.2, 0.2 },
            .crypto = Crypto.init(),
        };
    }
};

pub fn showSettingsView(instance_settings: *Settings) void {
    const open = ig.Begin("Settings");
    defer ig.End();

    if (!open) return;

    var settings_changed = false;

    if (ig.TreeNodeEx_Str("Theme")) {
        defer ig.TreePop();

        var display = instance_settings.theme.name();
        if (ig.BeginCombo("Theme", display)) {
            defer ig.EndCombo();
            
            if (ig.Selectable_Bool(Theme.dark.name())) {
                instance_settings.theme = Theme.dark;
                settings_changed = true;
            } else if (ig.Selectable_Bool(Theme.light.name())) {
                instance_settings.theme = Theme.light;
                settings_changed = true;
            } else if (ig.Selectable_Bool(Theme.classic.name())) {
                instance_settings.theme = Theme.classic;
                settings_changed = true;
            }
        }

        _ = ig.ColorEdit3Ext("Background Colour", &instance_settings.background_colour,
                ig.ColorEditFlags{ .NoInputs = true });
    }

    if (ig.TreeNodeEx_Str("APIs")) {
        defer ig.TreePop();

        var crypto_api_display = instance_settings.crypto.api.name();
        if (ig.BeginCombo("Cryptocurrency", crypto_api_display)) {
            defer ig.EndCombo();

            if (ig.Selectable_Bool(CryptoApi.coin_gecko.name())) {
                instance_settings.crypto.api = CryptoApi.coin_gecko;
            }
        }
    }

    if (settings_changed) apply(instance_settings);
}

fn apply(instance_settings: *Settings) void {
    switch (instance_settings.theme) {
        .dark    => ig.StyleColorsDark(),
        .light   => ig.StyleColorsLight(),
        .classic => ig.StyleColorsClassic(),
    }
}