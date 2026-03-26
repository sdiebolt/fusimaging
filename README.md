# fUSI Community Resources

This repository contains the documentation website for the functional ultrasound imaging
(fUSI) community resources, built with [Zensical](https://github.com/zensical/zensical).

## Quick Start

### Prerequisites

- Python 3.13+
- [uv](https://github.com/astral-sh/uv) package manager

### Development

1. Start the development server:
   ```bash
   uv run zensical serve
   ```

2. Open your browser to [http://127.0.0.1:8000](http://127.0.0.1:8000)

### Building the Site

To build the static site:

```bash
uv run zensical build
```

The built site will be in the `site/` directory.

## Contributing

This is a community-based resource. To contribute:

1. Make your changes in the `docs/` directory.
2. Test locally with `uv run zensical serve`.
3. Submit your changes via a pull request.
