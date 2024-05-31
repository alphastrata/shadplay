{
  description = "Rust dev shell for bevy based on zero to nix rust dev flake)";

  # Flake inputs
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2305.491812.tar.gz";
    rust-overlay.url = "github:oxalica/rust-overlay"; # A helper for Rust + Nix
  };

  # Flake outputs
  outputs = { self, nixpkgs, rust-overlay }:
    let
      # Overlays enable you to customize the Nixpkgs attribute set
      overlays = [
        # Makes a `rust-bin` attribute available in Nixpkgs
        (import rust-overlay)
        # Provides a `rustToolchain` attribute for Nixpkgs that we can use to
        # create a Rust environment
        (self: super: {
          rustToolchain = super.rust-bin.stable.latest.default;
        })
      ];

      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      # Development environment output
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          # The Nix packages provided in the environment
          packages = (with pkgs; [
            # Bevy
            pkg-config
            alsa-lib
            vulkan-tools
            vulkan-headers
            vulkan-loader
            vulkan-validation-layers
            udev
            clang
            lld
             # If on x11
             xorg.libX11
             xorg.libX11
             xorg.libXcursor
             xorg.libXi
             xorg.libXrandr
             # If on wayland
             libxkbcommon
             wayland
            # Rust
            rustToolchain
          ]) ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs; [ libiconv ]);
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
              pkgs.alsaLib
              pkgs.udev
              pkgs.vulkan-loader
            ]}"
          '';
        };
      });
    };
}
