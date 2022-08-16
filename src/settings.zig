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

pub const Settings = struct {
    theme: Theme,

    pub fn loadOrInit() Settings {
        return Settings {
            .theme = Theme.dark,
        };
    }
};

pub fn show_settings_view(instance_settings: *Settings) void {
    const open = ig.Begin("Settings");
    defer ig.End();

    if (!open) return;

    var settings_changed = false;

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

    if (settings_changed) apply(instance_settings);
}

fn apply(instance_settings: *Settings) void {
    switch (instance_settings.theme) {
        .dark    => ig.StyleColorsDark(),
        .light   => ig.StyleColorsLight(),
        .classic => ig.StyleColorsClassic(),
    }
}