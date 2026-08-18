#!/bin/bash
set -e

# Change to iOS directory and run pod install
cd ios
rbenv exec pod install
cd ..

# Fix xcfilelist paths in project.pbxproj
project_path="ios/Runner.xcodeproj/project.pbxproj"
project_content=$(<"$project_path")

# Replace xcfilelist references with explicit input/output paths
project_content=$(echo "$project_content" | perl -0777 -pe 's/inputFileListPaths = \(\s+"\$\{PODS_ROOT\}\/Target Support Files\/Pods-Runner\/Pods-Runner-frameworks-\$\{CONFIGURATION\}-input-files\.xcfilelist",\s+\);/inputFileListPaths = (\n\t\t\t);\n\t\t\tinputPaths = (\n\t\t\t\t"\${PODS_ROOT}\/Target Support Files\/Pods-Runner\/Pods-Runner-frameworks.sh",\n\t\t\t\t"\${BUILT_PRODUCTS_DIR}\/app_settings\/app_settings.framework",\n\t\t\t);/g')

project_content=$(echo "$project_content" | perl -0777 -pe 's/outputFileListPaths = \(\s+"\$\{PODS_ROOT\}\/Target Support Files\/Pods-Runner\/Pods-Runner-frameworks-\$\{CONFIGURATION\}-output-files\.xcfilelist",\s+\);/outputFileListPaths = (\n\t\t\t);\n\t\t\toutputPaths = (\n\t\t\t\t"\${TARGET_BUILD_DIR}\/\${FRAMEWORKS_FOLDER_PATH}\/app_settings.framework",\n\t\t\t);/g')

echo "$project_content" > "$project_path"
echo "Fixed xcfilelist paths in project.pbxproj"

# Now run flutter with --no-pub to avoid triggering another pod install
flutter run --release --flavor production --device-id=00008120-001C315C11A2201E --no-pub
