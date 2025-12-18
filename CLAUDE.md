# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

macOS Quick Action for converting SVG to high-resolution PNG via Finder right-click menu.

## Commands

```bash
# Install Quick Action
./install.sh

# Uninstall
./uninstall.sh

# Direct CLI usage
./svg2png.sh input.svg [input2.svg ...]
```

## Dependencies

- **librsvg**: `brew install librsvg`
- **rsvg-convert**: `/opt/homebrew/bin/rsvg-convert`

## Key Files

- `install.sh` - Creates Automator workflow at `~/Library/Services/SVG2PNG.workflow`
- `svg2png.sh` - Core conversion script (embedded in workflow during install)

## Automator Workflow Structure

```
SVG2PNG.workflow/Contents/
├── Info.plist       # Service metadata
└── document.wflow   # Workflow definition with embedded script
```

Critical workflow settings:
- `inputTypeIdentifier`: `com.apple.Automator.fileSystemObject`
- `serviceInputTypeIdentifier`: `com.apple.Automator.fileSystemObject`
- `AMAccepts.Types`: `com.apple.cocoa.path`
- `inputMethod`: `1` (as arguments)

## Conversion Parameters

- Resolution: 3200x3600 (4x for Retina)
- Format: PNG with transparent background
- Compression: sips formatOptions 90
