pub mod drag_n_drop;
pub mod screenshot;
pub mod shader_utils;
pub mod texture_tooling;
pub mod ui;
pub mod utils;

pub mod system_clipboard {
    use bevy::prelude::error;
    use copypasta::{ClipboardContext, ClipboardProvider};

    /// Resource: a [`copypasta::ClipboardContext`] wrapper
    #[derive(bevy::prelude::Resource)]
    pub struct SystemClipboard {
        most_recent_copypasta: ClipboardContext,
    }

    impl Default for SystemClipboard {
        fn default() -> Self {
            SystemClipboard {
                most_recent_copypasta: ClipboardContext::new().unwrap(),
            }
        }
    }

    impl SystemClipboard {
        /// Sets the contents of the system clipboard to `msg`.
        pub(crate) fn set_from(&mut self, msg: String) {
            if let Err(e) = self.most_recent_copypasta.set_contents(msg) {
                error!("{e}");
            }
        }

        /// Reads the contents of the system clipboard (it may have stuff in there that's not from shadplay, so private.)
        //TODO: we probably never actually need this.. so maybe remove?
        // it would maybe be nice though to be able to take an image for the texture system from the clipboard tho~....
        pub(super) fn read_current(&mut self) -> Option<String> {
            match self.most_recent_copypasta.get_contents() {
                Ok(v) => Some(v.into()),
                Err(e) => {
                    error!("{e}");
                    None
                }
            }
        }
    }
}
