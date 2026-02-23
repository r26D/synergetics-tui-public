# Synergetics Dictionary TUI - Changelog

## Version 0.2.0 (Current) - INSTANT INPUT! ⚡

### Major Improvement: Character-by-Character Input
- **ALL commands are now INSTANT!** No need to press Enter!
  - Arrow keys work instantly (↑/↓/←/→)
  - Letter commands work instantly (j/k/n/p/q/e/b/s)
  - Search typing is instant
  - Edit mode typing is instant
  - Backspace works in search and edit modes

### Technical Changes
- Switched from line-based input (`IO.gets/1`) to character-by-character input (`:io.get_chars/1`)
- Enabled raw terminal mode with `stty` using `/dev/tty` for proper terminal access
- Proper escape sequence handling for arrow keys
- Terminal state restored on exit
- Fixed: Use `System.shell` with `/dev/tty` instead of `System.cmd` for stty

### User Experience
- Much more responsive navigation
- No more visible escape sequences (`^[[A`)
- Feels like a professional TUI application
- Instant feedback for all actions

## Version 0.1.1

### Fixed
- **Arrow key support**: Arrow keys (↑/↓/←/→) now work correctly
  - Up arrow (↑) moves selection up
  - Down arrow (↓) moves selection down
  - Right arrow (→) acts like Enter (view/select)
  - Left arrow (←) acts like Back
  - Previously, arrow keys would display as `^[[A` and not work

### Technical Details
- Added binary pattern matching for ANSI escape sequences
- Arrow keys send escape sequences: ESC [ letter (bytes: 27, 91, 65-68)
- Parser now recognizes these sequences and maps them to actions

### Improved
- **Clearer input prompts**: Added yellow `Command>` prompt
- **Better instructions**: All footers now show "(Type command and press Enter)"
- **Updated documentation**: All docs now mention arrow key support

### Documentation Updates
- Updated `README.md` with arrow key shortcuts
- Updated `QUICKSTART_TUI.md` with arrow key examples
- Updated `INPUT_GUIDE.md` with arrow key usage
- Updated `README_FIRST.md` to recommend arrow keys
- Added this `CHANGELOG.md`

## Version 0.1.0 (Initial Release)

### Features
- Browse 21,000+ dictionary cards with pagination
- View full card details (content, cross_references, citations)
- Search cards by title or content
- Edit card fields (title, content_text, definition_text)
- Vim-style navigation (j/k)
- Color-coded terminal output

### Known Limitations
- Line-based input (must press Enter after each command)
- No real-time character input
- Arrow keys not working (fixed in 0.1.1)

### Technical Stack
- Elixir 1.18+
- Exqlite 0.27+ for SQLite access
- IO.ANSI for terminal formatting
- Mix task for running (not escript due to NIF issues)

### Documentation
- `README.md` - Installation and usage
- `USAGE.md` - Comprehensive usage guide
- `TROUBLESHOOTING.md` - Common issues and solutions
- `INPUT_GUIDE.md` - Detailed input guide
- `README_FIRST.md` - Quick start guide
- `TUI_PROJECT_SUMMARY.md` - Technical overview (in project root)
- `QUICKSTART_TUI.md` - Quick start (in project root)

## Future Enhancements

### Planned
- [ ] Real-time character input (requires Ratatouille or similar)
- [ ] Scrollable content view for long cards
- [ ] Full-screen text editor for editing
- [ ] Filter by card type, letter group, volume
- [ ] Jump to linked cards from detail view
- [ ] Undo/redo for edits

### Under Consideration
- [ ] Mouse support
- [ ] Syntax highlighting for LaTeX
- [ ] Export selected cards
- [ ] Batch operations
- [ ] Customizable key bindings
- [ ] Color themes
- [ ] Card history/recently viewed
- [ ] Bookmarks/favorites

## Bug Fixes

### Version 0.1.1
- Fixed arrow keys displaying as escape sequences instead of working

### Version 0.1.0
- Fixed NIF loading error by using Mix task instead of escript
- Fixed database path detection for different working directories
- Fixed Exqlite API usage (bind/2 instead of bind/3)

## Breaking Changes

None yet. This is the initial release.

## Migration Guide

### From 0.1.0 to 0.1.1

No migration needed. Just recompile:

```bash
cd synergetics_tui
mix compile
```

Arrow keys will now work automatically.

## Contributors

- Initial development: Brett Elmendorf (belmendo)
- AI assistance: Augment Agent

## License

Same as the Synergetics Dictionary project.

