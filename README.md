# SVG2PNG macOS Quick Action

在 macOS Finder 中右键点击 SVG 文件即可转换为高清 PNG。

## 一键安装

```bash
./install.sh
```

安装脚本会自动：
- 检查并安装 librsvg 依赖（需要 Homebrew）
- 创建 Finder Quick Action
- 刷新系统服务

## 卸载

```bash
./uninstall.sh
```

## 使用方法

1. 在 Finder 中选择 SVG 文件
2. 右键 → Quick Actions → SVG2PNG
3. PNG 保存在同目录

## 技术参数

| 参数 | 值 |
|------|-----|
| 输出分辨率 | 3200x3600 (4x Retina) |
| 背景 | 透明 |
| 压缩质量 | 90 |
| 转换引擎 | rsvg-convert (librsvg) |

## 项目结构

```
├── install.sh      # 一键安装
├── uninstall.sh    # 卸载
├── svg2png.sh      # 核心转换脚本
└── README.md
```

## 故障排除

**Quick Action 不显示**: 系统设置 → 隐私与安全性 → 扩展 → Finder，启用 SVG2PNG

**rsvg-convert 未找到**: 运行 `brew install librsvg`

## License

MIT
