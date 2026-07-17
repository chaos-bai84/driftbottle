[English](./README_EN.md) | 中文

> **⚠️ 版权声明 / Legal Notice**
>
> DriftBottle 是专有软件（Proprietary Software），版权归 DriftBottle Team 所有。
>
> 本仓库仅用于作品集展示和个人参考，**禁止**任何形式的商业使用、复制、分发、修改或基于本代码开发竞争产品。
>
> 如需使用本软件，请下载官方发布的 APK 安装包。未经授权使用、传播或反向工程将追究法律责任。
>
> 详见根目录 [COPYRIGHT](./COPYRIGHT) 文件。

# DriftBottle

一个全球化的漂流瓶社交应用，通过 AI 实时翻译让不同语言的人无障碍交流。

每次捞到一个瓶子，都是一场跨国文化邂逅。

## 核心特性

- 🌍 **跨国文化交流** — 与来自世界各地的用户匿名交流
- 🤖 **AI 实时翻译** — 打破语言障碍，聊天气泡同时显示原文与译文
- 🏷️ **话题标签系统** — 用标签让志同道合的人更容易相遇
- 🎣 **随机捞瓶体验** — 海洋中随机捞起一个瓶子，带来惊喜感
- 💬 **一对一对话** — 感兴趣的瓶子可直接回复，开启实时聊天

## 下载体验

你可以从 [Releases](https://github.com/chaos-bai84/driftbottle/releases) 页面下载最新版 Android APK 安装体验。

> iOS 版本需通过 App Store / TestFlight 分发，敬请期待。

## 仓库说明

本仓库为 **Public 展示仓库**，仅用于：

- 展示 Flutter 跨端开发能力
- 展示产品设计与架构思路
- 方便潜在合作方或雇主查看代码质量

**注意：**
- 公开代码中已移除 Supabase 密钥等敏感配置（见 `lib/config/secrets.example.dart`）
- 核心匹配逻辑、支付系统等商业敏感模块未包含在公开仓库中
- 本仓库代码**不可直接编译运行**，因为缺少私有配置文件

## 技术栈

- **Flutter** — 跨平台 UI 框架
- **Supabase** — 后端服务（PostgreSQL + Realtime + Auth）
- **Google 翻译 API** — 免费翻译服务

## 联系我们

如需商务合作、授权使用或其他咨询，请联系仓库所有者。

---

© 2026 DriftBottle Team. All Rights Reserved.
