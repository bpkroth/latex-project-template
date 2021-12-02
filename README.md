# latex-project-template

This is a quick attempt to make a basic latex project template repot that can be used for shared editing in
[Codespaces](https://code.visualstudio.com/docs/remote/codespaces).

You can potentially think of this as a home rolled Overleaf.

## Overview

- `.devcontainer/devcontainer.json` is the Codespaces configuration file for what container to use and (VSCode) editor plugins.
- `.devcontainer/Dockerfile` is used to build the container.  Additional packages to install can be added there if necessary.

Those two files together reference each other in various settings.

To test building and running the container locally:

```sh
make -C .devcontainer
docker run -it --rm latex-project-container
```

Some other basic files are:

- `.vscode/settings.json` has some basic editor settings.
- `.editorconfig` has some generic editor configuration settings.
