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
    #[cfg(debug_assertions)]
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
