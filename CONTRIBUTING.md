# Contributing to Synergetics Dictionary TUI

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/synergetics-tui-public.git`
3. Run the setup script: `./setup.sh`
4. Create a branch for your changes: `git checkout -b feature/your-feature-name`

## Development Workflow

### Elixir TUI

```bash
cd synergetics_tui
mix deps.get      # Install dependencies
mix compile       # Compile
mix test          # Run tests
mix format        # Format code
mix tui           # Run the TUI
```

### Ink TUI

```bash
cd synergetics-tui-ink
npm install       # Install dependencies
npm start         # Run the TUI
npm run dev       # Run with watch mode
```

## Code Style

### Elixir
- Follow the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)
- Run `mix format` before committing
- Add documentation for public functions
- Write tests for new features

### TypeScript/JavaScript
- Use ES Modules
- Follow React best practices
- Use TypeScript types where appropriate
- Keep components small and focused

## Testing

### Elixir TUI
```bash
cd synergetics_tui
mix test
```

### Ink TUI
Currently no automated tests. Manual testing required:
1. Run the TUI: `npm start`
2. Test all keyboard shortcuts
3. Verify pagination works
4. Test search functionality

## Submitting Changes

1. Make sure your code follows the style guidelines
2. Test your changes thoroughly
3. Update documentation if needed
4. Commit with a clear message describing your changes
5. Push to your fork
6. Create a Pull Request

## Pull Request Guidelines

- **Title**: Clear and descriptive
- **Description**: Explain what changes you made and why
- **Testing**: Describe how you tested your changes
- **Screenshots**: Include screenshots for UI changes

## Reporting Issues

When reporting issues, please include:
- Operating system and version
- Elixir/Node.js version
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Error messages or screenshots

## Feature Requests

We welcome feature requests! Please:
- Check if the feature has already been requested
- Clearly describe the feature and its use case
- Explain why it would be valuable

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow

## Questions?

Feel free to open an issue for questions or discussions.

Thank you for contributing! 🎉

