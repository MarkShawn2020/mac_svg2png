# SVG2PNG macOS Quick Action

在 macOS Finder 中右键点击 SVG 文件即可转换为高清 PNG。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/MarkShawn2020/mac_svg2png/main/install.sh | bash
```

## 使用

1. 右键点击 SVG 文件
2. Quick Actions → SVG2PNG
3. PNG 保存在同目录

## 卸载

```bash
rm -rf ~/Library/Services/SVG2PNG.workflow
```

## 技术参数

- 输出: 3200x3600 (4x Retina)
- 背景: 透明
- 引擎: rsvg-convert (librsvg)

## License

MIT
