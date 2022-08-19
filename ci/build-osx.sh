set -e
mkdir build
cd build

# Configure
cmake .. \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.11 \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DNODEJS_VERSION=${ELECTRON_VERSION} \
-DCMAKE_INSTALL_PREFIX=${DISTRIBUTE_DIRECTORY}/font-manager

cd ..

# Build
cmake --build build --target install --config RelWithDebInfo

#Upload debug files
curl -sL https://sentry.io/get-cli/ | bash
dsymutil $PWD/${BUILD_DIRECTORY}/RelWithDebInfo/node_fontmanager.node
sentry-cli --auth-token ${SENTRY_AUTH_TOKEN} upload-dif --org streamlabs-desktop --project obs-client $PWD/${BUILD_DIRECTORY}/RelWithDebInfo/node_fontmanager.node.dSYM/Contents/Resources/DWARF/node_fontmanager.node 
