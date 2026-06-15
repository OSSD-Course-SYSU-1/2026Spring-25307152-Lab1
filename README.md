# 互动卡片
## 项目简介
本项目是一个 HarmonyOS 互动卡片（Live Form）演示项目，展示了如何使用 HarmonyOS
的互动卡片能力。项目包含四种不同场景的互动卡片示例，每种卡片都具备独特的动画效果和交互体验：
- **睡眠卡片**：三叶草动画，展示睡眠健康数据
- **快递卡片**：陀螺仪驱动的憨憨动画
- **运动卡片**：卡路里燃烧动画与运动状态切换
- **音乐卡片**：专辑封面跟随动画帧同步移动的特效
本项目旨在帮助开发者理解 HarmonyOS 互动卡片的开发模式、动画实现方式以及卡片与应用间的通信机制。
## 效果预览
|                 睡眠卡片                 |                     运动卡片                      |                     运动卡片                      |
|:------------------------------------:|:---------------------------------------------:|:---------------------------------------------:|
|               三叶草起床动画                |                    开始运动动画                     |                    结束运动动画                     |
| ![Sleep](screenshots/sleep_card.gif) | ![Exercise](screenshots/exercise_card_01.gif) | ![Exercise](screenshots/exercise_card_02.gif) |
|                    快递卡片                    |                  音乐卡片                   |                  音乐卡片                   |
|:------------------------------------------:|:---------------------------------------:|:---------------------------------------:|
|                 陀螺仪控制憨憨移动                  |                 音乐播放动画                  |                 音乐切歌动画                  |
| ![Delivery](screenshots/delivery_card.gif) | ![Music](screenshots/music_card_01.gif) | ![Music](screenshots/music_card_02.gif) |
## 使用说明
### 添加卡片到桌面
1. 运行应用后进入主页
2. 长按卡片预览图
3. 选择"添加到桌面"
### 触发动画交互
| 卡片类型 | 触发方式              |
|---------|-------------------|
| 睡眠卡片 | 点击卡片切换入睡/起床动画     |
| 快递卡片 | 点击触发溢出动画 |
| 运动卡片 | 点击"开始运动"/"结束运动"按钮 |
| 音乐卡片 | 点击播放/上一首/下一首按钮    |
### 卡片跳转落地页
点击卡片空白区域或特定按钮可跳转到应用内详情页面：
- 睡眠卡片 → 三叶草页面 / 睡眠报告页面
- 快递卡片 → 快递详情页面
- 运动卡片 → 运动记录页面
- 音乐卡片 → 音乐播放页面
## 工程目录
```
entry/src/main/
│
├── ets/
│   ├── common/                    # 常量配置
│   │   ├── ColorConstants.ets
│   │   └── CommonConstants.ets
│   │
│   ├── database/                  # 数据存储
│   │   ├── FileStore.ets          # 文件存储抽象基类
│   │   ├── MusicFileStore.ets     # 音乐卡片文件存储
│   │   ├── ExerciseFileStore.ets  # 运动卡片文件存储
│   │   ├── FormRdbHelper.ets      # 表单数据库
│   │   ├── PreferencesUtil.ets    # 首选项存储
│   │   ├── RdbUtils.ets           # 数据库工具
│   │   └── SongRdbHelper.ets      # 歌曲数据库
│   │
│   ├── entryability/
│   │   └── EntryAbility.ets       # 主Ability
│   │
│   ├── entrybackupability/
│   │   └── EntryBackupAbility.ets # 备份恢复能力
│   │
│   ├── entryformability/
│   │   └── EntryFormAbility.ets   # 卡片管理（处理卡片事件）
│   │
│   ├── livecardability/           # 互动卡片能力（核心）
│   │   ├── pages/                 # 互动卡片UI
│   │   │   ├── DeliveryLiveCard.ets
│   │   │   ├── ExerciseLiveCard.ets
│   │   │   ├── MusicLiveCard.ets
│   │   │   └── SleepLiveCard.ets
│   │   ├── DeliveryLiveCardAbility.ets
│   │   ├── ExerciseLiveCardAbility.ets
│   │   ├── MusicLiveCardAbility.ets
│   │   └── SleepLiveCardAbility.ets
│   │
│   ├── lyric/                     # 歌词组件
│   │   ├── LrcEntry.ets           # 歌词数据结构
│   │   ├── LrcUtils.ets           # 歌词解析工具
│   │   ├── LrcView.ets            # 歌词渲染组件
│   │   └── LyricConst.ets         # 歌词常量
│   │
│   ├── model/                     # 数据模型
│   │   ├── common/
│   │   │   ├── FormCardConstant.ets  # 表单卡片常量
│   │   │   ├── FormInfo.ets          # 表单信息
│   │   │   └── NavInfo.ets           # 导航信息
│   │   ├── delivery/
│   │   │   └── DeliveryConstant.ets  # 快递常量
│   │   ├── exercise/
│   │   │   ├── ExerciseCardConstant.ets # 运动卡片常量
│   │   │   └── ExerciseModel.ets     # 运动数据模型
│   │   ├── music/
│   │   │   ├── FormControlData.ets   # 表单控制数据
│   │   │   ├── MusicConstants.ets    # 音乐常量
│   │   │   ├── MusicData.ets         # 音乐数据类型
│   │   │   ├── MusicLiveCardConstant.ets # 音乐卡片动画配置
│   │   │   └── SongItem.ets          # 歌曲数据模型
│   │   ├── sleep/
│   │   │   └── SleepConstants.ets    # 睡眠常量
│   │   └   CardConstant.ets       # 卡片通用常量
│   │
│   ├── pages/
│   │   └── Index.ets              # 主页（卡片列表）
│   │
│   ├── utils/                     # 工具类
│   │   ├── ActionUtils.ets        # 卡片通信桥梁
│   │   ├── BackgroundUtil.ets     # 后台任务管理
│   │   ├── CardActionHandler.ets  # 卡片动作处理
│   │   ├── DateFormatter.ets      # 国际化日期格式化
│   │   ├── FormUtils.ets          # 卡片数据更新
│   │   ├── GyroscopeUtil.ets      # 陀螺仪订阅
│   │   ├── ImageUtils.ets         # 图片处理
│   │   ├── Logger.ets             # 日志工具
│   │   ├── MediaTools.ets         # 媒体工具
│   │   ├── RouterUtil.ets         # 路由工具
│   │   └── WindowUtil.ets         # 窗口工具
│   │
│   ├── view/                      # 落地页视图
│   │   ├── common/                # 公共组件
│   │   │   └   HeaderSection.ets
│   │   ├── delivery/              # 快递详情页
│   │   │   └   DeliveryPageView.ets
│   │   ├── exercise/              # 运动记录页
│   │   │   ├── DetailStatItem.ets
│   │   │   ├── ExercisePageView.ets
│   │   │   ├── OverviewStatItem.ets
│   │   │   ├── SelectorItem.ets
│   │   │   └   StatsGrid.ets
│   │   ├── music/                 # 音乐播放页
│   │   │   ├── MusicInfo.ets
│   │   │   ├── MusicPageView.ets
│   │   │   ├── PlayerControlArea.ets
│   │   │   ├── PlayerLyrics.ets
│   │   │   └   PlayerView.ets
│   │   └── sleep/                 # 睡眠报告页
│   │       ├── CloverPageView.ets
│   │       ├── CloverTaskCard.ets
│   │       └── SleepReportPageView.ets
│   │
│   ├── viewmodel/                 # 业务逻辑层
│   │   └── music/                 # 音乐播放服务
│   │       ├── AVPlayerService.ets   # AVPlayer封装
│   │       ├── AVSessionService.ets  # 媒体会话服务
│   │       ├── MediaService.ets      # 音乐播放管理
│   │       ├── SongItemBuilder.ets   # 歌曲资源构建
│   │       └── SongListData.ets      # 歌曲列表数据
│   │
│   └── widget/pages/              # 卡片UI
│       ├── DeliveryCard.ets
│       ├── ExerciseCard.ets
│       ├── MusicCard.ets
│       └── SleepCard.ets
│
├── resources/
│   ├── base/
│   │   ├── element/
│   │   │   ├── color.json
│   │   │   ├── float.json
│   │   │   └── string.json        # 国际化字符串
│   │   ├── media/                 # 图片资源
│   │   │   └── ...
│   │   └── profile/
│   │       ├── backup_config.json # 备份配置
│   │       ├── form_config.json   # 卡片配置
│   │       ├── main_pages.json    # 页面路由
│   │       └── route_map.json     # 命名路由
│   │
│   ├── dark/element/
│   │   └── color.json             # 深色模式颜色
│   ├── en_US/element/
│   │   └── string.json            # 英文字符串
│   ├── rawfile/                   # 原始资源文件
│   │   ├── delivery/              # 快递卡片资源
│   │   │   ├── background.png
│   │   │   ├── delivery_text.png
│   │   │   ├── fuzzball.png
│   │   │   └── fuzzball.webp
│   │   ├── exercise/              # 运动卡片资源
│   │   │   ├── animate/           # 运动动画帧
│   │   │   └── background.png
│   │   ├── lrcfiles/              # 歌词文件
│   │   │   └── DreamItPossible.lrc
│   │   ├── music/                 # 音乐卡片资源
│   │   │   ├── animate/           # 音乐动画帧
│   │   │   ├── album.png
│   │   │   ├── album_background.png
│   │   │   ├── album_btn.png
│   │   │   ├── background.png
│   │   │   └   music_hanhan.png
│   │   ├── sleep/                 # 睡眠卡片资源
│   │   │   ├── animate/           # 睡眠动画帧
│   │   │   ├── background.png
│   │   │   ├── clover_sleep.png
│   │   │   ├── clover_wakeup.png
│   │   │   ├── hanhan_sleep.png
│   │   │   └   hanhan_wakeup.png
│   │   ├── boisterous.mp3         # 音效文件
│   │   └── Delacey - Dream It Possible.mp3  # 音乐文件
│   └── zh_CN/element/
│       └── string.json            # 中文字符串
│
└── module.json5                   # 模块配置
```
## 具体实现
### 互动卡片架构
互动卡片是由`LiveFormExtensionAbility`
实现的特殊卡片形态，激活流程可参考场景动效类型互动卡片[实现原理](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-ui-liveform-sceneanimation-overview#实现原理)。
**关键步骤说明**：
1. 用户点击动态卡片按钮
2. 卡片通过 `postCardAction` 发送 MESSAGE 事件到 `FormExtensionAbility`
3. `FormExtensionAbility.onFormEvent` 接收事件，调用 `formProvider.requestOverflow`
4. 系统根据 `form_config.json` 中配置的 `sceneAnimationParams.abilityName` 激活对应的 `LiveFormExtensionAbility`
5. `LiveFormExtensionAbility.onLiveFormCreate` 被调用，加载互动卡片 UI
### 关键配置
#### form_config.json
```json
{
  "forms": [
    {
      "name": "SleepCard",
      "displayName": "$string:SleepCard",
      "src": "./ets/widget/pages/SleepCard.ets",
      "isDynamic": true,
      "defaultDimension": "2*4",
      "supportDimensions": ["2*4"],
      "sceneAnimationParams": {
        "abilityName": "SleepLiveCardAbility"
      }
    },
    // ...
  ]
}
```
**关键参数说明**：
- `isDynamic: true` - 启用动态卡片能力
- `sceneAnimationParams.abilityName` - 指定互动卡片 Ability
- `supportDimensions` - 支持的卡片尺寸
#### module.json5
```json
{
  "extensionAbilities": [
    {
      "name": "EntryFormAbility",
      "srcEntry": "./ets/entryformability/EntryFormAbility.ets",
      "type": "form"
    },
    {
    "name": "SleepLiveCardAbility",
    "srcEntry": "./ets/livecardability/SleepLiveCardAbility.ets",
    "type": "liveForm"
  }]
}
```
**type 类型**：
- `form` - 卡片
- `liveForm` - 互动卡片
### LiveFormExtensionAbility 实现
```typescript
export class SleepLiveCardAbility extends LiveFormExtensionAbility {
  onLiveFormCreate(liveFormInfo: LiveFormInfo, session: UIExtensionContentSession): void {
    let storage: LocalStorage = new LocalStorage();
    storage.setOrCreate('context', this.context);
    storage.setOrCreate('session', session);
    storage.setOrCreate('formId', liveFormInfo.formId);
    storage.setOrCreate('borderRadius', liveFormInfo.borderRadius);
    storage.setOrCreate('formRect', liveFormInfo.rect);
    session.loadContent('livecardability/pages/SleepLiveCard', storage);
  }
}
```
**注意事项**：
- `loadContent` 必须在 `onLiveFormCreate` 中同步调用
- 异步操作应在 `loadContent` 之后执行
- 否则会导致白屏问题
### 帧动画实现
睡眠卡片采用权重化帧序列，每帧可设置不同权重（持续时间倍数），实现灵活的动画节奏：
```typescript
class FrameItem {
  src: Resource
  weight: number
}
@State currentFrameIndex: number = 0
private frames: FrameItem[] = [
  { src: $rawfile('sleep/animate/clover_wakeup_01.png'), weight: 3 },
  { src: $rawfile('sleep/animate/clover_wakeup_02.png'), weight: 1 },
  // ...
];
startImageSync(): void {
  this.animStartTime = Date.now();
  this.imageSyncTimer = setInterval(() => {
    const elapsed = Date.now() - this.animStartTime;
    const newFrame = this.getFrameByElapsed(elapsed, this.cumulativeTime, this.frames.length);
    if (newFrame > this.currentFrameIndex) {
      this.currentFrameIndex = newFrame;
    }
  }, 16);
}
build() {
  Image(this.frames[this.currentFrameIndex].src)
    .width('100%')
    .height('100%');
}
```
**注意事项**：
- 图片资源不易过大，Image加载耗时可能导致丢帧
- 动画最大 3500 ms
### 卡片与应用通信
#### 卡片 → 应用
卡片通过 `postCardAction` 向应用发送指令，支持三种 action 类型：
| action 类型 | 用途          | 目标 Ability           |
|-----------|-------------|----------------------|
| `CALL`    | 播放/切歌/收藏等操作 | UIAbility            |
| `MESSAGE` | 请求激活互动卡片    | FormExtensionAbility |
| `ROUTER`  | 跳转到应用落地页    | UIAbility            |
```typescript
// CALL：播放控制
postCardAction(this, {
  action: FormCarAction.CALL,
  abilityName: ENTRY_ABILITY,
  params: {
    method: 'cardAction',
    actionType: CardActionType.PLAY_ACTION,
    playActionType: PlayActionType.NEXT,
    formId: formId
  }
});
// MESSAGE：激活互动卡片
postCardAction(this, {
  action: FormCarAction.MESSAGE,
  abilityName: ENTRY_FORM_ABILITY,
  params: {
    message: 'requestOverflow',
    widthRadio: widthRadio,
    heightRadio: heightRadio,
    duration: duration,
    triggerAction: 'PLAY',
    songId: songId
  }
});
// ROUTER：跳转落地页
postCardAction(this, {
  action: FormCarAction.ROUTER,
  abilityName: ENTRY_ABILITY,
  params: { routeName: 'MusicPage' }
});
```
#### 应用 → 动态卡片
应用通过 `formProvider.updateForm` 更新动态卡片数据，卡片以 `LocalStorageProp` 接收：
```typescript
// 应用端：FormUtils.updateForm
private updateForm(formId: string, updateData: object): void {
  let formMsg = formBindingData.createFormBindingData(updateData);
  formProvider.updateForm(formId, formMsg);
}
// 动态卡片端：LocalStorageProp 接收
@LocalStorageProp('isPlay') isPlay: boolean = false;
@LocalStorageProp('title') title: string = 'SongName';
@LocalStorageProp('songId') songId: string = '';
```
#### 应用 → 互动卡片
应用与互动卡片分属不同进程，LocalStorage 无法跨进程共享，只能通过数据持久化（Preferences/数据库/文件存储）传递数据。互动卡片内部的
LiveFormExtensionAbility → 互动卡片UI 使用 LocalStorage：
```typescript
// 应用端：通过FileStore写入文件
import MusicFileStore from '../database/MusicFileStore';
MusicFileStore.storeTriggerAction(context, 'PLAY', songId);
MusicFileStore.writeCurrentSong(context, songItem);
// LiveFormExtensionAbility端：先loadContent（同步），再读取文件数据
session.loadContent('livecardability/pages/MusicLiveCard', storage);
let actionData = MusicFileStore.getTriggerAction(this.context);
if (actionData) {
  storage.setOrCreate('triggerAction', actionData.triggerAction);
}
let currentSong = MusicFileStore.readCurrentSong(this.context);
storage.setOrCreate('currentSong', currentSong);
// 互动卡片端：LocalStorageProp 接收
@LocalStorageProp('currentSong') currentSong: SongItem = new SongItem();
@LocalStorageLink('triggerAction') @Watch('onTriggerActionChange') triggerAction: string = '';
```
## 相关权限
项目在 `module.json5` 中声明以下权限：
| 权限 | 用途 |
|------|------|
| `ohos.permission.KEEP_BACKGROUND_RUNNING` | 音乐后台播放 |
| `ohos.permission.GYROSCOPE` | 陀螺仪（快递卡片交互） |
## 约束与限制
1. 本示例仅支持标准系统上运行，支持设备：直板机、双折叠、三折叠、阔折叠、平板。
2. 操作系统：HarmonyOS 6.1.0 Release及以上。
3. IDE版本：DevEco Studio 6.1.0 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS SDK版本6.1.或更高版本。
5. 互动卡片约束详见：[约束与限制](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-ui-liveform-sceneanimation-overview#约束和限制)。
6. `loadContent` 必须在 `onLiveFormCreate` 中同步调用，异步操作应在 `loadContent` 之后执行，否则会导致白屏问题。
