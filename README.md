# 互动卡片（Live Card）

## 项目简介

本项目是一个完整的 HarmonyOS 互动卡片（Live Form）示例应用，展示了从静态卡片、动态卡片到互动卡片的完整开发流程。项目包含 5 个场景的卡片示例：

| 卡片 | 尺寸 | 互动能力 | 着陆页 |
|------|------|---------|--------|
| 睡眠卡片 | 2×4 | 点击触发起床/入睡动画（三叶草+憨憨帧动画） | 三叶草页 / 睡眠报告 |
| 快递卡片 | 2×2 | 陀螺仪驱动憨憨移动（设备倾斜控制） | 快递详情 |
| 运动卡片 | 2×2 | 开始/结束运动动画 + 卡路里燃烧进度 | 运动记录 |
| 音乐卡片 | 2×4 | 播放/切歌/收藏 + 专辑封面帧动画 | 音乐播放器 |
| 天气卡片 | 2×2 | 静态信息展示 | 天气详情 |

---

## 效果预览

|                 睡眠卡片                 |                     运动卡片                      |                     运动卡片                      |
|:------------------------------------:|:---------------------------------------------:|:---------------------------------------------:|
|               三叶草起床动画                |                    开始运动动画                     |                    结束运动动画                     |
| ![Sleep](screenshots/sleep_card.gif) | ![Exercise](screenshots/exercise_card_01.gif) | ![Exercise](screenshots/exercise_card_02.gif) |

|                    快递卡片                    |                  音乐卡片                   |                  音乐卡片                   |
|:------------------------------------------:|:---------------------------------------:|:---------------------------------------:|
|                 陀螺仪控制憨憨移动                  |                 音乐播放动画                  |                 音乐切歌动画                  |
| ![Delivery](screenshots/delivery_card.gif) | ![Music](screenshots/music_card_01.gif) | ![Music](screenshots/music_card_02.gif) |

---

## 项目架构总览

```
┌─────────────────────────────────────────────────────────────┐
│                      桌面卡片 (Widget)                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────┐│
│  │SleepCard │ │MusicCard │ │ExerCard  │ │DeliCard  │ │Wea ││
│  │  (静态)   │ │  (静态)   │ │  (静态)   │ │  (静态)   │ │静态 ││
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┘│
│       │postCardAction (MESSAGE/ROUTER/CALL)                  │
└───────┼──────────────────────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────────────────────────────┐
│               EntryFormAbility (卡片管理中心)                   │
│  onAddForm → onFormEvent → requestOverflow → cancelOverflow  │
│  - 接收卡片事件，激活互动卡片                                     │
│  - 管理卡片生命周期                                             │
└──────┬───────────────────────────────────────────────────────┘
       │
       ▼ MESSAGE "requestOverflow"
┌──────────────────────────────────────────────────────────────┐
│              互动卡片 LiveFormExtensionAbility                 │
│  ┌─────────────────┐ ┌──────────────┐ ┌──────────────────┐   │
│  │SleepLiveCard    │ │MusicLiveCard │ │ExerciseLiveCard  │   │
│  │Ability          │ │Ability       │ │Ability           │   │
│  └────────┬────────┘ └──────┬───────┘ └────────┬─────────┘   │
│           │                 │                  │              │
│  ┌────────┴────────┐ ┌──────┴───────┐ ┌────────┴─────────┐   │
│  │SleepLiveCard.ets│ │MusicLiveCard │ │ExerciseLiveCard  │   │
│  │ (帧动画 + 点击)  │ │ (Canvas动画) │ │ (帧动画+卡路里)   │   │
│  └─────────────────┘ └──────────────┘ └──────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐    │
│  │         DeliveryLiveCard (陀螺仪动画)                  │    │
│  └──────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
       │
       │ ROUTER (postCardAction)
       ▼
┌──────────────────────────────────────────────────────────────┐
│              EntryAbility (主应用 UIAbility)                   │
│  ┌───────────────────────────────────────────────────────┐   │
│  │                   Navigation(NavPathStack)             │   │
│  │  ┌─────────────────┐  ┌───────────────────────────┐   │   │
│  │  │   Index.ets     │  │   Landing Pages (详情页)   │   │   │
│  │  │   (卡片预览列表)  │  │   - CloverPageView       │   │   │
│  │  │                 │  │   - SleepReportPageView   │   │   │
│  │  │  5张卡片预览图    │  │   - DeliveryPageView     │   │   │
│  │  │  长按添加到桌面   │  │   - ExercisePageView     │   │   │
│  │  └─────────────────┘  │   - MusicPageView         │   │   │
│  │                       │   - WeatherPageView       │   │   │
│  │                       └───────────────────────────┘   │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐   │
│  │  业务逻辑层 (viewmodel)                                 │   │
│  │  MediaService / AVPlayerService / AVSessionService     │   │
│  │  音乐播放、媒体会话管理                                   │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐   │
│  │  工具层 (utils)                                        │   │
│  │  WindowUtil / RouterUtil / ActionUtils / GyroscopeUtil │   │
│  │  ImageUtils / FormUtils / Logger / DateFormatter       │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐   │
│  │  数据层 (database)                                     │   │
│  │  FileStore / RdbHelper / PreferencesUtil               │   │
│  │  跨进程数据共享（卡片↔应用）                              │   │
│  └───────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

---

## 三种卡片形态对比

| | 静态卡片 | 动态卡片 | 互动卡片 (Live Form) |
|---|---|---|---|
| **ExtensionAbility** | `FormExtensionAbility` | `FormExtensionAbility` | `LiveFormExtensionAbility` |
| **更新机制** | 定时/事件驱动 `updateForm` | 定时/事件驱动 `updateForm` | `updateForm` + 独立渲染进程 |
| **动画支持** | 无 | 属性动画 | 帧动画 / Canvas / 陀螺仪 |
| **交互方式** | 点击跳转 | 点击跳转+简单交互 | 实时交互+传感器+动画 |
| **生命周期** | 由系统管理 | 由系统管理 | `onLiveFormCreate` 独立控制 |
| **配置** | `form_config.json` | `form_config.json` + `isDynamic:true` | `form_config.json` + `sceneAnimationParams` |

---

## 工程目录详解

```
LiveCard-master/
├── AppScope/                        # 应用全局配置
│   └── app.json5                    # 应用包名、版本、图标
│
├── entry/src/main/
│   ├── ets/
│   │   ├── common/                  # 公共常量与配置
│   │   │   ├── ColorConstants.ets   # 全局颜色常量（主色、背景、卡片色等）
│   │   │   └── CommonConstants.ets  # 间距、字号、圆角、动画时长、AppStorage Key
│   │   │
│   │   ├── database/                # 数据持久化层（跨进程共享）
│   │   │   ├── FileStore.ets        # 文件存储抽象基类
│   │   │   ├── MusicFileStore.ets   # 音乐状态文件存储（triggerAction、当前歌曲）
│   │   │   ├── ExerciseFileStore.ets# 运动状态文件存储
│   │   │   ├── FormRdbHelper.ets    # 卡片信息关系型数据库
│   │   │   ├── PreferencesUtil.ets  # 首选项键值存储
│   │   │   ├── RdbUtils.ets         # 数据库工具方法
│   │   │   └── SongRdbHelper.ets    # 歌曲收藏数据库
│   │   │
│   │   ├── entryability/
│   │   │   └── EntryAbility.ets     # 主 UIAbility（应用入口）
│   │   │
│   │   ├── entrybackupability/
│   │   │   └── EntryBackupAbility.ets # 备份恢复 Extension
│   │   │
│   │   ├── entryformability/
│   │   │   └── EntryFormAbility.ets # 卡片管理中心（FormExtensionAbility）
│   │   │
│   │   ├── livecardability/         # 互动卡片核心
│   │   │   ├── pages/               # 互动卡片 UI
│   │   │   │   ├── DeliveryLiveCard.ets  # 快递互动卡片（陀螺仪）
│   │   │   │   ├── ExerciseLiveCard.ets  # 运动互动卡片（帧动画+卡路里）
│   │   │   │   ├── MusicLiveCard.ets     # 音乐互动卡片（Canvas+帧动画）
│   │   │   │   └── SleepLiveCard.ets     # 睡眠互动卡片（权重化帧动画）
│   │   │   ├── DeliveryLiveCardAbility.ets # 快递 LiveFormExtensionAbility
│   │   │   ├── ExerciseLiveCardAbility.ets # 运动 LiveFormExtensionAbility
│   │   │   ├── MusicLiveCardAbility.ets    # 音乐 LiveFormExtensionAbility
│   │   │   └── SleepLiveCardAbility.ets    # 睡眠 LiveFormExtensionAbility
│   │   │
│   │   ├── lyric/                   # 歌词系统
│   │   │   ├── LrcEntry.ets         # 歌词数据模型（时间+文本）
│   │   │   ├── LrcUtils.ets         # LRC/KRC 解析工具
│   │   │   ├── LrcView.ets          # 歌词滚动渲染组件
│   │   │   └── LyricConst.ets       # 歌词常量
│   │   │
│   │   ├── model/                   # 数据模型
│   │   │   ├── common/
│   │   │   │   ├── FormCardConstant.ets  # 卡片通信常量、LiveCardScale、CardActionType
│   │   │   │   ├── FormInfo.ets          # 卡片信息实体
│   │   │   │   └── NavInfo.ets           # 导航信息
│   │   │   ├── delivery/
│   │   │   │   └── DeliveryConstant.ets  # 快递物流状态模型
│   │   │   ├── exercise/
│   │   │   │   ├── ExerciseCardConstant.ets # 运动状态枚举、帧序列
│   │   │   │   └── ExerciseModel.ets     # 运动统计数据模型
│   │   │   ├── music/
│   │   │   │   ├── FormControlData.ets   # 卡片控制数据
│   │   │   │   ├── MusicConstants.ets    # 音乐常量
│   │   │   │   ├── MusicData.ets         # 音乐数据类型
│   │   │   │   ├── MusicLiveCardConstant.ets # 音乐卡片帧序列、封面配置
│   │   │   │   └── SongItem.ets          # 歌曲数据模型（id/title/singer/lyric/label）
│   │   │   ├── sleep/
│   │   │   │   └── SleepConstants.ets    # 睡眠数据常量
│   │   │   ├── weather/
│   │   │   │   └── WeatherData.ets       # 天气数据模型
│   │   │   └── CardConstant.ets      # 主页卡片配置（CardItemConfig）
│   │   │
│   │   ├── pages/
│   │   │   └── Index.ets              # 主页（卡片预览 Grid + 导航容器）
│   │   │
│   │   ├── utils/                     # 工具类
│   │   │   ├── ActionUtils.ets        # 卡片通信桥梁（postCardAction 封装）
│   │   │   ├── BackgroundUtil.ets     # 后台任务管理
│   │   │   ├── CardActionHandler.ets  # 卡片 CALL 事件处理（rpc 通信）
│   │   │   ├── DateFormatter.ets      # 国际化日期格式化
│   │   │   ├── FormUtils.ets          # 卡片数据更新 + 状态管理
│   │   │   ├── GyroscopeUtil.ets      # 陀螺仪订阅封装
│   │   │   ├── ImageUtils.ets         # 图片处理（取色、模糊、Bitmap 加载）
│   │   │   ├── Logger.ets             # 统一日志工具
│   │   │   ├── MediaTools.ets         # 媒体文件工具
│   │   │   ├── RouterUtil.ets         # NavPathStack 路由单例
│   │   │   └── WindowUtil.ets         # 窗口尺寸/断点/横竖屏管理
│   │   │
│   │   ├── view/                      # 着陆页视图
│   │   │   ├── common/
│   │   │   │   └── HeaderSection.ets  # 通用 Header 组件
│   │   │   ├── delivery/
│   │   │   │   └── DeliveryPageView.ets   # 快递详情页（状态卡片+物流时间线）
│   │   │   ├── exercise/
│   │   │   │   ├── DetailStatItem.ets     # 运动详情行
│   │   │   │   ├── ExercisePageView.ets   # 运动记录页
│   │   │   │   ├── OverviewStatItem.ets   # 概览统计卡片
│   │   │   │   ├── SelectorItem.ets       # 选择器标签
│   │   │   │   └── StatsGrid.ets          # 统计网格
│   │   │   ├── music/
│   │   │   │   ├── MusicInfo.ets          # 封面+歌曲信息
│   │   │   │   ├── MusicPageView.ets      # 音乐页容器
│   │   │   │   ├── PlayerControlArea.ets  # 播放控制栏（进度条/播放/切歌）
│   │   │   │   ├── PlayerLyrics.ets       # 歌词页（LRC解析+滚动）
│   │   │   │   └── PlayerView.ets         # 播放器主视图（Swiper双栏）
│   │   │   ├── sleep/
│   │   │   │   ├── CloverPageView.ets     # 三叶草健康任务页
│   │   │   │   ├── CloverTaskCard.ets     # 任务卡片
│   │   │   │   └── SleepReportPageView.ets # 睡眠报告页（阶段图表+分析）
│   │   │   └── weather/
│   │   │       └── WeatherPageView.ets    # 天气详情页
│   │   │
│   │   ├── viewmodel/                # 业务逻辑层
│   │   │   └── music/
│   │   │       ├── AVPlayerService.ets   # AVPlayer 封装（播放/暂停/切歌）
│   │   │       ├── AVSessionService.ets  # 媒体会话（锁屏控制/息屏播放）
│   │   │       ├── MediaService.ets      # 音乐播放总控
│   │   │       ├── SongItemBuilder.ets   # 歌曲资源构建
│   │   │       └── SongListData.ets      # 歌曲列表初始化数据
│   │   │
│   │   └── widget/pages/             # 静态/动态卡片 UI
│   │       ├── DeliveryCard.ets      # 快递卡片
│   │       ├── ExerciseCard.ets      # 运动卡片
│   │       ├── MusicCard.ets         # 音乐卡片
│   │       ├── SleepCard.ets         # 睡眠卡片
│   │       └── WeatherCard.ets       # 天气卡片
│   │
│   ├── resources/
│   │   ├── base/
│   │   │   ├── element/
│   │   │   │   ├── color.json        # 颜色资源
│   │   │   │   ├── float.json        # 浮点资源（字号、圆角等）
│   │   │   │   └── string.json       # 中文字符串
│   │   │   ├── media/                # 图标和图片资源
│   │   │   └── profile/
│   │   │       ├── backup_config.json
│   │   │       ├── form_config.json  # ⭐ 卡片配置（尺寸、互动Ability绑定）
│   │   │       ├── main_pages.json   # 页面入口
│   │   │       └── route_map.json    # ⭐ 命名路由映射
│   │   ├── dark/element/
│   │   │   └── color.json            # 深色模式颜色
│   │   ├── en_US/element/
│   │   │   └── string.json           # 英文字符串
│   │   ├── zh_CN/element/
│   │   │   └── string.json           # 中文字符串
│   │   └── rawfile/                  # 原始文件资源
│   │       ├── delivery/             # 快递卡片素材（背景、憨憨图）
│   │       ├── exercise/             # 运动卡片素材（动画帧序列、GIF）
│   │       ├── lrcfiles/             # 歌词文件 (.lrc)
│   │       ├── music/                # 音乐卡片素材（专辑、动画帧）
│   │       ├── sleep/                # 睡眠卡片素材（憨憨帧、三叶草帧）
│   │       ├── *.mp3                 # 音频文件
│   │       └── weather/              # 天气图标
│   │
│   └── module.json5                  # ⭐ 模块配置（Ability、权限、deviceTypes）
│
└── oh_modules/                       # 依赖（ohpm）
```

---

## 核心代码逐行详解

### 1. 配置层

#### module.json5 — 模块配置

```json5
{
  "module": {
    "name": "livecardsample",           // 模块名称
    "type": "entry",                    // 入口模块
    "mainElement": "LiveCardAbility",   // 主 Ability 名称
    "deviceTypes": [                    // ⭐ 多端部署：支持的设备类型
      "phone",                          // 手机
      "tablet",                         // 平板
      "2in1"                            // 二合一设备
    ],
    "deliveryWithInstall": true,        // 安装时自动部署
    "abilities": [
      {
        "name": "LiveCardAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ets", // 入口 Ability 实现
        "exported": true,               // 允许外部调用
        "continuable": true,            // ⭐ 自由流转：支持任务接续
        "backgroundModes": ["audioPlayback"], // 后台音频播放
        "skills": [
          {
            "entities": ["entity.system.home"],  // 桌面图标
            "actions": ["ohos.want.action.home"]
          }
        ]
      }
    ],
    "extensionAbilities": [
      {
        "name": "EntryBackupAbility",
        "srcEntry": "./ets/entrybackupability/EntryBackupAbility.ets",
        "type": "backup"                // 备份恢复 Extension
      },
      {
        "name": "EntryFormAbility",
        "srcEntry": "./ets/entryformability/EntryFormAbility.ets",
        "type": "form"                  // ⭐ 卡片管理 Extension（静态/动态卡片）
      },
      {
        "name": "SleepLiveCardAbility",
        "srcEntry": "./ets/livecardability/SleepLiveCardAbility.ets",
        "type": "liveForm"              // ⭐ 互动卡片 Extension
      },
      // ... DeliveryLiveCardAbility, ExerciseLiveCardAbility, MusicLiveCardAbility
    ],
    "requestPermissions": [
      { "name": "ohos.permission.KEEP_BACKGROUND_RUNNING" },  // 后台长时任务
      { "name": "ohos.permission.GYROSCOPE" }                 // 陀螺仪
    ]
  }
}
```

**关键配置解读：**

| 配置项 | 值 | 作用 |
|--------|-----|------|
| `deviceTypes` | `["phone", "tablet", "2in1"]` | 声明支持手机、平板、二合一，系统据此启用多端适配 |
| `continuable: true` | 主 Ability | 启用自由流转，任务可在设备间迁移 |
| `type: "form"` | EntryFormAbility | 标准卡片 Extension，处理卡片添加/更新/删除/事件 |
| `type: "liveForm"` | 四个 LiveCardAbility | 互动卡片 Extension，拥有独立渲染进程 |
| `backgroundModes` | `["audioPlayback"]` | 音乐卡片需要后台音频播放 |
| `exported: true` | 主 Ability | 允许卡片通过 `postCardAction` CALL 事件调用应用 |

#### form_config.json — 卡片配置

```json5
{
  "forms": [
    {
      "name": "SleepCard",              // 卡片名称
      "displayName": "$string:SleepCard", // 显示名称（多语言）
      "src": "./ets/widget/pages/SleepCard.ets", // ⭐ 卡片 UI 文件
      "uiSyntax": "arkts",              // ArkTS 声明式语法
      "window": {
        "designWidth": 720,             // 设计稿宽度（基准）
        "autoDesignWidth": true         // 自动适应不同宽度
      },
      "colorMode": "auto",              // 跟随系统深色模式
      "isDynamic": true,                // ⭐ 启用动态卡片（可响应 updateForm）
      "isDefault": false,               // 非默认卡片
      "updateEnabled": false,           // 禁用定时更新
      "scheduledUpdateTime": "10:30",   // 定时更新时间
      "updateDuration": 1,              // 持续更新间隔（秒）
      "defaultDimension": "2*4",        // 默认尺寸（2列×4行）
      "supportDimensions": ["2*4"],     // 支持的尺寸列表
      "sceneAnimationParams": {          // ⭐ 互动卡片参数
        "abilityName": "SleepLiveCardAbility"  // 绑定的 LiveFormExtensionAbility
      }
    }
  ]
}
```

**字段作用说明：**
- `src`：卡片 UI 的 .ets 文件路径，系统据此加载卡片视图
- `isDynamic: true`：允许通过 `formProvider.updateForm()` 更新卡片数据
- `sceneAnimationParams.abilityName`：激活互动卡片时，系统根据此字段找到对应的 `LiveFormExtensionAbility` 并调用 `onLiveFormCreate`
- `supportDimensions`：限制卡片尺寸，如 `"2*2"` 表示 2 列宽 2 行高
- `metadata.isSupportShake`（快递卡片）：声明支持摇一摇触发

#### route_map.json — 命名路由映射

```json5
{
  "routerMap": [
    {
      "name": "SleepReport",                                              // 路由名称
      "pageSourceFile": "src/main/ets/view/sleep/SleepReportPageView.ets", // 页面文件
      "buildFunction": "SleepReportPageViewBuilder"                       // @Builder 函数名
    }
    // ... CloverPage, DeliveryPage, ExercisePage, MusicPage, WeatherPage
  ]
}
```

**工作原理**：卡片通过 `postCardAction({ action: ROUTER, params: { routeName: 'MusicPage' } })` 跳转时，`RouterUtil` 根据 `routeName` 匹配 `route_map.json` 中的条目，调用对应的 `@Builder` 函数替换当前 NavPathStack 页面。

---

### 2. 入口层

#### EntryAbility.ets — 应用入口（逐行解释）

```typescript
// 第16行：导入 HarmonyOS SDK 模块
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
// UIAbility: 应用生命周期基类
// Want: 启动参数（类似 Android Intent）
// ConfigurationConstant: 系统配置常量（如颜色模式）
// AbilityConstant: Ability 相关常量

import { window } from '@kit.ArkUI';
// window: 窗口管理 API，WindowStage 控制窗口生命周期

import { Logger } from '../utils/Logger';
// Logger: 日志工具（封装 hilog）

import { MediaService } from '../viewmodel/music/MediaService';
// MediaService: 音乐播放服务单例，管理播放状态

import CardActionHandler from '../utils/CardActionHandler';
// CardActionHandler: 处理卡片 CALL 事件（rpc 通信）

import RouterUtil from '../utils/RouterUtil';
// RouterUtil: NavPathStack 路由单例

import { WindowUtil } from '../utils/WindowUtil';
// WindowUtil: 窗口管理工具（尺寸、断点、横竖屏）

import FormUtils from '../utils/FormUtils';
// FormUtils: 卡片数据更新工具

import { Constants } from '../common/CommonConstants';
// Constants: AppStorage Key 常量定义

const TAG = 'EntryAbility';  // 日志标签

export default class EntryAbility extends UIAbility {
  private windowUtil?: WindowUtil;  // 窗口工具实例

  // ═══════ onCreate: Ability 创建时调用（最早生命周期） ═══════
  onCreate(want: Want): void {
    Logger.info(TAG, 'Ability onCreate');

    // 将应用上下文存入 AppStorage，供全局访问
    // KEY_CONTEXT = 'livecardcontext'
    AppStorage.setOrCreate(Constants.KEY_CONTEXT, this.context);

    try {
      // 设置颜色模式为"不设置"（跟随系统）
      this.context.getApplicationContext().setColorMode(
        ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET
      );

      // 初始化卡片动作处理器上下文
      CardActionHandler.setContext(this.context);

      // 注册 rpc 通信：卡片通过 callee 调用应用方法
      // 'cardAction' 是卡片端发送的 rpc 方法名
      // CardActionHandler.getHandler() 返回处理函数
      this.callee.on('cardAction', CardActionHandler.getHandler());

      // 初始化卡片数据库（存储卡片信息）
      FormUtils.initFormRdb(this.context);
    } catch (err) {
      Logger.error(TAG, 'Failed to initialize ability. Cause: %{public}s', err);
    }

    // 初始化音乐播放服务
    MediaService.getInstance().initialize(this.context);

    // 处理冷启动时的路由跳转（如从卡片跳转而来）
    RouterUtil.getInstance().openPageByWant(want);
  }

  // ═══════ onNewWant: 热启动时调用 ═══════
  onNewWant(want: Want): void {
    // 应用已运行，从卡片/通知等再次拉起时走这里
    RouterUtil.getInstance().openPageByWant(want);
  }

  // ═══════ onContinue: 自由流转任务接续 ⭐ ═══════
  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    // 保存当前路由名称到 wantParam
    // 目标设备可根据 routeName 恢复到相同页面
    const routeName = RouterUtil.getInstance().getCurrentPageName();
    if (routeName) {
      wantParam.routeName = routeName;
    }
    Logger.info(TAG, `onContinue routeName: ${routeName}`);
    return AbilityConstant.OnContinueResult.AGREE;  // 同意接续
  }

  // ═══════ onDestroy: Ability 销毁 ═══════
  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
    try {
      // 取消 rpc 事件监听
      this.callee.off('cardAction');
      // 销毁音乐播放服务
      MediaService.getInstance().destroy();
      // 如果正在播放，更新卡片播放状态
      let isPlay = AppStorage.get(Constants.KEY_IS_PLAY) as boolean;
      if (isPlay) {
        FormUtils.updateCardPlayStatus(this.context, false);
      }
    } catch (err) {
      Logger.error(TAG, `onDestroy err: ${err}`);
    }
  }

  // ═══════ onWindowStageCreate: 窗口创建（UI 渲染入口） ═══════
  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'Ability onWindowStageCreate');
    try {
      // 创建 WindowUtil 实例，传入主窗口
      // WindowUtil 负责窗口尺寸、断点、横竖屏检测
      this.windowUtil = new WindowUtil(windowStage.getMainWindowSync());

      // 将 WindowUtil 存入 AppStorage，供全局访问
      AppStorage.setOrCreate(Constants.KEY_WINDOW_UTIL, this.windowUtil);
    } catch (err) {
      Logger.error(TAG, 'Failed to get MainWindowSync. Cause: %{public}s', err);
    }

    // 加载主页 UI
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load content. Cause: %{public}s', err.name);
        return;
      }
      Logger.info(TAG, 'Succeeded in loading content.');
      // ⭐ UI 加载完成后初始化窗口信息（获取尺寸、注册事件监听）
      if (this.windowUtil) {
        this.windowUtil.setUIContext();    // 获取 UIContext
        this.windowUtil.updateWindowInfo(); // 读取初始窗口状态并注册事件
      }
    });
  }

  // ═══════ onWindowStageDestroy: 窗口销毁 ═══════
  onWindowStageDestroy(): void {
    Logger.info(TAG, 'Ability onWindowStageDestroy');
    // 释放窗口事件监听（避免内存泄漏）
    this.windowUtil?.release();
  }

  onForeground(): void {
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    Logger.info(TAG, 'Ability onBackground');
    // 进入后台时清空路由栈
    RouterUtil.getInstance().clearPages();
  }
}
```

---

### 3. 卡片管理中心

#### EntryFormAbility.ets — 卡片生命周期管理

```typescript
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
// FormExtensionAbility: 卡片管理 Extension 基类
// formProvider: 卡片操作 API（updateForm, requestOverflow, getFormRect 等）
// formBindingData: 卡片数据绑定
// formInfo: 卡片信息类型

export default class EntryFormAbility extends FormExtensionAbility {

  // ═══════ onAddForm: 卡片添加到桌面时调用 ═══════
  onAddForm(want: Want): formBindingData.FormBindingData {
    let formId: string = '';
    let formName: string = '';

    if (want.parameters) {
      // 从 want 参数中提取卡片信息
      formId = want.parameters['ohos.extra.param.key.form_identity'] as string;
      formName = want.parameters['ohos.extra.param.key.form_name'] as string;
      let formDimension = want.parameters['ohos.extra.param.key.form_dimension'] as string;

      // 创建卡片信息对象并存入数据库
      let currentFormInfo = new FormInfo();
      currentFormInfo.formId = formId;
      currentFormInfo.formDimension = formDimension;
      currentFormInfo.formName = formName;
      FormUtils.insertFormData(this.context, currentFormInfo);

      // 如果是音乐卡片，更新控制按钮显示
      if (formName.includes('Music')) {
        FormUtils.updateMusicControlCard(formId, true);
      }
    }

    // 天气卡片：返回完整天气数据作为初始卡片内容
    if (formName.includes('Weather')) {
      return formBindingData.createFormBindingData({
        formId: formId,
        city: DEFAULT_WEATHER.city,
        temperature: DEFAULT_WEATHER.temperature,
        condition: DEFAULT_WEATHER.condition,
        // ... 其他天气字段
      });
    }

    // 其他卡片：返回基础数据
    return formBindingData.createFormBindingData({
      formId: formId,
      formWidth: formWidth,
      formHeight: formHeight
    });
  }

  // ═══════ onUpdateForm: 定时更新或 updateForm 触发 ═══════
  onUpdateForm(formId: string): void {
    FormUtils.getFormInfoById(this.context, formId)
      .then(async (currentFormInfo) => {
        if (!currentFormInfo) return;

        // 快递卡片：触发互动卡片动画
        if (currentFormInfo.formName.includes('Delivery')) {
          this.requestOverflow(formId, LiveCardScale.DELIVERY_WIDTH,
            LiveCardScale.DELIVERY_HEIGHT, LIVE_CARD_DURATION);
        }
        // 运动卡片：重置状态并触发互动动画
        else if (currentFormInfo.formName.includes('Exercise')) {
          ExerciseFileStore.writeExerciseState(this.context, ExerciseState.NOT_STARTED);
          setTimeout(() => {
            this.requestOverflow(formId, LiveCardScale.EXERCISE_WIDTH,
              LiveCardScale.EXERCISE_HEIGHT, LIVE_CARD_DURATION);
          }, 1200);
        }
      });
  }

  // ═══════ onFormEvent: 卡片事件处理（message 事件） ═══════
  async onFormEvent(formId: string, message: string): Promise<void> {
    // message 是 JSON 字符串，包含卡片发送的参数
    const params: Record<string, Object> = JSON.parse(message);
    let shortMessage: string = params.message as string;

    if (shortMessage === 'requestOverflow') {
      // ⭐ 互动卡片激活请求
      let widthRatio: number = params.widthRatio as number;
      let heightRatio: number = params.heightRatio as number;
      let duration: number = params.duration as number;
      let triggerAction: string = params.triggerAction as string || '';
      let songId: string = params.songId as string || '';

      // 音乐卡片：存储触发动作和歌曲ID（跨进程共享）
      if (triggerAction) {
        MusicFileStore.storeTriggerAction(this.context, triggerAction, songId);
      }

      this.requestOverflow(formId, widthRatio, heightRatio, duration);
    }
  }

  // ═══════ onRemoveForm: 卡片从桌面移除 ═══════
  onRemoveForm(formId: string): void {
    FormUtils.deleteFormInfo(this.context, formId);
  }

  // ═══════ requestOverflow: 激活互动卡片核心方法 ═══════
  private async requestOverflow(formId: string, widthRatio: number,
    heightRatio: number, duration: number): Promise<void> {
    try {
      // 获取卡片实际尺寸（系统返回 Rect）
      let formRect: formInfo.Rect = await formProvider.getFormRect(formId);
      if (formRect.width <= 0 || formRect.height <= 0) return;

      // 根据比例计算互动卡片区域
      let cardWidth = formRect.width * widthRatio;
      let cardHeight = formRect.height * heightRatio;
      // 居中放置
      let leftOffset = (formRect.width - cardWidth) / 2;
      let topOffset = (formRect.height - cardHeight) / 2;

      // ⭐ 核心 API：请求激活互动卡片
      formProvider.requestOverflow(formId, {
        area: {
          left: leftOffset,     // 互动区域左边距
          top: topOffset,       // 互动区域上边距
          width: cardWidth,     // 互动区域宽度
          height: cardHeight    // 互动区域高度
        },
        duration: duration      // 动画持续时长（毫秒）
      });
    } catch (error) {
      Logger.error(TAG, `requestOverflow error: ${error}`);
    }
  }

  // onAcquireFormState: 返回卡片就绪状态
  onAcquireFormState(): formInfo.FormState {
    return formInfo.FormState.READY;
  }
}
```

**`requestOverflow` 流程说明：**

```
卡片点击 → postCardAction({ action: MESSAGE, params: { message: 'requestOverflow', ... } })
    → EntryFormAbility.onFormEvent(message)
    → this.requestOverflow(formId, widthRatio, heightRatio, duration)
    → formProvider.getFormRect(formId)           // 1. 获取卡片坐标
    → formProvider.requestOverflow(formId, ...)  // 2. 请求激活
    → 系统根据 form_config.json 中的 sceneAnimationParams.abilityName
    → 激活对应的 LiveFormExtensionAbility
    → onLiveFormCreate() → loadContent()         // 3. 加载互动卡片 UI
```

---

### 4. 互动卡片 LiveFormExtensionAbility

#### SleepLiveCardAbility.ets — 最简单的互动卡片实现

```typescript
import { formInfo, LiveFormExtensionAbility, LiveFormInfo } from '@kit.FormKit';
// LiveFormExtensionAbility: 互动卡片基类
// LiveFormInfo: 互动卡片信息（formId, borderRadius, rect）
// formInfo.Rect: 卡片区域坐标

import { UIExtensionContentSession } from '@kit.AbilityKit';
// UIExtensionContentSession: UI 内容会话，用于 loadContent

export class SleepLiveCardAbility extends LiveFormExtensionAbility {

  // ⭐ onLiveFormCreate: 互动卡片创建回调（唯一必须实现的方法）
  onLiveFormCreate(liveFormInfo: LiveFormInfo, session: UIExtensionContentSession): void {
    // 1. 创建 LocalStorage 实例（用于向卡片 UI 传参）
    let storage: LocalStorage = new LocalStorage();

    // 2. 注入必要数据
    storage.setOrCreate('context', this.context);       // Extension 上下文
    storage.setOrCreate('session', session);             // UI 内容会话
    storage.setOrCreate('formId', liveFormInfo.formId);  // 卡片 ID

    // 3. 卡片外观参数（来自系统）
    storage.setOrCreate('borderRadius', liveFormInfo.borderRadius); // 卡片圆角
    storage.setOrCreate('formRect', liveFormInfo.rect);             // 卡片区域坐标

    // 4. ⭐ 必须同步调用 loadContent，否则白屏
    try {
      session.loadContent('livecardability/pages/SleepLiveCard', storage);
    } catch (error) {
      Logger.error(TAG, `loadContent catch error`);
    }
  }
}
```

#### MusicLiveCardAbility.ets — 带数据加载的互动卡片

```typescript
export class MusicLiveCardAbility extends LiveFormExtensionAbility {
  onLiveFormCreate(liveFormInfo: LiveFormInfo, session: UIExtensionContentSession): void {
    let storage: LocalStorage = new LocalStorage();

    // 基础参数注入（同 SleepLiveCardAbility）
    storage.setOrCreate('context', this.context);
    storage.setOrCreate('session', session);
    storage.setOrCreate('formId', liveFormInfo.formId);
    storage.setOrCreate('borderRadius', liveFormInfo.borderRadius);
    storage.setOrCreate('formRect', liveFormInfo.rect);

    // 音乐卡片特有：初始状态参数
    storage.setOrCreate('triggerAction', '');                    // 触发动作（PLAY/PREVIOUS/NEXT）
    storage.setOrCreate('songList', getSongListData());          // 歌曲列表
    storage.setOrCreate('currentSong', getSongListData()[0]);    // 当前歌曲

    // ⭐ 必须先同步 loadContent，再异步加载数据
    try {
      session.loadContent('livecardability/pages/MusicLiveCard', storage);
    } catch (error) {
      Logger.error(TAG, `loadContent catch error`);
    }

    // 异步加载持久化数据（loadContent 之后执行）
    this.loadMusicData(storage).catch((error: Error) => {
      Logger.error(TAG, `loadMusicData error: ${error.message}`);
    });
  }

  private async loadMusicData(storage: LocalStorage): Promise<void> {
    // 1. 读取触发动作（从文件存储，跨进程共享）
    let actionData = MusicFileStore.getTriggerAction(this.context);
    if (actionData) {
      storage.setOrCreate('triggerAction', actionData.triggerAction);
      MusicFileStore.clearTriggerAction(this.context);  // 清除已读数据
    }

    // 2. 从数据库加载歌曲列表
    let songRdbHelper = SongRdbHelper.getInstance(this.context);
    let initSongs: SongItem[] = await songRdbHelper.queryAllSongs();
    if (initSongs.length <= 0) {
      // 数据库为空，使用默认数据并写入
      initSongs = getSongListData();
      songRdbHelper.insertSongs(initSongs);
    }
    storage.setOrCreate('songList', initSongs);

    // 3. 读取当前歌曲和上一首歌曲（用于切歌动画）
    let previousSong: SongItem | undefined;
    if (actionData && (actionData.triggerAction === 'PREVIOUS' ||
      actionData.triggerAction === 'NEXT')) {
      previousSong = await songRdbHelper.querySongById(actionData.songId);
    }
    let currentSong = MusicFileStore.readCurrentSong(this.context);
    if (!currentSong) {
      currentSong = initSongs[0];
      MusicFileStore.writeCurrentSong(this.context, currentSong);
    }

    storage.setOrCreate('currentSong', currentSong);
    storage.setOrCreate('previousSong', previousSong);
  }
}
```

**⚠️ 关键约束**：`loadContent` 必须在 `onLiveFormCreate` 中同步调用。异步操作（读文件、查数据库）必须在 `loadContent` 之后执行，否则会导致白屏。数据加载完成后通过 `storage.setOrCreate` 更新已存在的 key，卡片 UI 通过 `@Watch` 或 `@StorageLink` 响应变化。

---

### 5. 卡片通信机制

#### ActionUtils.ets — 卡片端通信封装

```typescript
// ═══════ postCardAction 三种 action 类型 ═══════
//
// CALL:    调用 UIAbility 的 rpc 方法（callee.on 注册的处理器）
// MESSAGE: 发送消息到 FormExtensionAbility.onFormEvent
// ROUTER:  跳转应用到指定页面

class ActionUtils {

  // ═══ CALL：播放/切歌/暂停 ═══
  public playByAction(component: object, type: PlayActionType, formId: string): void {
    postCardAction(component, {
      action: FormCarAction.CALL,       // 调用 UIAbility
      abilityName: ENTRY_ABILITY,       // 目标 Ability 名称
      params: {
        method: 'cardAction',           // rpc 方法名（EntryAbility 中注册的）
        actionType: CardActionType.PLAY_ACTION,
        playActionType: type,           // PLAY / PAUSE / PREVIOUS / NEXT
        formId: formId,
      },
    });
  }

  // ═══ CALL：更新音乐控制卡片数据 ═══
  public updateControlCardAction(component: object, formId: string): void {
    postCardAction(component, {
      action: FormCarAction.CALL,
      abilityName: ENTRY_ABILITY,
      params: {
        method: 'cardAction',
        actionType: CardActionType.REQUEST_UPDATE,
        formId: formId,
      },
    });
  }

  // ═══ CALL：收藏/取消收藏 ═══
  public collectAction(component: object, type: string, formId: string, songId: string): void {
    postCardAction(component, {
      action: FormCarAction.CALL,
      abilityName: ENTRY_ABILITY,
      params: {
        method: 'cardAction',
        actionType: CardActionType.COLLECT_ACTION,
        collectActionType: type,        // COLLECTED / UNCOLLECTED
        formId: formId,
        songId: songId,
      },
    });
  }

  // ═══ MESSAGE：请求激活互动卡片 ═══
  public requestOverFlow(component: object, widthRatio: number,
    heightRatio: number, duration: number): void {
    postCardAction(component, {
      action: FormCarAction.MESSAGE,    // 发送到 FormExtensionAbility
      abilityName: ENTRY_FORM_ABILITY,  // EntryFormAbility
      params: {
        message: 'requestOverflow',     // onFormEvent 中匹配此 message
        widthRatio: widthRatio,         // 互动区域宽度占比
        heightRatio: heightRatio,       // 互动区域高度占比
        duration: duration              // 动画时长
      },
    });
  }

  // ═══ MESSAGE：带触发动作的互动卡片激活（音乐卡片用） ═══
  public requestOverFlowWithAction(component: object, widthRatio: number,
    heightRatio: number, duration: number,
    triggerAction: string, songId?: string): void {
    postCardAction(component, {
      action: FormCarAction.MESSAGE,
      abilityName: ENTRY_FORM_ABILITY,
      params: {
        message: 'requestOverflow',
        widthRatio: widthRatio,
        heightRatio: heightRatio,
        duration: duration,
        triggerAction: triggerAction,   // 'PLAY' | 'PREVIOUS' | 'NEXT'
        songId: songId || ''            // 切歌时传递当前歌曲 ID
      },
    });
  }

  // ═══ ROUTER：跳转应用到着陆页 ═══
  public jumpAppPage(component: object, pageName: string): void {
    postCardAction(component, {
      action: FormCarAction.ROUTER,     // 路由跳转
      abilityName: ENTRY_ABILITY,
      params: {
        routeName: pageName,            // 对应 route_map.json 中的 name
      },
    });
  }
}
```

#### CardActionHandler.ets — 应用端处理 CALL 事件

```typescript
class CardActionHandler {
  // 卡片通过 rpc CALL 调用 → callee.on('cardAction', handler)
  // → cardActionCall 被触发 → 解析参数 → 分发处理

  private cardActionCall = (data: rpc.MessageSequence): null => {
    let params: Record<string, string> = JSON.parse(data.readString());

    switch (params.actionType) {
      case CardActionType.PLAY_ACTION:
        // 播放控制：PLAY/PAUSE/PREVIOUS/NEXT
        this.handlePlayAction(params);
        break;
      case CardActionType.COLLECT_ACTION:
        // 收藏操作：更新数据库 + 更新卡片UI + 发送事件
        this.handleCollectAction(params);
        break;
      case CardActionType.REQUEST_UPDATE:
        // 请求更新音乐控制卡片数据
        this.handleRequestUpdate(params);
        break;
      case CardActionType.EXERCISE_ACTION:
        // 运动操作：开始/结束/重置
        this.handleExerciseAction(params);
        break;
    }
    return null;
  };
}
```

---

### 6. 从卡片到互动卡片的完整流程

以**睡眠卡片**为例，追踪用户点击触发起床动画的完整调用链：

```
步骤1: 用户在桌面看到睡眠静态卡片
      ┌──────────────────────┐
      │  SleepCard.ets        │
      │  显示 clover_sleep.png │
      │  文字 "呼呼大睡ing"    │
      └──────────────────────┘

步骤2: 用户点击卡片
      SleepCard.build() {
        .onClick(() => {
          if (this.isSleep) {
            // ⭐ 发送 MESSAGE 事件到 EntryFormAbility
            ActionUtils.requestOverFlow(
              this,
              LiveCardScale.SLEEP_WIDTH,   // 0.9
              LiveCardScale.SLEEP_HEIGHT,  // 0.9
              LIVE_CARD_DURATION           // 3500ms
            );
          }
        })
      }

步骤3: postCardAction 发送到系统
      postCardAction(this, {
        action: 'MESSAGE',
        abilityName: 'EntryFormAbility',
        params: {
          message: 'requestOverflow',
          widthRatio: 0.9,
          heightRatio: 0.9,
          duration: 3500
        }
      })

步骤4: 系统路由到 EntryFormAbility.onFormEvent()
      → 解析 message = 'requestOverflow'
      → 调用 this.requestOverflow(formId, 0.9, 0.9, 3500)

步骤5: requestOverflow 内部
      → formProvider.getFormRect(formId)     // 获取卡片屏幕坐标
      → 计算互动区域: width*0.9, height*0.9, 居中
      → formProvider.requestOverflow(formId, {
          area: { left, top, width, height },
          duration: 3500
        })

步骤6: 系统查找 form_config.json
      → 找到 SleepCard 的配置
      → sceneAnimationParams.abilityName = "SleepLiveCardAbility"
      → 激活 SleepLiveCardAbility

步骤7: SleepLiveCardAbility.onLiveFormCreate()
      → 创建 LocalStorage
      → 注入 formId, borderRadius, formRect
      → session.loadContent('livecardability/pages/SleepLiveCard', storage)

步骤8: SleepLiveCard.ets 渲染
      → aboutToAppear() 初始化帧序列累计时间
      → build() 显示背景 + 三叶草帧动画 + 憨憨帧动画
      → onAppear() 调用 startImageSync() 开始帧动画

步骤9: 帧动画执行 3500ms
      → 每 16ms 更新一次画面（~60fps）
      → 权重化帧序列：关键帧停留更久
      → 三叶草从睡觉→苏醒
      → 憨憨从闭眼→睁眼

步骤10: 用户点击互动卡片
       → 调用 formProvider.cancelOverflow(formId)
       → 互动卡片消失，回到静态卡片
```

---

### 7. 帧动画系统详解

#### SleepLiveCard.ets 权重化帧序列

```typescript
// ═══ FrameItem 类：每帧 + 权重 ═══
class FrameItem {
  public src: Resource;     // 帧图片资源
  public weight: number;    // 权重（持续时间倍数，默认1）

  constructor(src: Resource, weight: number = 1) {
    this.src = src;
    this.weight = weight;
  }
}

// ═══ 帧序列定义 ═══
// 权重 N 表示该帧的持续时间是普通帧的 N 倍
private hanhanFrames: FrameItem[] = [
  // 权重17：第一帧持续 17 倍时长（开始姿势停留久）
  new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame01-17.png'), 17),
  // 权重1：正常速度的过渡帧
  new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame18.png')),
  // ... 中间帧 ...
  // 权重11：中间姿势停留久
  new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame28-38.png'), 11),
  // ... 后续帧 ...
  // 权重2.5：末尾多处停顿
  new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame47.png'), 2.5),
  // ... 直到最后一帧
];

// ═══ 构建累计时间数组 ═══
private buildCumulativeTime(frames: FrameItem[]): number[] {
  // 1. 计算总权重
  const totalWeight = frames.reduce(
    (sum: number, f: FrameItem) => sum + f.weight, 0
  );
  // 2. 按比例分配总时长 LIVE_CARD_DURATION(3500ms) 到每帧
  let cumulative = [0];
  for (let i = 0; i < frames.length; i++) {
    cumulative.push(
      cumulative[i] + frames[i].weight / totalWeight * LIVE_CARD_DURATION
    );
  }
  // 例: 权重17的帧占 17/totalWeight * 3500ms ≈ 快速前进，后续均匀分布
  return cumulative;
  // 返回: [0, 150, 165, 180, ..., 3500]
}

// ═══ 根据已过时间查找当前帧 ═══
private getFrameByElapsed(elapsed: number, cumulativeTime: number[],
  totalFrames: number): number {
  // elapsed: 从动画开始到现在的毫秒数
  // cumulativeTime: 每帧结束的时间点
  // 例: elapsed=160ms → 查找 cumulativeTime[i] > 160 → 返回 i-1
  for (let i = 1; i < cumulativeTime.length; i++) {
    if (elapsed < cumulativeTime[i]) {
      return i - 1;
    }
  }
  return totalFrames - 1;  // 超时返回最后一帧
}

// ═══ 启动帧同步定时器 ═══
startImageSync(): void {
  this.stopCoverSync();  // 先停止之前的定时器
  this.animStartTime = Date.now();  // 记录动画开始时间

  // 每 16ms（约60fps）更新一次
  this.imageSyncTimer = setInterval(() => {
    const elapsed = Date.now() - this.animStartTime;  // 已过时间

    // 动画结束
    if (elapsed >= LIVE_CARD_DURATION) {
      this.currentHanhanFrameIndex = this.hanhanFrames.length - 1;
      this.currentCloverFrameIndex = this.cloverFrames.length - 1;
      clearInterval(this.imageSyncTimer);
      return;
    }

    // 计算当前帧索引
    const newHanhanFrame = this.getFrameByElapsed(
      elapsed, this.hanhanCumulativeTime, this.hanhanFrames.length
    );
    const newCloverFrame = this.getFrameByElapsed(
      elapsed, this.cloverCumulativeTime, this.cloverFrames.length
    );

    // 只在帧变化时更新状态（减少无效渲染）
    if (newHanhanFrame > this.currentHanhanFrameIndex) {
      this.currentHanhanFrameIndex = newHanhanFrame;
      // 当憨憨帧超过第19帧时，切换到"起床"状态
      if (this.currentHanhanFrameIndex >= this.hanhanSleepFrameIndex) {
        this.isSleep = false;
      }
    }
    if (newCloverFrame > this.currentCloverFrameIndex) {
      this.currentCloverFrameIndex = newCloverFrame;
    }
  }, 16);
}

// ═══ 渲染 ═══
build() {
  Stack() {
    // 三叶草层（背景）
    Image(this.cloverFrames[this.currentCloverFrameIndex].src)
      .objectFit(ImageFit.Cover)
      .width('100%').height('100%');

    // 憨憨层（前景，偏移到左下角）
    Image(this.hanhanFrames[this.currentHanhanFrameIndex].src)
      .objectFit(ImageFit.Contain)
      .width('130%')
      .height('150%')
      .offset({ x: '-20%', y: '-25%' })  // 偏移露出左下角
  }
}
```

#### MusicLiveCard.ets Canvas 帧动画

```typescript
// ═══ Canvas 初始化 ═══
private canvasSettings: RenderingContextSettings =
  new RenderingContextSettings(true);
private canvasContext: CanvasRenderingContext2D =
  new CanvasRenderingContext2D(this.canvasSettings);

// ═══ 关键帧绘制 ═══（定义每帧中专辑封面的位置/旋转/缩放）
// COVER_CONFIGS = [
//   { x: 10, y: 20, rotateX: 0,  rotateY: 0,  rotateZ: 15, scale: 1.0, visible: true },
//   { x: 15, y: 25, rotateX: 5,  rotateY: 0,  rotateZ: 30, scale: 0.9, visible: true },
//   // ... 数十帧覆盖配置 ...
// ]

private drawCanvasFrame(): void {
  const ctx = this.canvasContext;
  ctx.clearRect(0, 0, canvasW, canvasH);  // 清空画布

  const config = this.getCurrentCoverConfig();  // 获取当前帧的封面配置

  if (config.visible) {
    // 计算专辑封面尺寸和位置
    const albumSize = this.canvasHeight * 0.3;
    const albumX = this.canvasWidth * config.x / 100;
    const albumY = this.canvasHeight * config.y / 100;

    // Canvas 2D 变换：平移 → 旋转(XYZ) → 缩放
    ctx.save();
    ctx.translate(centerX, centerY);              // 平移到封面中心
    ctx.transform(                                // Z轴旋转 + 缩放
      Math.cos(radZ) * config.scale,              // a
      Math.sin(radZ) * config.scale,              // b
      -Math.sin(radZ) * config.scale,             // c
      Math.cos(radZ) * config.scale,              // d
      0, 0
    );
    ctx.scale(Math.cos(radY), Math.cos(radX));    // X/Y轴透视缩放（模拟3D）

    // 圆形裁剪
    ctx.beginPath();
    ctx.arc(0, 0, albumSize / 2, 0, Math.PI * 2);
    ctx.clip();

    // 绘制专辑封面
    const albumImage = this.cachedAlbumImage ?? ImageUtils.getImageBitmapByMediaResource(...);
    ctx.drawImage(albumImage, -albumSize / 2, -albumSize / 2, albumSize, albumSize);
    ctx.restore();
  }

  // 绘制关键帧图片（人物动画层，叠加在专辑封面之上）
  const frameImage = ImageUtils.getImageBitmapByRawfileResource(...);
  ctx.drawImage(frameImage, offsetX, offsetY, canvasW, canvasH);
}
```

---

### 8. 快递卡片 — 陀螺仪交互

#### DeliveryLiveCard.ets 陀螺仪 + 动画

```typescript
// ═══ 陀螺仪数据订阅 ═══
subscribeGyroscope() {
  GyroscopeUtil.subscribe((data: GyroscopeData) => {
    // 陀螺仪返回 x, y, z 三轴角速度
    // 限制在 [-2.0, 2.0] 范围内防止过度响应
    this.gyroTranslateX = Math.max(-this.maxGyroValue,
      Math.min(this.maxGyroValue, data.y));  // 左右倾斜
    this.gyroTranslateY = Math.max(-this.maxGyroValue,
      Math.min(this.maxGyroValue, data.x));  // 前后倾斜
    this.gyroTranslateZ = Math.max(-this.maxGyroValue,
      Math.min(this.maxGyroValue, data.z));  // 旋转

    this.gyroMethod();  // 更新憨憨位置
  });
}

// ═══ 憨憨位置计算 ═══
private gyroMethod() {
  const clampedY = this.gyroTranslateX;  // 左右倾斜 → 左右移动
  const clampedZ = this.gyroTranslateZ;  // 旋转分量 → 抵消漂移

  // 累积偏移量（带灵敏度调节）
  this.accumulatedY += (clampedY - clampedZ) * this.sensitivity;  // 0.05
  this.accumulatedY = Math.max(-1, Math.min(1, this.accumulatedY));  // 限制范围

  // 节流：16ms 更新一次（约60fps）
  const now = Date.now();
  if (now - this.lastUpdateTime < this.updateInterval) return;
  this.lastUpdateTime = now;

  this.updateBallPosition();  // 更新目标位置
  this.animateBall(0);        // 立即应用（无动画过渡）
}

// ═══ 憨憨位置映射 ═══
private updateBallPosition(): void {
  const normalizedValue = this.accumulatedY;

  if (normalizedValue > this.threshold) {        // 向右倾斜
    const t = Math.min((normalizedValue - this.threshold) / (1 - this.threshold), 1);
    this.targetBallX = t * 100;        // 憨憨向右移动（0→100）
    this.targetBallSize = 1 - t * 0.35; // 憨憨略微缩小
  } else if (normalizedValue < -this.threshold) { // 向左倾斜
    const t = Math.min((-normalizedValue - this.threshold) / (1 - this.threshold), 1);
    this.targetBallX = -t * 50;        // 憨憨向左移动（0→-50）
    this.targetBallSize = 1 + t * 0.3;  // 憨憨略微放大
  } else {                             // 水平位置
    this.targetBallX = 0;
    this.targetBallSize = 1;
  }
}

// ═══ 入场动画（keyframeAnimateTo） ═══
// 憨憨从卡片中心 → 驶出左边界 → 反弹回到中心
startDriveIn(): void {
  this.getUIContext().keyframeAnimateTo({
    iterations: 1,
    onFinish: () => {
      this.subscribeGyroscope();  // 入场动画结束后开始陀螺仪控制
      this.startDriveIn();        // 反弹回中心
    }
  }, [
    { // 第1段：驶出（800ms）
      duration: 800,
      curve: Curve.EaseInOut,
      event: () => {
        this.ballTranslateX = -(this.rect?.width ?? 400) * 0.2;  // 向左20%
        this.ballSize = 1.5;  // 放大1.5倍
      }
    },
    { // 第2段：停顿（300ms）
      duration: 300,
      curve: Curve.Friction,
      event: () => {}
    }
  ]);
}
```

---

### 9. 着陆页（详情页）

#### Index.ets — 主页

```typescript
@Entry
@Component
struct Index {
  private pathStack: NavPathStack = RouterUtil.getInstance().getPathStack();
  // NavPathStack: HarmonyOS 声明式导航栈

  build() {
    Navigation(this.pathStack) {
      RootComponent();  // 主内容
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    // ↑ 扩展到系统安全区（状态栏+导航栏）
    .backgroundColor(ColorConstants.INDEX_BG)
    .hideTitleBar(true)                // 隐藏导航标题栏
    .mode(NavigationMode.Stack);       // 栈式导航模式
  }
}

@Component
struct RootComponent {
  // ═══ 状态管理 ═══
  @State isLandscape: boolean = false;  // 横竖屏状态（通过 onAreaChange 检测）
  @State cardInfoList: CardItemConfig[] = CARD_ITEM_CONFIGS;
  @State defaultConfig: CardItemConfig = CARD_ITEM_CONFIGS[0];

  // ═══ 多端适配：onAreaChange 检测横竖屏 ═══
  // 当容器尺寸变化时（旋转屏幕），更新 isLandscape 状态
  // GridRow 根据当前窗口宽度断点自动切换列数
  build() {
    Column() {
      HeaderSection(...);
      Scroll() {
        Column() {
          this.CardList();  // 卡片网格
        }
        .constraintSize({ maxWidth: 960 });  // 平板最大宽度限制
      }
    }
    .onAreaChange((oldArea: Area, newArea: Area) => {
      // ⭐ 容器尺寸变化 → 检测横竖屏
      const w = newArea.width as number;
      const h = newArea.height as number;
      if (w > 0 && h > 0) {
        this.isLandscape = w > h;
      }
    })
  }

  // ═══ 卡片列表 GridRow ═══
  @Builder
  CardList() {
    GridRow({
      // 断点系统：自动根据屏幕宽度选择列数
      columns: { xs: 2, md: 4, lg: 6 },
      // xs(<320vp): 2列  md(320-600vp): 4列  lg(>840vp): 6列
      gutter: 12
    }) {
      ForEach(this.cardInfoList, (config: CardItemConfig) => {
        GridCol({ span: config.span, offset: config.offset }) {
          Image(config.mainImg)
            .width('100%')
            .objectFit(ImageFit.Contain)
            .constraintSize({ maxHeight: this.isLandscape ? 180 : 320 })
            // ↑ 横屏时限制卡片高度，防止被压扁
            .bindContextMenu(this.CardAddMenu, ResponseType.LongPress, {...});
            // ↑ 长按弹出"添加到桌面"菜单
        }
      })
    }
  }
}
```

#### SleepReportPageView.ets — 睡眠报告页

```typescript
@Component
struct SleepReportPageViewWithBg {
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;

  build() {
    NavDestination() {
      // ⭐ 多端适配：宽屏时使用左右分栏布局
      if (this.windowInfo !== undefined &&
        this.windowInfo.widthBp > WidthBreakpoint.WIDTH_MD) {
        // 宽屏（平板横屏）：背景图满屏 + 37.5%宽的内容面板
        Stack({ alignContent: Alignment.Top }) {
          Image($r('app.media.sleep_report_bg'))
            .width('100%').objectFit(ImageFit.Contain);

          Column()  // 半透明遮罩
            .width('100%').height('100%')
            .backgroundColor(ColorConstants.OVERLAY_MEDIUM);

          Stack({ alignContent: Alignment.Bottom }) {
            SleepReportPageView();  // 内容面板
          }
          .width('37.5%')  // ⭐ 只占37.5%宽度
          .height('100%');
        }
      } else {
        // 窄屏（手机）：直接全宽显示
        SleepReportPageView();
      }
    }
    .backgroundColor(ColorConstants.BACKGROUND_LIGHT)
    .hideTitleBar(true);
  }
}

@Component
struct SleepReportPageView {
  // 包含：睡眠时长统计卡、阶段图表、心率、分析卡
  build() {
    NavDestination() {
      Column() {
        HeaderSection($r('app.string.sleep_title'));
        this.TimeTabSection();   // 日/周/月/年 切换
        Scroll() {              // ⭐ Scroll 确保横屏高度不够时可滚动
          Column() {
            this.SleepDataCard();
            this.AnalysisCard();
          }
        }
        .layoutWeight(1)        // 占据剩余空间
        .scrollBar(BarState.Off);
        this.BottomAction();    // 底部操作按钮
      }
      .constraintSize({ maxWidth: 960 })  // ⭐ 平板居中
    }
  }
}
```

#### MusicPageView.ets — 音乐播放页（双栏 Swiper）

```typescript
// ═══ MusicPageView: 入口容器 ═══
@Builder
export function MusicPageViewBuilder() {
  MusicPageView();
}

@Component
struct MusicPageView {
  @StorageProp(Constants.KEY_WINDOW_UTIL) windowUtil?: WindowUtil = undefined;
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;

  build() {
    NavDestination() {
      PlayerView({
        imageColor: this.imageColor,      // 背景色（从封面提取）
        mainWindowInfo: this.windowInfo    // 窗口信息
      })
    }
    .backgroundColor(this.imageColor)  // 背景色跟随专辑封面
    .hideTitleBar(true);
  }
}

// ═══ PlayerView: 播放器主体 ═══
@Component
export struct PlayerView {
  @ObjectLink mainWindowInfo: WindowInfo;  // 双向绑定窗口信息

  // ⭐ 多端适配：判断是否使用双栏布局
  private useTwoPane(): boolean {
    return this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM  // 宽度>小屏
      || this.isLandscape();  // 或者是横屏（即使小屏也双栏）
  }

  // 判断横竖屏
  private isLandscape(): boolean {
    return this.mainWindowInfo.windowSize.width >
      this.mainWindowInfo.windowSize.height;
  }

  build() {
    Stack() {
      Row() {
        Stack({ alignContent: Alignment.TopStart }) {
          // 模糊背景图
          Image(this.imageLabel)
            .width('100%').height('100%')
            .objectFit(ImageFit.Cover)
            .opacity(0.5);

          // ⭐ Swiper 双栏布局
          Swiper() {
            MusicInfo({ mainWindowInfo: this.mainWindowInfo });     // 封面+信息页
            PlayerLyrics({ mainWindowInfo: this.mainWindowInfo });  // 歌词页
          }
          .displayCount(this.useTwoPane() ? 2 : 1)  // ⭐ 双栏或单栏
          .indicator(!this.useTwoPane() ?            // 单栏时显示指示器
            new DotIndicator()... : false)
        }
      }
    }
    .backgroundColor(this.imageColor);
  }
}
```

---

### 10. 工具层

#### RouterUtil.ets — 路由管理

```typescript
export default class RouterUtil {
  private static instance: RouterUtil | undefined = undefined;
  private pathStack: NavPathStack = new NavPathStack();
  // ⭐ NavPathStack: 声明式导航栈，与 Navigation 组件配合使用

  static getInstance(): RouterUtil {
    if (RouterUtil.instance === undefined) {
      RouterUtil.instance = new RouterUtil();
    }
    return RouterUtil.instance;
  }

  getPathStack(): NavPathStack {
    return this.pathStack;
  }

  // ═══ 跳转页面 ═══
  pushPage(name: string): void {
    this.currentPageName = name;
    // replacePath: 替换当前栈顶（因为主页一直在栈底）
    this.pathStack.replacePath({ name: name, param: [] });
    // 系统根据 name 在 route_map.json 中查找对应的 @Builder
  }

  // ═══ 关闭应用（最小化到后台） ═══
  async closeApp(): Promise<void> {
    let context = AppStorage.get(Constants.KEY_CONTEXT) as common.UIAbilityContext;
    let mainWindow = context.windowStage.getMainWindowSync();
    await mainWindow.minimize();  // 最小化窗口
  }
}
```

#### WindowUtil.ets — 窗口管理与多端适配

```typescript
@Observed
export class WindowUtil {
  public uiContext?: UIContext;
  public mainWindow: window.Window;
  public mainWindowInfo: WindowInfo = new WindowInfo();

  constructor(mainWindow: window.Window) {
    this.mainWindow = mainWindow;
    // ⭐ 立即检测初始横竖屏状态，确保页面首次渲染正确
    try {
      const rect = mainWindow.getWindowProperties().windowRect;
      AppStorage.setOrCreate(Constants.KEY_IS_LANDSCAPE, rect.width > rect.height);
    } catch (err) {
      Logger.error(TAG, `Failed to init landscape in constructor.`);
    }
  }

  // ═══ 窗口尺寸变化回调 ═══
  public onWindowSizeChange: (windowSize: window.Size) => void =
    (windowSize: window.Size) => {
      // 更新 WindowInfo 对象属性
      this.mainWindowInfo.windowSize = windowSize;  // 窗口像素尺寸
      if (this.uiContext) {
        this.mainWindowInfo.widthBp =
          this.uiContext.getWindowWidthBreakpoint();   // 宽度断点
        this.mainWindowInfo.heightBp =
          this.uiContext.getWindowHeightBreakpoint();  // 高度断点
      }
      // 将断点存入 AppStorage（供 @StorageLink/@StorageProp 绑定）
      AppStorage.setOrCreate(Constants.KEY_WIDTH_BP, this.mainWindowInfo.widthBp);
      AppStorage.setOrCreate(Constants.KEY_HEIGHT_BP, this.mainWindowInfo.heightBp);
      AppStorage.setOrCreate(Constants.KEY_IS_LANDSCAPE,
        windowSize.width > windowSize.height);
    };

  // ═══ 初始化窗口信息 ═══
  updateWindowInfo(): void {
    // 注册窗口状态变化事件
    this.mainWindow.on('windowStatusChange', this.onStatusTypeChange);

    // 读取当前窗口尺寸
    let width = this.mainWindow.getWindowProperties().windowRect.width;
    let height = this.mainWindow.getWindowProperties().windowRect.height;
    let windowSize: window.Size = { width: width, height: height };
    this.mainWindowInfo.windowSize = windowSize;

    // 获取当前断点
    if (this.uiContext) {
      this.mainWindowInfo.widthBp = this.uiContext.getWindowWidthBreakpoint();
      this.mainWindowInfo.heightBp = this.uiContext.getWindowHeightBreakpoint();
    }

    // 存入 AppStorage
    AppStorage.setOrCreate(Constants.KEY_WIDTH_BP, this.mainWindowInfo.widthBp);
    AppStorage.setOrCreate(Constants.KEY_HEIGHT_BP, this.mainWindowInfo.heightBp);
    AppStorage.setOrCreate(Constants.KEY_IS_LANDSCAPE, windowSize.width > windowSize.height);

    // ⭐ 注册窗口尺寸变化监听
    this.mainWindow.on('windowSizeChange', this.onWindowSizeChange);

    // 注册安全区变化监听
    this.mainWindow.on('avoidAreaChange', this.onAvoidAreaChange);
  }

  // ═══ 释放资源 ═══
  release(): void {
    this.mainWindow.off('windowStatusChange');
    this.mainWindow.off('windowSizeChange');
    this.mainWindow.off('avoidAreaChange');
  }
}

// ═══ WindowInfo 数据模型 ═══
@Observed
export class WindowInfo {
  public windowStatusType: window.WindowStatusType =
    window.WindowStatusType.UNDEFINED;  // 全屏/分屏/浮窗
  public orientation: window.Orientation =
    window.Orientation.UNSPECIFIED;      // 横屏/竖屏/反转
  public windowSize: window.Size =
    { width: 0, height: 0 };            // 窗口像素尺寸
  public widthBp: WidthBreakpoint =
    WidthBreakpoint.WIDTH_XS;           // 宽度断点（xs/sm/md/lg/xl）
  public heightBp: HeightBreakpoint =
    HeightBreakpoint.HEIGHT_SM;         // 高度断点
  public avoidSystem?: window.AvoidArea;              // 系统栏避让区
  public avoidNavigationIndicator?: window.AvoidArea; // 导航指示条避让区
  public avoidCutout?: window.AvoidArea;              // 挖孔屏避让区
  public avoidKeyboard?: window.AvoidArea;            // 键盘避让区
}

// ═══ ArkUI 宽度断点定义 ═══
// WidthBreakpoint.WIDTH_XS:  < 320vp    (极小屏)
// WidthBreakpoint.WIDTH_SM:  320-600vp  (小屏/手机竖屏)
// WidthBreakpoint.WIDTH_MD:  600-840vp  (中屏/手机横屏/小平板)
// WidthBreakpoint.WIDTH_LG:  > 840vp    (大屏/平板横屏)
```

---

## 多端部署

### 设计原则

本项目采用 **响应式布局 + 断点系统 + 横竖屏自适应** 实现多端部署。核心原则：

1. **不用固定像素**，使用百分比宽度和 `constraintSize` 限制最大宽度
2. **GridRow 断点系统**自动适配列数（xs=2, md=4, lg=6）
3. **Scroll 容器**确保低高度（横屏手机）时内容可滚动
4. **onAreaChange** 检测容器尺寸变化，更新横竖屏状态
5. **constraintSize(maxWidth)** 限制平板上的最大内容宽度

### 各设备/朝向的首页布局

| 场景 | 典型分辨率(vp) | 宽度断点 | GridRow列数 | 卡片排列 | isLandscape | 卡片maxHeight |
|------|--------------|---------|-------------|---------|-------------|---------------|
| 手机竖屏 | 393×852 | xs/sm | **2列** (xs) | Music占满行 / Exercise+Delivery并排 / Sleep占满行 | `false` | 320 |
| 手机横屏 | 852×393 | lg | **6列** (lg) | 卡片按offset居中排列 | `true` | **180** |
| 平板竖屏 | 768×1024 | md | **4列** (md) | 卡片按offset居中排列 | `false` | 320 |
| 平板横屏 | 1024×768 | lg | **6列** (lg) | 卡片按offset居中排列 | `true` | **180** |

### 详情页的多端适配策略

| 页面 | 手机竖屏 | 手机横屏 | 平板竖屏 | 平板横屏 |
|------|---------|---------|---------|---------|
| 睡眠报告 | 全宽 + Scroll | 全宽 + Scroll | 宽屏分栏(37.5%)+背景 | 宽屏分栏+背景 |
| 三叶草 | 1列 + Scroll | 2列 + Scroll | 2列 + maxWidth960 | 3列 + maxWidth960 |
| 快递详情 | 全宽 + Sheet 60% | 全宽 + Sheet 86% | 侧边栏 50% | 侧边栏 33% |
| 运动记录 | 全宽 + Scroll | 全宽 + Scroll | maxWidth960 + Scroll | maxWidth960 + Scroll |
| 音乐播放 | Swiper单栏 | Swiper双栏 | Swiper双栏 | Swiper双栏 |
| 天气 | Scroll + maxWidth640 | Scroll + maxWidth640 | Scroll + maxWidth640 | Scroll + maxWidth640 |

### 多端适配关键代码位置

| 功能 | 文件 | 行号/位置 |
|------|------|----------|
| 设备类型声明 | `module.json5` | `deviceTypes: ["phone", "tablet", "2in1"]` |
| GridRow 断点列数 | `Index.ets` | `columns: { xs: 2, md: 4, lg: 6 }` |
| 横竖屏检测 | `Index.ets` | `onAreaChange` 回调中 `w > h` |
| 横屏卡片高度限制 | `Index.ets` | `constraintSize({ maxHeight: this.isLandscape ? 180 : 320 })` |
| 平板最大宽度 | `Index.ets` | `constraintSize({ maxWidth: 960 })` |
| 窗口断点管理 | `WindowUtil.ets` | `updateWindowInfo()` / `onWindowSizeChange` |
| 宽屏分栏布局 | `SleepReportPageView.ets` | `widthBp > WIDTH_MD` 时 37.5% 侧栏 |
| 横屏Sheet高度 | `DeliveryPageView.ets` | 横屏 86% / 竖屏 60% |
| Swiper双栏 | `PlayerView.ets` | `useTwoPane()` 判断逻辑 |
| 封面尺寸适配 | `MusicInfo.ets` | `isLandscape() ? 240 : 300` |
| 详情页Scroll | 所有详情页 | `Scroll()` + `layoutWeight(1)` 确保可滚动 |

### 多端适配验证清单

- [ ] 手机竖屏：GridRow 2列、卡片maxHeight 320、详情页全宽
- [ ] 手机横屏：GridRow 6列、卡片maxHeight 180、详情页可滚动
- [ ] 平板竖屏：GridRow 4列、内容 maxWidth 960 居中
- [ ] 平板横屏：GridRow 6列、睡眠报告分栏、快递侧边栏
- [ ] 折叠屏展开/折叠：断点自动切换，布局无缝过渡
- [ ] 二合一设备：触屏+键盘模式均正确显示

---

## 自由流转

### 概述

自由流转（Continuation）是 HarmonyOS 的核心分布式能力，允许用户在不同设备间无缝迁移正在进行的任务。本项目已实现基础的自由流转支持。

### 配置

```json5
// module.json5 中的关键配置
{
  "abilities": [
    {
      "name": "LiveCardAbility",
      "continuable": true  // ⭐ 启用自由流转
    }
  ]
}
```

### 实现

```typescript
// EntryAbility.ets
export default class EntryAbility extends UIAbility {

  // ⭐ onContinue: 任务接续时保存状态
  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    // 保存当前页面路由名称
    const routeName = RouterUtil.getInstance().getCurrentPageName();
    if (routeName) {
      wantParam.routeName = routeName;
    }
    Logger.info(TAG, `onContinue routeName: ${routeName}`);
    return AbilityConstant.OnContinueResult.AGREE;  // 同意接续
  }

  // ⭐ onNewWant: 恢复任务时读取状态
  onNewWant(want: Want): void {
    // want.parameters.routeName 包含接续时的页面路由
    RouterUtil.getInstance().openPageByWant(want);
  }
}

// RouterUtil.ets
openPageByWant(want: Want): void {
  if (want.parameters && want.parameters.routeName) {
    let routeName = want.parameters.routeName as string;
    this.pushPage(routeName);  // 恢复到接续前的页面
  }
}
```

### 流转场景

```
设备A(手机)                          设备B(平板)
─────────                          ─────────
用户正在听音乐                       
→ MusicPage 显示中                  
                                   
触发流转（上滑屏幕底部/多设备入口）     
                                   
onContinue:                        系统创建应用实例
  保存 routeName = "MusicPage"      → onCreate()
                                      → onNewWant({
                                          routeName: "MusicPage"
                                        })
                                      → RouterUtil.pushPage("MusicPage")
                                        → 平板自动显示音乐播放页
                                        → MediaService 继续播放当前歌曲
```

### 卡片在自由流转中的角色

卡片（Form）不参与自由流转——卡片是桌面级别的组件，在不同设备上独立添加和管理。但应用的着陆页状态可以通过自由流转在设备间迁移。

**流转场景示例**：
1. 手机上看运动记录 → 流转到平板 → 平板自动打开 ExercisePage
2. 手机上看快递详情 → 流转到平板 → 平板自动打开 DeliveryPage，侧边栏布局展示
3. 手机听音乐（MusicPage） → 流转到平板 → MediaService 恢复播放，音乐不断

---

## 约束与限制

1. 本示例仅支持标准系统运行，支持设备：直板机、双折叠、三折叠、阔折叠、平板。
2. 操作系统：HarmonyOS 6.1.0 Release 及以上。
3. IDE版本：DevEco Studio 6.1.0 Release 及以上。
4. HarmonyOS SDK版本：6.1.0 或更高版本。
5. `loadContent` 必须在 `onLiveFormCreate` 中同步调用，异步操作应在 `loadContent` 之后执行，否则导致白屏。
6. 互动卡片单个 `LiveFormExtensionAbility` 实例限制 10MB 内存，超限会被系统终止。
7. 帧动画素材不宜过大，Image 加载耗时可能导致丢帧。
8. 卡片与应用分属不同进程，LocalStorage 无法跨进程共享，须通过文件存储/数据库传递数据。

---

## 相关权限

| 权限 | 用途 |
|------|------|
| `ohos.permission.KEEP_BACKGROUND_RUNNING` | 音乐后台播放（长时任务） |
| `ohos.permission.GYROSCOPE` | 陀螺仪传感器（快递卡片憨憨交互） |

---

## 参考链接

- [场景动效类型互动卡片实现原理](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-ui-liveform-sceneanimation-overview)
- [HarmonyOS 多端部署指南](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-ui-multidevice)
- [HarmonyOS 自由流转指南](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-ui-continuation)
- [LiveFormExtensionAbility](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-app-form-liveFormExtensionAbility)
- [formProvider API](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-app-form-formProvider)
