use bevy::prelude::*;
use bevy_egui::egui::epaint::Shadow;
use bevy_egui::egui::{Align2, Color32, RichText, Rounding, Vec2};
use bevy_egui::{egui, EguiContexts};

/// Plugin:
/// Systems/Resources etc to facilitate the help UI which will show the hotkey bindings.
pub struct HelpUIPlugin;

/// Resource:
/// Modified by the [`toggle_help_ui`] system.
/// Listened to for changes by the [`help_window`] system.
#[derive(Resource, Deref, DerefMut, Default, Debug, PartialEq, PartialOrd)]
pub struct HelpUIToggle {
    open: bool,
}

impl Plugin for HelpUIPlugin {
    fn build(&self, app: &mut App) {
        app.insert_resource(HelpUIToggle { open: false });

        app.add_systems(
            Update,
            (
                toggle_help_ui,
                help_window.run_if(resource_equals(HelpUIToggle { open: true })),
            ),
        );
    }
}

impl HelpUIToggle {
    /// Flips the `open` to the opposite.
    fn flip(&mut self) {
        self.open = !self.open;
    }
}

/// System: listens permanetly for a `?` the `/` key and toggles on/off the help UI.
fn toggle_help_ui(input: Res<Input<KeyCode>>, mut toggle: ResMut<HelpUIToggle>) {
    if input.just_pressed(KeyCode::Slash) {
        (*toggle).flip();
    }
}

/// System: draws the Help UI.
/*
to update run: `rg "input.just_pressed" -B 4`, the names of the functions should be indicative of what the binding does.
*/
fn help_window(mut ctx: EguiContexts) {
    egui::Window::new("Help")
        .collapsible(false)
        .resizable(false)
        .frame(egui::Frame {
            inner_margin: egui::Margin {
                left: 3.0,
                right: 3.0,
                top: 3.0,
                bottom: 3.0,
            },
            outer_margin: egui::Margin {
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
            },
            rounding: Rounding::same(2.0),
            shadow: Shadow::NONE,
            fill: Color32::from_black_alpha(2),
            stroke: egui::Stroke::NONE,
        })
        .anchor(Align2::RIGHT_BOTTOM, Vec2::new(-35.0, -30.0))
        .show(ctx.ctx_mut(), |ui| {
            ui.label(RichText::new("/   -   Toggles help(this) menu").color(Color32::WHITE));
            ui.label(RichText::new("D   -   Toggles window decorations").color(Color32::WHITE));
            ui.label(RichText::new("H   -   Switch to 3D Mode").color(Color32::WHITE));
            ui.label(RichText::new("L   -   Switches window level").color(Color32::WHITE));
            ui.label(
                RichText::new("O   -   Toggles OFF transparency (cannot be re-activated)")
                    .color(Color32::WHITE),
            );
            ui.label(RichText::new("Q   -   Quits shadplay").color(Color32::WHITE));
            ui.label(
                RichText::new("R   -   Toggles the Rotation [3D Mode Only]").color(Color32::WHITE),
            );
            ui.label(
                RichText::new("S   -   Switches to next shape [3D Mode Only]")
                    .color(Color32::WHITE),
            );
            ui.label(RichText::new("T   -   Switch to 2D Mode").color(Color32::WHITE));
            ui.label(RichText::new("Spacebar - Take screenshot").color(Color32::WHITE));
        });
}
