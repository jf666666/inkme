# inkme

## 简介

inkme 是一个基于Swift开发的SplatNet 3客户端，目前处于积极开发阶段。这个项目旨在提供SplatNet 3的核心功能，并计划引入一些创新特性，如历史数据存储、多账号管理等，旨在为Splatoon玩家提供一个更加全面和便捷的体验。

## 当前状态

目前，inkme 正在开发中，正在努力实现SplatNet 3的基本功能。请注意，一些功能可能还不完善或暂未实现。

## 计划特性


| 特性             | 状态     | 备注                            |
|------------------|----------|---------------------------------|
| 日程查询         | 基本完成 | 活动比赛的界面未制作            |
| 历史游玩记录存储 | 基本完成 | 实现了打工记录与战斗记录的存储  |
| 历史游玩记录统计 | 未实现   | -                               |
| 多账号管理       | 基本完成 | 多账号管理功能仍然有bug需要解决 |
| 分享功能         | 部分完成 | 暂时只实现了打工界面的保存功能  |
| 其他计划功能     | -        |      -                           |

<img src="https://github.com/jf666666/imink3/assets/63494980/e4bf0965-a67e-4951-81e8-684814d47749" width="5800"  alt="多账号管理">


## 如何开始

要开始使用inkme，您可以通过以下步骤下载和设置项目：

### 下载项目

1. **下载ZIP**：
   - 访问项目的GitHub页面。
   - 点击“Code”按钮，然后选择“Download ZIP”。
   - 解压ZIP文件到您希望的文件夹。

2. **使用Xcode**：
   - 打开Xcode。
   - 选择“Clone an existing project”。
   - 输入项目的GitHub仓库地址，然后按照提示操作。
   - 或者点击[用Xcode打开](xcode://clone?repo=https%253A%252F%252Fgithub.com%252Fjf666666%252Fimink3)

### 设置项目

一旦您下载了项目，您可以使用Xcode打开项目文件夹中的`.xcodeproj`文件。如果项目有任何依赖项，您可能需要按照项目文档中的说明进行安装和配置。

### 运行项目

在Xcode中打开项目后，您可以选择适当的模拟器或连接您的设备，然后点击运行按钮来启动应用。


## 贡献

inkme 是一个开源项目，我们欢迎并感谢任何形式的贡献，包括代码贡献、问题报告或功能建议。

## 许可证

inkme 遵循 [MIT 许可证](/LICENSE)。

inkme 使用 [Splatoon3.ink](https://splatoon3.ink/) 提供的API获取赛程和轮班信息，使用 [imink f API](https://github.com/imink-app/f-API) 和 [nxapi znca API](https://github.com/samuelthomas2774/nxapi-znca-api/) 进行账户授权，以及使用 [Nintendo app versions](https://github.com/nintendoapis/nintendo-app-versions) 获取API版本更新。

inkme 在构建时使用 [splat3](https://github.com/Leanny/splat3) 进行地图映射，并使用 [Nintendo app versions](https://github.com/nintendoapis/nintendo-app-versions) 获取API版本更新。

inkme 在数据转换器中使用 [Splatoon3.ink](https://splatoon3.ink/) 获取图像，以及使用 [splat3](https://github.com/Leanny/splat3) 进行地图映射。

inkme 对包括 [s3s](https://github.com/frozenpandaman/s3s)、[s3si.ts](https://github.com/spacemeowx2/s3si.ts)、[conch-bay](https://github.com/zhxie/conch-bay/tree/master) 和 [imink](https://github.com/JoneWang/imink) 在内的Splatoon相关开源作者表示感谢。


## 联系方式和反馈

您的反馈对我们非常重要。如果您有任何问题、建议或想法，请通过[联系方式]与我们联系。
