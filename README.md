# eIUM File Highlighter

A Visual Studio Code extension providing syntax highlighting for eIUM configuration files (.cfg and .config files).

## Features

This extension offers the following syntax highlighting features for eIUM configuration files:

- Node lines (e.g., `[/deployment/SIU_DEG01/DEG_DeviceInterface_01]`) displayed with distinct heading styles
- `ClassName` property lines with full-line highlighting
- Directives (e.g., `@Include` and `@Exclude`) highlighted
- Reference lines (starting with `#->`) specially marked
- Comments (lines starting with `#` but not `#->`) specially marked

These highlighting features make eIUM configuration files more readable, helping users quickly identify different types of configuration elements.

## Usage

After installation, VS Code will automatically recognize files with `.cfg` and `.config` extensions and apply the highlighting rules. No additional configuration is needed.

## Installation

There are several ways to install:

1. Via VS Code Marketplace
   - Open VS Code
   - Click on the Extensions icon in the Activity Bar
   - Search for "eIUM File Highlighter"
   - Click "Install"

2. Via VSIX File
   - Download the latest VSIX file
   - In VS Code, select "Extensions" > "Install from VSIX..."
   - Choose the downloaded VSIX file

3. From Source
   - Clone the repository
   - Run `npm install -g vsce`
   - Run `vsce package` to create a VSIX file
   - Install using method 2 with the generated VSIX file

## Release Notes

### 1.0.0
- Initial release
- Support for highlighting various elements including node lines, ClassName, directives, reference lines
- Special highlighting for true/false boolean values, IP addresses, and numbers

## Contributing

Issue reports and feature suggestions are welcome. If you would like to contribute code, please create an issue first to discuss your ideas.

## License

[MIT](LICENSE)
