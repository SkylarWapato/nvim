mkdir -p ~/dev/microsoft
git clone https://github.com/microsoft/vscode-node-debug2.git ~/dev/microsoft/vscode-node-debug2
cd ~/dev/microsoft/vscode-node-debug2
npm install
NODE_OPTIONS=--no-experimental-fetch npm run build