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
struct SportsCard {
  @State calories: number = 320;
  @State steps: number = 6842;
  @State goal: number = 10000;

  build() {
    Column() {
      Row() {
        Text('🏃 运动')
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium);

        Blank();

        Text(`${Math.floor(this.steps / this.goal * 100)}%`)
          .fontSize(12)
          .fontColor('#FF9800');
      }
      .width('100%');

      // 卡路里燃烧动画
      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: 60, height: 60 })
          .fill('#2a2a4a');

        Text('🔥')
          .fontSize(32);
      }
      .margin({ top: 8, bottom: 8 });

      Row() {
        Column() {
          Text('步数')
            .fontSize(10)
            .fontColor('#888888');
          Text(this.steps.toString())
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold);
        }

        Blank();

        Column() {
          Text('卡路里')
            .fontSize(10)
            .fontColor('#888888');
          Text(`${this.calories} kcal`)
            .fontSize(14)
            .fontColor('#FF6B6B')
            .fontWeight(FontWeight.Bold);
        }
      }
      .width('100%');
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#1a1a2e')
    .onClick(() => {
      FormUtils.requestSportsLiveCard();
    });
  }
}
