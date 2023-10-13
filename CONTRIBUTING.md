# Contributing

- [Contributing shaders](#contributing-shaders)
- [Contributing Rust](#contributing-rust)

______________________________________________________________________

## How to Contribute

Here's how you can get started:

1. Fork the repository on GitHub.
1. Clone your fork locally:

```shell
git clone https://github.com/alphastrata/shadplay.git
cd shadplay
```

Create a new branch for your contribution:

```shell
git checkout -b feature/contribution-name
```

Make your changes and commit them:

```shell
git add .
git commit -m "Add your commit message here"
```

Push your changes to your fork on GitHub:

```shell

git push origin feature/contribution-name

Open a pull request (PR) on the main repository and describe your changes.

```

______________________________________________________________________

# Contributing Shaders

**Note:** If you create a ShaderToy port, make sure to add it to the gallery using the screenshotting functionality. You can take a screenshot of your shader using `SPACEBAR`. This will also version the shader in the `assets/shaders` directory for you.

If you'd like to add your ShaderToy port to the gallery, please follow these steps:

- use `wgsl-analyzer`, especially to format your `wgsl`
- Press the <kbd>SPACEBAR</kbd> when your shader is 'complete' (versioning it with a screenshot and the `wgsl` that made it.)
- The savepath will print to your terminal (the one you ran shadplay from)
- The shader will also be versioned, alongside that screenshot
- Rename and move the screenshot to `assets/screenshots/YOURSHOT.png`
- Rename and move the versioned shader to `assets/shaders/YOURSHADER.wgsl`
- Screenshots should **share the name** of the `wgsl` that creates them

______________________________________________________________________

# Contributing Rust

- use `rustfmt`
- use `clippy`, with `+nightly`
- Follow the documentation conventions on `Systems`, `Resources`, `Components` etc.
- put stuff in logical places.
- use iterators
- use `run_if()`s [see bevy docs](https://docs.rs/bevy/latest/bevy/prelude/trait.IntoSystemConfigs.html#method.run_if)

Please note that contributions should follow the [Rust Code of Conduct](https://www.rust-lang.org/policies/code-of-conduct).
