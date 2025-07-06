#!/bin/bash

# SVG to PNG 高质量转换脚本
# 专为 Automator Quick Action 优化
# 支持批量转换多个 SVG 文件

# 设置 PATH 和工具路径
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
RSVG_CONVERT="/opt/homebrew/bin/rsvg-convert"
OSASCRIPT="/usr/bin/osascript"

# 检查是否安装了 rsvg-convert
if [ ! -f "$RSVG_CONVERT" ]; then
    $OSASCRIPT -e 'display notification "rsvg-convert 未找到，请检查 librsvg 安装" with title "SVG2PNG 错误" sound name "Basso"'
    exit 1
fi

# 检查是否有输入文件
if [ $# -eq 0 ]; then
    $OSASCRIPT -e 'display notification "请选择 SVG 文件" with title "SVG2PNG" sound name "Basso"'
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
    
    # 使用 rsvg-convert 转换，针对 Retina 屏优化，明确指定高分辨率尺寸
    if "$RSVG_CONVERT" \
        --width 3200 \
        --height 3600 \
        --format png \
        --keep-aspect-ratio \
        --background-color transparent \
        --output "$output_file" \
        "$input_file" 2>/dev/null; then
        
        # 使用 macOS 内置的 sips 优化 PNG 文件大小
        if command -v sips &> /dev/null; then
            /usr/bin/sips -s formatOptions 90 "$output_file" &> /dev/null || true
        fi
        
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
        $OSASCRIPT -e "display notification \"成功转换 $converted_count 个 SVG 文件为高清 PNG\" with title \"SVG2PNG\" sound name \"Glass\""
    else
        $OSASCRIPT -e "display notification \"成功转换 $converted_count 个，失败 $failed_count 个\" with title \"SVG2PNG\" sound name \"Glass\""
    fi
    
    # 在终端中显示结果摘要
    echo ""
    echo "=== 转换结果摘要 ==="
    printf '%s\n' "${conversion_results[@]}"
    echo "总计: $converted_count 成功, $failed_count 失败"
else
    $OSASCRIPT -e 'display notification "转换失败，请检查 SVG 文件格式" with title "SVG2PNG" sound name "Basso"'
fi