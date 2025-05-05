#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Display help information
show_help() {
    echo "Usage: $0 -i|--id PROJECT_ID -n|--name PROJECT_NAME [-h|--help]"
    echo
    echo "Options:"
    echo "  -i, --id ID        Overleaf project ID (required)"
    echo "  -n, --name NAME    Overleaf project name (required)"
    echo "  -h, --help         Show this help message"
    echo
    echo "Example:"
    echo "  $0 -i 1234abcd5678 -n my-latex-project"
}

# Parse command-line arguments
parse_args() {
    local options
    options=$(getopt -o hi:n: --long help,id:,name: -n "$0" -- "$@")

    if [ $? -ne 0 ]; then
        echo "Failed to parse arguments. See help below."
        show_help
        exit 1
    fi

    eval set -- "$options"

    while true; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -i|--id)
                PROJECT_ID="$2"
                shift 2
                ;;
            -n|--name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Validate required parameters
    if [ -z "$PROJECT_ID" ] || [ -z "$PROJECT_NAME" ]; then
        echo "Error: Project ID and name are required." >&2
        show_help
        exit 1
    fi
}

# Check git installation
check_git() {
    if ! command -v git &> /dev/null; then
        echo "Error: git is not installed. Please install git and try again." >&2
        exit 1
    fi
}

# Clone the Overleaf repository
clone_repo() {
    # Get the parent directory of the current script's repository
    CURRENT_REPO_DIR=$(git rev-parse --show-toplevel)
    PARENT_DIR=$(dirname "$CURRENT_REPO_DIR")

    # Construct the Overleaf git URL and destination directory
    GIT_URL="https://git@git.overleaf.com/${PROJECT_ID}"
    DEST_DIR="${PARENT_DIR}/${PROJECT_NAME}"

    echo "Cloning Overleaf repository..."
    echo "From: $GIT_URL"
    echo "To: $DEST_DIR"

    if [ -d "$DEST_DIR" ]; then
        echo "Warning: Directory $DEST_DIR already exists."
        read -p "Do you want to proceed and possibly overwrite files? (y/n): " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Operation cancelled."
            exit 1
        fi
    else
        mkdir -p "$DEST_DIR"
    fi

    git clone "$GIT_URL" "$DEST_DIR"

    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone repository. Please check your project ID and try again." >&2
        echo "Note: you may need to setup a [Git Authentication Token](https://www.overleaf.com/learn/how-to/Git_Integration) on the [Overleaf Account Settings](https://www.overleaf.com/user/settings) page to do this." >&2
        exit 1
    fi

    echo "Repository cloned successfully."
}

# Copy configuration files from current repo to cloned repo
copy_config_files() {
    CURRENT_REPO_DIR=$(git rev-parse --show-toplevel)
    PARENT_DIR=$(dirname "$CURRENT_REPO_DIR")
    DEST_DIR="${PARENT_DIR}/${PROJECT_NAME}"

    echo "Copying configuration files..."

    # Create directories if they don't exist
    mkdir -p "$DEST_DIR/.vscode"
    mkdir -p "$DEST_DIR/.devcontainer"

    # Copy .vscode directory
    if [ -d "$CURRENT_REPO_DIR/.vscode" ]; then
        cp -r "$CURRENT_REPO_DIR/.vscode/"* "$DEST_DIR/.vscode/"
        echo "Copied .vscode directory"
    else
        echo "Warning: .vscode directory not found in current repository"
    fi

    # Copy .devcontainer directory
    if [ -d "$CURRENT_REPO_DIR/.devcontainer" ]; then
        cp -r "$CURRENT_REPO_DIR/.devcontainer/"* "$DEST_DIR/.devcontainer/"
        echo "Copied .devcontainer directory"
    else
        echo "Warning: .devcontainer directory not found in current repository" >&2
    fi

    # Copy .editorconfig file
    if [ -f "$CURRENT_REPO_DIR/.editorconfig" ]; then
        cp "$CURRENT_REPO_DIR/.editorconfig" "$DEST_DIR/"
        echo "Copied .editorconfig file"
    else
        echo "Warning: .editorconfig file not found in current repository" >&2
    fi

    # Copy Makefile
    if [ -f "$CURRENT_REPO_DIR/Makefile" ]; then
        cp "$CURRENT_REPO_DIR/Makefile" "$DEST_DIR/"
        echo "Copied Makefile"
    else
        echo "Warning: Makefile not found in current repository" >&2
    fi

    echo "Configuration files copied successfully."
}

# Commit and push changes to the Overleaf repository
commit_and_push() {
    DEST_DIR="${PARENT_DIR}/${PROJECT_NAME}"

    echo "Committing and pushing changes..."

    cd "$DEST_DIR"

    # Add all files to git
    git add .vscode .devcontainer .editorconfig Makefile

    # Create commit
    git commit -m "Add VS Code DevContainer configuration"

    # Push changes
    git push origin # master

    if [ $? -ne 0 ]; then
        echo "Error: Failed to push changes. You may need to manually push the changes." >&2
        echo "Navigate to $DEST_DIR and run: 'git push origin'" >&2
        #exit 1
    else
        echo "Changes committed and pushed successfully."
    fi
}

# Open repository in VS Code
open_in_vscode() {
    DEST_DIR="${PARENT_DIR}/${PROJECT_NAME}"

    echo "Opening repository in VS Code..."

    # Check for code or code-insiders
    if command -v code-insiders &> /dev/null; then
        code-insiders "$DEST_DIR"
    elif command -v code &> /dev/null; then
        code "$DEST_DIR"
    else
        echo "Neither 'code' nor 'code-insiders' commands found." >&2
        echo "Please open the repository manually at: $DEST_DIR" >&2
    fi
}

# Main function
main() {
    # Parse command-line arguments
    parse_args "$@"

    # Check git installation
    check_git

    # Clone the repository
    clone_repo

    # Copy configuration files
    copy_config_files

    # Commit and push changes
    commit_and_push

    echo "Setup complete! Repository is ready to use with VS Code DevContainer."

    # Open in VS Code
    open_in_vscode
}

# Execute the script
main "$@"
