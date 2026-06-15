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
struct ExpressCard {
  @State progress: number = 60;
  @State status: string = '运输中';

  build() {
    Column() {
      Row() {
        Text('📦 快递')
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium);

        Blank();

        Text(this.status)
          .fontSize(12)
          .fontColor('#FF9800');
      }
      .width('100%');

      // 憨憨动画
      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: 60, height: 60 })
          .fill('#2a2a4a');

        Text('🚚')
          .fontSize(32);
      }
      .margin({ top: 8, bottom: 8 });

      // 进度条
      Progress({ value: this.progress, total: 100, type: ProgressType.Linear })
        .width('100%')
        .height(6)
        .color('#4CAF50')
        .backgroundColor('#333344');

      Text(`配送进度 ${this.progress}%`)
        .fontSize(10)
        .fontColor('#888888')
        .margin({ top: 4 });
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#1a1a2e')
    .onClick(() => {
      FormUtils.requestExpressLiveCard();
    });
  }
}
