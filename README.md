# latex-project-template

This is a quick attempt to make a basic latex project template repo that can be used for shared editing in
[Codespaces](https://code.visualstudio.com/docs/remote/codespaces).

You can potentially think of this as a home rolled [Overleaf](https://overleaf.com).

## Updates

- 2025-03-25
  - [GitDoc](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.gitdoc) extension added.

    With this changes can be automatically synced to a git repository for others to see.

    > To do this with an Overleaf project, see [Overleaf Integration](#overleaf-integration) below.

    Additionally, with [Github Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) integration, we can also have AI agent assisted edits! 🤖😄

    > Beware that this is not permissible in all conferences, so be sure to check the rules of your conference before using this.

## Usage

- fork the repo (or rather "use it as a template") (upper right corner)
- launch a Codespace instance (either via VSCode or Github)
- edit latex files in the root directory
- use "Live Share" for collaborative editing
  - locally install vim extension if you like, without impacting others :)

### Overleaf Integration

To integrate this with an [Overleaf](https://www.overleaf.com) project, you first need to `git` access to the project.

[Cloning your project as a local repository](https://www.overleaf.com/learn/how-to/Git_integration#Cloning_your_project_as_a_local_repository) describes how to do this, but in brief you need to:

1. Clone the project

    ```sh
    git clone https://git@git.overleaf.com/<project_id> <local_dir>
    ```

    Where

    - `<project_id>` is the project id from the Overleaf project URL, and
    - `<local_dir>` is the local directory to clone into (e.g., the project's name).

    For instance:

    ```sh
    git clone https://git@git.overleaf.com/12345678 MyPaperTitle
    ```

    > Note: you will need to setup a [Git Authentication Token](https://www.overleaf.com/learn/how-to/Git_Integration) on the [Overleaf Account Settings](https://www.overleaf.com/user/settings) page to do this.

2. Next, we can copy the relevant files from this directory into that project in order to make it locally editable:

    ```sh
    # Copy the relevant files from this repo to the overleaf project repo
    cp -rup latex-project-template/.devcontainer MyPaperTitle/
    cp -rup latex-project-template/.vscode MyPaperTitle/
    cp -rup latex-project-template/.editorconfig MyPaperTitle/
    cp -rup latex-project-template/Makefile MyPaperTitle/
    ```

    ```sh
    # Add the new configs to the git repo
    git add MyPaperTitle/.devcontainer
    git add MyPaperTitle/.vscode
    git add MyPaperTitle/.editorconfig
    git add MyPaperTitle/Makefile
    git commit -m "Adding vscode devcontainer files"
    git push
    ```

3. Finally, you can open the project locally in VSCode, and it should automatically prompt you to open the project in a devcontainer codespace.

    ```sh
    code MyPaperTitle
    ```

## Limitations

- The Latex-Workshop extension is not available in the collaborator views when live sharing in the browser, so automatic pdf generation is not available there.
  - Workaround: run `make` from within the root folder in the container's terminal in the codespace.
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
