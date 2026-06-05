#!/usr/bin/env bash
# Called by noctalia darkModeChange hook.
# Switches Kvantum theme + GTK theme name (noctalia handles color overrides on top).

set -eu

arg="${1:-}"
case "$arg" in
    true|dark)  mode="dark" ;;
    false|light) mode="light" ;;
    *)
        if grep -q '"darkMode": *true' ~/.config/noctalia/settings.json 2>/dev/null; then
            mode="dark"
        else
            mode="light"
        fi
        ;;
esac

if [ "$mode" = "dark" ]; then
    gtk_theme="Orchis-Dark-Compact"
    kvantum_theme="OrchisDark"
    prefer_dark=1
    color_scheme="prefer-dark"
else
    gtk_theme="Orchis-Light-Compact"
    kvantum_theme="Orchis"
    prefer_dark=0
    color_scheme="prefer-light"
fi

# --- Kvantum ---
mkdir -p ~/.config/Kvantum
cat > ~/.config/Kvantum/kvantum.kvconfig << KV
[General]
theme=$kvantum_theme
KV

# --- GTK 3 ---
mkdir -p ~/.config/gtk-3.0
if [ -f ~/.config/gtk-3.0/settings.ini ]; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" ~/.config/gtk-3.0/settings.ini
    sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$prefer_dark/" ~/.config/gtk-3.0/settings.ini
fi

# --- GTK 4 ---
mkdir -p ~/.config/gtk-4.0
if [ -f ~/.config/gtk-4.0/settings.ini ]; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" ~/.config/gtk-4.0/settings.ini
    sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$prefer_dark/" ~/.config/gtk-4.0/settings.ini
fi

# --- gsettings (GNOME apps / libadwaita) ---
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "$color_scheme" 2>/dev/null || true
fi
