# latex-project-template

This is a quick attempt to make a basic latex project template repo that can be used for shared editing in
[Codespaces](https://code.visualstudio.com/docs/remote/codespaces).

You can potentially think of this as a home rolled [Overleaf](https://overleaf.com).

## Updates

- 2025-03-25
  - [GitDoc](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.gitdoc) extension added.

    With this changes can be automatically synced to a git repository for others to see.

    > To do this with an Overleaf project, see [Cloning your project as a local repository](https://www.overleaf.com/learn/how-to/Git_integration#Cloning_your_project_as_a_local_repository).

    Additionally, with [Github Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) integration, we can also have AI agent assisted edits! 🤖😄

## Usage

- fork the repo
- launch a Codespace instance (either via VSCode or Github)
- edit latex files in `src/`
- use "Live Share" for collaborative editing
  - locally install vim extension if you like, without impacting others :)

## Limitations

- The Latex-Workshop extension is not available in the collaborator views when live sharing in the browser, so automatic pdf generation is not available there.
  - Workaround: run `make` from within the `src/` folder in the container's terminal in the codespace.
- PDF Preview does not work in the browser.
  - Workaround: right click and download the file to view with a local client as necessary.
  - Or, connect to the remote codespace with a local VSCode client using the Github Codespaces extension.

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
