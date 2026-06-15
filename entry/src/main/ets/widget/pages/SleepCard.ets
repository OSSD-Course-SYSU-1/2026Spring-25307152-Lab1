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

import FormUtils from '../../utils/FormUtils';

@Entry
@Component
struct SleepCard {
  @State sleepProgress: number = 0.75;
  @State sleepHours: string = '7.5';
  @State isSleeping: boolean = false;

  build() {
    Column() {
      Row() {
        Text('😴 睡眠')
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium);
        Blank();
        Text(`${this.sleepHours}h`)
          .fontSize(16)
          .fontColor('#4CAF50')
          .fontWeight(FontWeight.Bold);
      }
      .width('100%');

      Stack({ alignContent: Alignment.Center }) {
        Circle()
          .width(80)
          .height(80)
          .fill('#1a3a1a')
          .stroke('#4CAF50')
          .strokeWidth(3);

        Text('🍀')
          .fontSize(36)
          .opacity(this.isSleeping ? 1 : 0.6);
      }
      .margin({ top: 8, bottom: 8 });

      Progress({ value: this.sleepProgress * 100, total: 100, type: ProgressType.Linear })
        .width('100%')
        .height(6)
        .color('#4CAF50')
        .backgroundColor('#333');

      Text(this.isSleeping ? '睡眠中...' : '点击开始睡眠')
        .fontSize(10)
        .fontColor('#888')
        .margin({ top: 4 });
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#12121a')
    .onClick(() => {
      this.isSleeping = !this.isSleeping;
      FormUtils.requestSleepLiveCard();
    });
  }
}
