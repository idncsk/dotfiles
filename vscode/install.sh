#!/bin/bash


# Simple dotfile install script example for VSCode


# Check if the extension-list.txt file is available
if [ ! -f .vscode/extension-list.txt ]; then
  echo "Error: extension-list.txt not found. Please create an extension-list.txt file containing a list of extensions to install." >&2
  exit 1
fi

# Check if the code binary is available
if ! command -v code &> /dev/null; then
  echo "Error: VS Code not found on the system. Please install VS Code and make sure the 'code' binary is in your PATH." >&2
  exit 1
fi

# Read the list of extensions from the extension-list.txt file
extensions=$(cat .vscode/extension-list.txt)

# Store the list of currently installed extensions in a temporary file
extension_list_file=/tmp/vscode-extension-list.txt
code --list-extensions > $extension_list_file

# Install each extension using the code command-line tool, if it's not already installed
for extension in $extensions; do
  echo "Installing $extension..."
  if ! grep $extension $extension_list_file >/dev/null; then
    code --install-extension $extension
  else
    echo "$extension is already installed, skipping."
  fi
done

echo "All extensions have been installed."

# Remove the temporary file
rm $extension_list_file
