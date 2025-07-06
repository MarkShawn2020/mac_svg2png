# SVG2PNG macOS Quick Action

在 macOS Finder 中右键点击 SVG 文件即可转换为高清 PNG 图片的快捷操作。

## 功能特点

- 🎯 **右键快捷操作**: 在 Finder 中右键点击 SVG 文件即可转换
- 🔍 **高清输出**: 默认 300 DPI 高分辨率输出
- 🌈 **保持透明度**: 完整保留 SVG 的透明背景
- 📦 **批量转换**: 支持同时选择多个 SVG 文件批量转换
- 🔔 **实时通知**: 转换完成后显示系统通知

## 安装步骤

### 1. 检查并安装依赖

```bash
# 检查 Homebrew 是否安装
which brew

# 如果没有安装 Homebrew，运行：
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 librsvg
brew install librsvg

# 验证安装
which rsvg-convert
```

### 2. 通过 Automator 创建 Quick Action

1. **打开 Automator**
   - 按 `Cmd+Space` 搜索 "Automator"
   - 或在 Applications > Utilities 中找到 Automator

2. **创建新的 Quick Action**
   - 选择 `File > New` 或按 `Cmd+N`
   - 选择 "Quick Action" 模板
   - 点击 "Choose"

3. **配置工作流设置**
   - 在顶部设置栏中：
     - `Workflow receives current`: 选择 `files or folders`
     - `in`: 选择 `Finder`

4. **添加 Shell Script Action**
   - 在左侧搜索 "Run Shell Script"
   - 双击添加到工作流
   - 设置 `Pass input`: `as arguments`

5. **复制脚本内容**
   - 将 `svg2png.sh` 文件的完整内容复制到脚本框中
   - 或者复制下面的脚本：

```bash
#!/bin/bash

# SVG to PNG 高质量转换脚本
# 专为 Automator Quick Action 优化
# 支持批量转换多个 SVG 文件

# 检查是否安装了 rsvg-convert
if ! command -v rsvg-convert &> /dev/null; then
    osascript -e 'display notification "请先安装 librsvg: brew install librsvg" with title "SVG2PNG" sound name "Basso"'
    exit 1
fi

# 检查是否有输入文件
if [ $# -eq 0 ]; then
    osascript -e 'display notification "请选择 SVG 文件" with title "SVG2PNG" sound name "Basso"'
    exit 1
fi

converted_count=0
failed_count=0
conversion_results=()

# 处理每个输入文件
for input_file in "$@"; do
    # 检查文件是否存在
    if [ ! -f "$input_file" ]; then
        echo "文件不存在: $input_file" >&2
        ((failed_count++))
        continue
    fi
    
    # 检查文件扩展名（不区分大小写）
    if [[ ! "$input_file" =~ \.(svg|SVG)$ ]]; then
        echo "跳过非 SVG 文件: $input_file" >&2
        ((failed_count++))
        continue
    fi
    
    # 生成输出文件名
    output_file="${input_file%.*}.png"
    
    # 使用 rsvg-convert 转换，设置高分辨率和优化参数
    if rsvg-convert \
        --dpi-x 300 \
        --dpi-y 300 \
        --format png \
        --keep-aspect-ratio \
        --output "$output_file" \
        "$input_file" 2>/dev/null; then
        
        # 获取文件名用于显示
        filename=$(basename "$input_file")
        echo "✅ 转换成功: $filename"
        conversion_results+=("✅ $(basename "$output_file")")
        ((converted_count++))
    else
        filename=$(basename "$input_file")
        echo "❌ 转换失败: $filename" >&2
        conversion_results+=("❌ $filename")
        ((failed_count++))
    fi
done

# 显示详细结果通知
if [ $converted_count -gt 0 ]; then
    if [ $failed_count -eq 0 ]; then
        osascript -e "display notification \"成功转换 $converted_count 个 SVG 文件为高清 PNG\" with title \"SVG2PNG\" sound name \"Glass\""
    else
        osascript -e "display notification \"成功转换 $converted_count 个，失败 $failed_count 个\" with title \"SVG2PNG\" sound name \"Glass\""
    fi
    
    # 在终端中显示结果摘要
    echo ""
    echo "=== 转换结果摘要 ==="
    printf '%s\n' "${conversion_results[@]}"
    echo "总计: $converted_count 成功, $failed_count 失败"
else
    osascript -e 'display notification "转换失败，请检查 SVG 文件格式" with title "SVG2PNG" sound name "Basso"'
fi
```

6. **保存 Quick Action**
   - 按 `Cmd+S` 保存
   - 命名为 "SVG2PNG"
   - 点击 "Save"

## 使用方法

1. 在 Finder 中选择一个或多个 SVG 文件
2. 右键点击，选择 "SVG2PNG"
3. 转换完成后，PNG 文件将保存在相同目录
4. 系统会显示转换结果通知

## 错误调试指南

### 查看错误日志的方法

当 Quick Action 报错时，按以下步骤查看具体错误：

#### 方法 1: Console 应用（推荐）
1. 打开 **Console** 应用（Applications > Utilities）
2. 在左侧选择你的 Mac 设备
3. 在搜索框输入 "Automator" 或 "SVG2PNG"
4. 重新执行 Quick Action 触发错误
5. 查看实时日志中的错误信息

#### 方法 2: Automator 内置日志
1. 在 Automator 中打开 SVG2PNG workflow
2. 点击 `View > Show Log` 或按 `Cmd+L`
3. 点击播放按钮直接运行 workflow
4. 查看底部日志窗口的错误信息

#### 方法 3: 终端命令
```bash
# 查看实时日志
log stream --predicate 'process == "Automator"' --level debug

# 查看最近的相关日志
log show --last 10m --predicate 'process == "Automator"' --debug
```

### 常见问题解决

#### ❌ "rsvg-convert: command not found"
**解决方案**: 使用完整路径
```bash
# 在脚本开头添加
RSVG_CONVERT="/opt/homebrew/bin/rsvg-convert"
# 然后将所有 rsvg-convert 替换为 $RSVG_CONVERT
```

#### ❌ "Permission denied"
**解决方案**: 检查文件权限
- 确保可以写入目标目录
- 检查 SVG 文件是否可读

#### ❌ Quick Action 不显示
**解决方案**: 
- 检查 系统偏好设置 > 扩展 > Finder
- 确保 "SVG2PNG" 已启用
- 重启 Finder: `killall Finder`

#### ❌ 没有任何输出
**解决方案**: 
- 确保在 Automator 中选择了 `Pass input: as arguments`
- 检查是否选择了正确的 SVG 文件

### 调试脚本

如果需要调试，可以临时添加日志输出：

```bash
#!/bin/bash
# 添加到脚本开头
echo "脚本开始执行..." >> /tmp/svg2png_debug.log
echo "参数: $@" >> /tmp/svg2png_debug.log
echo "参数数量: $#" >> /tmp/svg2png_debug.log

# 你的原始脚本...

# 执行后查看日志
# cat /tmp/svg2png_debug.log
```

## 卸载

删除 Quick Action：
```bash
rm -rf ~/Library/Services/SVG2PNG.workflow
```

## 许可证

MIT License