set windows-shell := ["pwsh.exe", "-c"]

# Print the help message.
@help:
    echo "Usage: just [RECIPE]\n"
    just --list

# Build documentation.
docs:
    uv run zensical build

# Serve documentation locally for development.
serve-docs:
    uv run zensical serve

# Clean documentation build artifacts.
clean-docs:
    rm -rf .cache/
    rm -rf site/

# Convert Notion export to documentation source files.
convert:
    uv run python convert_notion.py

# Aliases
alias d := docs
alias cd := clean-docs
alias sd := serve-docs
alias c := convert
