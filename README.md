# SVG2PNG macOS Quick Action

在 macOS Finder 中右键点击 SVG 文件即可转换为超高清 PNG 图片的快捷操作。

## 功能特点

- 🎯 **右键快捷操作**: 在 Finder 中右键点击 SVG 文件即可转换
- 🔍 **超高清输出**: 专为 Retina 屏优化，4倍分辨率输出
- 🌈 **保持透明度**: 完整保留 SVG 的透明背景
- 📦 **批量转换**: 支持同时选择多个 SVG 文件批量转换
- 🔔 **实时通知**: 转换完成后显示系统通知
- 📱 **Retina 优化**: 针对高分辨率屏幕特别优化

## 项目结构

```
svg2png_mac/
├── svg2png.sh          # 核心转换脚本
└── README.md           # 完整使用指南
```

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

6. **保存 Quick Action**
   - 按 `Cmd+S` 保存
   - 命名为 "SVG2PNG"
   - 点击 "Save"

## 使用方法

1. 在 Finder 中选择一个或多个 SVG 文件
2. 右键点击，选择 "SVG2PNG"
3. 转换完成后，PNG 文件将保存在相同目录
4. 系统会显示转换结果通知

## 技术细节

- **转换引擎**: rsvg-convert (librsvg)
- **输出分辨率**: 3200x3600 像素 (针对 800x900 viewBox)
- **Retina 优化**: 4倍分辨率确保清晰显示
- **压缩优化**: 使用 macOS sips 工具优化文件大小
- **支持格式**: SVG → PNG
- **特性**: 保持透明背景、保持宽高比

## 错误调试指南

### 查看错误日志的方法

当 Quick Action 报错时，按以下步骤查看具体错误：

#### 方法 1: Console 应用（推荐）
1. 打开 **Console** 应用（Applications > Utilities）
2. 在左侧选择你的 Mac 设备
3. 在搜索框输入 "Automator" 或 "WorkflowServiceRunner"
4. 重新执行 Quick Action 触发错误
5. 查看实时日志中的错误信息

#### 方法 2: Automator 内置日志
1. 在 Automator 中打开 SVG2PNG workflow
2. 点击 `View > Show Log` 或按 `Cmd+L`
3. 点击播放按钮直接运行 workflow
4. 查看底部日志窗口的错误信息

### 常见问题解决

#### ❌ "rsvg-convert: command not found"
**原因**: 系统找不到 rsvg-convert 命令
**解决方案**: 脚本已使用完整路径 `/opt/homebrew/bin/rsvg-convert`

#### ❌ "Permission denied"
**解决方案**: 
- 确保可以写入目标目录
- 检查 SVG 文件是否可读

#### ❌ Quick Action 不显示
**解决方案**: 
- 检查 系统偏好设置 > 扩展 > Finder
- 确保 "SVG2PNG" 已启用
- 重启 Finder: `killall Finder`

#### ❌ 输出图片模糊
**原因**: 可能是 SVG 没有固定尺寸
**解决方案**: 脚本已配置为明确指定高分辨率输出 (3200x3600)

#### ❌ 没有任何输出
**解决方案**: 
- 确保在 Automator 中选择了 `Pass input: as arguments`
- 检查是否选择了正确的 SVG 文件

### 性能优化

- **高分辨率**: 输出 4倍分辨率确保 Retina 屏清晰显示
- **文件压缩**: 自动使用 sips 优化 PNG 文件大小
- **批量处理**: 支持同时转换多个文件
- **错误处理**: 详细的错误报告和通知

## 更新脚本

如需更新转换脚本：
1. 编辑 `svg2png.sh` 文件
2. 复制新内容到 Automator workflow
3. 保存 workflow

## 卸载

删除 Quick Action：
```bash
rm -rf ~/Library/Services/SVG2PNG.workflow
```

## 许可证

MIT License