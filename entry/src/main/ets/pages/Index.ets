/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Entry
@Component
struct Index {
  @State message: string = 'HarmonyOS 互动卡片演示';

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 30 });

      Text('原始 4 种卡片')
        .fontSize(16)
        .fontColor('#888')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ left: 20, bottom: 10 });

      // 原始4种卡片预览
      Grid() {
        GridItem() {
          this.CardPreview('😴', '睡眠卡片', '#4CAF50');
        }
        GridItem() {
          this.CardPreview('📦', '快递卡片', '#FF9800');
        }
        GridItem() {
          this.CardPreview('🏃', '运动卡片', '#FF5722');
        }
        GridItem() {
          this.CardPreview('🎵', '音乐卡片', '#E91E63');
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(12)
      .rowsGap(12)
      .height(240)
      .padding({ left: 20, right: 20 })
      .margin({ bottom: 30 });

      Text('⭐ 新增功能卡片')
        .fontSize(16)
        .fontColor('#FFD700')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ left: 20, bottom: 10 });

      // 新增2种卡片预览
      Grid() {
        GridItem() {
          this.CardPreview('🌤️', '天气卡片', '#2196F3');
        }
        GridItem() {
          this.CardPreview('🏠', '智能中控', '#9C27B0');
        }
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(12)
      .height(120)
      .padding({ left: 20, right: 20 });

      Text('长按卡片可添加到桌面')
        .fontSize(12)
        .fontColor('#666')
        .margin({ top: 30 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#12121a');
  }

  @Builder
  CardPreview(icon: string, name: string, color: string) {
    Column() {
      Text(icon)
        .fontSize(32);
      Text(name)
        .fontSize(12)
        .fontColor(Color.White)
        .margin({ top: 8 });
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .borderRadius(16)
    .backgroundColor('#1e1e2e')
    .border({ width: 2, color: color + '40' });
  }
}
