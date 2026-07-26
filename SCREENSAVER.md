# shadplay screensaver

Run shadplay as a fullscreen screensaver that cycles through `.wgsl` shaders.

## Usage

```
shadplay -S <DIR> [SHADER]
```

### Options

| Arg | Description |
|-----|-------------|
| `-S DIR`, `--screensaver DIR` | **Required.** Directory of `.wgsl` files to cycle through |
| `SHADER` | Optional positional. Start on a specific shader file instead of the first in the dir |

### Behaviour

- Opens a borderless fullscreen window on the current monitor
- Hides the mouse cursor
- Cycles shaders every 15 seconds
- Exits on any key press, mouse click, or mouse movement
- Falls back to `assets/shaders/myshader[_2d].wgsl` — shaders are auto-detected as 2D or 3D

### Example

```sh
# cycle through all shaders in ~/my-shaders
shadplay -S ~/my-shaders

# start on a specific shader
shadplay -S ~/my-shaders ~/my-shaders/rainbow.wgsl
```
