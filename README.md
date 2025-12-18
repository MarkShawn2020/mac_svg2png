![Cover](docs/images/cover.png)

# SVG2PNG

macOS Quick Action for converting SVG to high-resolution PNG via Finder right-click menu.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/MarkShawn2020/mac_svg2png/main/install.sh | bash
```

## Usage

1. Right-click any SVG file in Finder
2. Select **Quick Actions → SVG2PNG**
3. PNG saved in the same directory

Supports batch conversion - select multiple SVG files at once.

## Output Specs

| Parameter | Value |
|-----------|-------|
| Resolution | 3200×3600 (4× Retina) |
| Background | Transparent |
| Engine | rsvg-convert (librsvg) |

## Uninstall

```bash
rm -rf ~/Library/Services/SVG2PNG.workflow
```

## License

MIT
