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
struct MusicCard {
  @State isPlaying: boolean = false;
  @State songName: string = 'HarmonyOS';
  @State artist: string = 'Developer';

  build() {
    Column() {
      Row() {
        Text('🎵 音乐')
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium);

        Blank();

        Text(this.isPlaying ? '播放中' : '已暂停')
          .fontSize(12)
          .fontColor(this.isPlaying ? '#4CAF50' : '#888888');
      }
      .width('100%');

      // 专辑封面动画
      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: 50, height: 50 })
          .fill('#2a2a4a');

        Text('🎶')
          .fontSize(28);
      }
      .margin({ top: 8, bottom: 8 });

      Text(this.songName)
        .fontSize(12)
        .fontColor(Color.White)
        .maxLines(1);

      Text(this.artist)
        .fontSize(10)
        .fontColor('#888888')
        .maxLines(1);

      // 播放控制
      Row({ space: 16 }) {
        Text('⏮️')
          .fontSize(16);

        Text(this.isPlaying ? '⏸️' : '▶️')
          .fontSize(20)
          .onClick(() => {
            this.isPlaying = !this.isPlaying;
          });

        Text('⏭️')
          .fontSize(16);
      }
      .margin({ top: 4 });
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#1a1a2e')
    .onClick(() => {
      FormUtils.requestMusicLiveCard();
    });
  }
}
