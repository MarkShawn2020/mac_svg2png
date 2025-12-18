#!/bin/bash

# SVG2PNG Quick Action 一键安装脚本
# 用法: curl -fsSL https://raw.githubusercontent.com/MarkShawn2020/mac_svg2png/main/install.sh | bash

set -e

WORKFLOW_NAME="SVG2PNG"
WORKFLOW_DIR="$HOME/Library/Services/${WORKFLOW_NAME}.workflow"

echo "=== SVG2PNG Quick Action 安装程序 ==="
echo ""

# 1. 检查 rsvg-convert
echo "检查依赖..."
if ! command -v rsvg-convert &> /dev/null; then
    echo "未找到 rsvg-convert，正在安装 librsvg..."
    if command -v brew &> /dev/null; then
        brew install librsvg
    else
        echo "错误: 请先安装 Homebrew: https://brew.sh"
        exit 1
    fi
fi
echo "✓ rsvg-convert 已就绪: $(which rsvg-convert)"

# 2. 创建 workflow 目录
echo ""
echo "安装 Quick Action..."
rm -rf "$WORKFLOW_DIR"
mkdir -p "$WORKFLOW_DIR/Contents"

# 3. 写入 Info.plist
cat > "$WORKFLOW_DIR/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>SVG2PNG</string>
			</dict>
			<key>NSMessage</key>
			<string>runWorkflowAsService</string>
			<key>NSRequiredContext</key>
			<dict>
				<key>NSApplicationIdentifier</key>
				<string>com.apple.finder</string>
			</dict>
			<key>NSSendFileTypes</key>
			<array>
				<string>public.svg-image</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
PLIST

# 4. 写入 document.wflow（脚本已内嵌并转义）
cat > "$WORKFLOW_DIR/Contents/document.wflow" << 'WFLOW'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key>
	<string>523</string>
	<key>AMApplicationVersion</key>
	<string>2.10</string>
	<key>AMDocumentVersion</key>
	<string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.path</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.3</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMCategory</key>
				<string>AMCategoryUtilities</string>
				<key>AMComment</key>
				<string></string>
				<key>AMDescription</key>
				<dict>
					<key>AMDInput</key>
					<string>The shell script to be executed</string>
					<key>AMDSummary</key>
					<string>Executes a shell script</string>
				</dict>
				<key>AMIconName</key>
				<string>Run Shell Script</string>
				<key>AMName</key>
				<string>Run Shell Script</string>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.path</string>
					</array>
				</dict>
				<key>AMRequiredResources</key>
				<array/>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key>
				<string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key>
					<string>#!/bin/bash

# SVG to PNG 高质量转换脚本

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
RSVG_CONVERT="/opt/homebrew/bin/rsvg-convert"
OSASCRIPT="/usr/bin/osascript"

if [ ! -f "$RSVG_CONVERT" ]; then
    $OSASCRIPT -e 'display notification "rsvg-convert 未找到，请检查 librsvg 安装" with title "SVG2PNG 错误" sound name "Basso"'
    exit 1
fi

if [ $# -eq 0 ]; then
    $OSASCRIPT -e 'display notification "请选择 SVG 文件" with title "SVG2PNG" sound name "Basso"'
    exit 1
fi

converted_count=0
failed_count=0

for input_file in "$@"; do
    if [ ! -f "$input_file" ]; then
        ((failed_count++))
        continue
    fi

    if [[ ! "$input_file" =~ \.[sS][vV][gG]$ ]]; then
        ((failed_count++))
        continue
    fi

    output_file="${input_file%.*}.png"

    if "$RSVG_CONVERT" \
        --width 3200 \
        --height 3600 \
        --format png \
        --keep-aspect-ratio \
        --background-color transparent \
        --output "$output_file" \
        "$input_file" 2&gt;/dev/null; then
        /usr/bin/sips -s formatOptions 90 "$output_file" &amp;&gt; /dev/null || true
        ((converted_count++))
    else
        ((failed_count++))
    fi
done

if [ $converted_count -gt 0 ]; then
    if [ $failed_count -eq 0 ]; then
        $OSASCRIPT -e "display notification \"成功转换 $converted_count 个文件\" with title \"SVG2PNG\" sound name \"Glass\""
    else
        $OSASCRIPT -e "display notification \"成功 $converted_count 个，失败 $failed_count 个\" with title \"SVG2PNG\" sound name \"Glass\""
    fi
else
    $OSASCRIPT -e 'display notification "转换失败，请检查 SVG 文件" with title "SVG2PNG" sound name "Basso"'
fi</string>
					<key>CheckedForUserDefaultShell</key>
					<true/>
					<key>inputMethod</key>
					<integer>1</integer>
					<key>shell</key>
					<string>/bin/bash</string>
					<key>source</key>
					<string></string>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.RunShellScript</string>
				<key>CFBundleVersion</key>
				<string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Class Name</key>
				<string>RunShellScriptAction</string>
				<key>InputUUID</key>
				<string>E14A6F37-5C68-4F8C-8F8C-5E1C8D7D8E9F</string>
				<key>Keywords</key>
				<array>
					<string>Shell</string>
					<string>Script</string>
				</array>
				<key>OutputUUID</key>
				<string>A23B7C48-6D79-4A9D-9A9D-6F2D9E8E9F0A</string>
				<key>UUID</key>
				<string>B34C8D59-7E80-5B0E-0B0E-7A3E0F9F0A1B</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Automator</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>inputMethod</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>source</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
					<key>2</key>
					<dict>
						<key>default value</key>
						<false/>
						<key>name</key>
						<string>CheckedForUserDefaultShell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>2</string>
					</dict>
					<key>3</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>COMMAND_STRING</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>3</string>
					</dict>
					<key>4</key>
					<dict>
						<key>default value</key>
						<string>/bin/sh</string>
						<key>name</key>
						<string>shell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>4</string>
					</dict>
				</dict>
				<key>isViewVisible</key>
				<integer>1</integer>
				<key>location</key>
				<string>529.000000:305.000000</string>
				<key>nibPath</key>
				<string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>connectors</key>
	<dict/>
	<key>inputTypeIdentifier</key>
	<string>com.apple.Automator.fileSystemObject</string>
	<key>outputTypeIdentifier</key>
	<string>com.apple.Automator.nothing</string>
	<key>presentationMode</key>
	<integer>15</integer>
	<key>processesInput</key>
	<integer>0</integer>
	<key>serviceInputTypeIdentifier</key>
	<string>com.apple.Automator.fileSystemObject</string>
	<key>serviceOutputTypeIdentifier</key>
	<string>com.apple.Automator.nothing</string>
	<key>serviceProcessesInput</key>
	<integer>0</integer>
	<key>systemImageName</key>
	<string>NSTouchBarColorPickerFill</string>
	<key>useAutomaticInputType</key>
	<integer>0</integer>
	<key>workflowMetaData</key>
	<dict>
		<key>applicationBundleIDsByPath</key>
		<dict/>
		<key>applicationPaths</key>
		<array/>
		<key>inputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>outputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>presentationMode</key>
		<integer>15</integer>
		<key>processesInput</key>
		<integer>0</integer>
		<key>serviceInputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>serviceOutputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>serviceProcessesInput</key>
		<integer>0</integer>
		<key>systemImageName</key>
		<string>NSTouchBarColorPickerFill</string>
		<key>useAutomaticInputType</key>
		<integer>0</integer>
		<key>workflowTypeIdentifier</key>
		<string>com.apple.Automator.servicesMenu</string>
	</dict>
</dict>
</plist>
WFLOW

# 5. 刷新服务
echo "刷新系统服务..."
/System/Library/CoreServices/pbs -update 2>/dev/null || true
killall Finder 2>/dev/null || true

echo ""
echo "✓ 安装完成！"
echo ""
echo "使用方法："
echo "  1. 在 Finder 中右键点击 SVG 文件"
echo "  2. 选择 Quick Actions > SVG2PNG"
echo "  3. PNG 文件将保存在同目录下"
echo ""
echo "卸载: rm -rf ~/Library/Services/SVG2PNG.workflow"
