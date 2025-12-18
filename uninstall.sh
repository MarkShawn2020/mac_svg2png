#!/bin/bash

# SVG2PNG Quick Action 卸载脚本

WORKFLOW_DIR="$HOME/Library/Services/SVG2PNG.workflow"

echo "=== SVG2PNG Quick Action 卸载程序 ==="
echo ""

if [ -d "$WORKFLOW_DIR" ]; then
    rm -rf "$WORKFLOW_DIR"
    /System/Library/CoreServices/pbs -update 2>/dev/null || true
    echo "✓ 已卸载 SVG2PNG Quick Action"
else
    echo "SVG2PNG Quick Action 未安装"
fi
