use bevy::prelude::*;
use bevy_egui::egui::epaint::Shadow;
use bevy_egui::egui::{Align2, Color32, RichText, Rounding, Vec2};
use bevy_egui::{egui, EguiContexts, EguiPlugin};

use crate::system_clipboard::SystemClipboard;

#[derive(Resource, Default, Debug, PartialEq)]
pub struct ColourPickerTool {
    colour: [f32; 3],
    open: bool,
}

#[derive(Resource, Default, Debug, PartialEq)]
struct Toggle {
    open: bool,
}
impl Toggle {
    fn flip(&mut self) {
        self.open = !self.open;
    }
}
/// Plugin:
/// Systems/Resources to allow a user to hit a hotkey --select a colour and have it copied to the system clipboard
pub struct ColourPickerPlugin;

impl Plugin for ColourPickerPlugin {
    fn build(&self, app: &mut App) {
        app.add_plugins(EguiPlugin);

        app.insert_resource(ColourPickerTool::default())
            .insert_resource(Toggle::default())
            .insert_resource(SystemClipboard::default());

        app.add_systems(
            Update,
            (
                toggle_ui,
                ColourPickerTool::draw_ui
                    .run_if(resource_exists::<ColourPickerTool>())
                    .run_if(resource_equals(Toggle { open: true })),
            ),
        );
    }
}

impl ColourPickerTool {
    fn draw_ui(
        mut picker: ResMut<ColourPickerTool>,
        mut ctx: EguiContexts,
        mut sys_clip: ResMut<SystemClipboard>,
    ) {
        egui::Window::new("Colour Picker")
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
                ui.label(RichText::new("Colour Picker").color(Color32::WHITE));
                ui.color_edit_button_rgb(&mut picker.colour);

                #[cfg(debug_assertions)]
                debug!("{:?}", picker.colour);

                let (r, g, b) = (picker.colour[0], picker.colour[1], picker.colour[2]);
                (*sys_clip).set_from(format!("vec3f({}, {}, {})", r, g, b));
            });
    }
}

/// System: Toggles the UI on/off
fn toggle_ui(input: Res<Input<KeyCode>>, mut picker: ResMut<Toggle>) {
    if input.just_pressed(KeyCode::Tab) {
        (*picker).flip()
    }
}
