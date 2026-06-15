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

import { DeviceStateMachine } from '../../model/smarthome/DeviceStateMachine';
import { SceneType, DeviceConstants } from '../../model/smarthome/DeviceConstants';
import FormUtils from '../../utils/FormUtils';

@Entry
@Component
struct SmartHomeCard {
  private stateMachine: DeviceStateMachine = DeviceStateMachine.getInstance();
  @State sensorData = this.stateMachine.getSensorData();

  build() {
    Column() {
      // 头部：标题 + 环境数据
      this.Header();

      // 设备快捷控制区
      this.DeviceGrid();

      // 场景快捷按钮
      this.SceneBar();
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#1a1a2e');
  }

  @Builder
  Header() {
    Row() {
      Text('🏠 智能中控')
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium);

      Blank();

      Text(`${this.sensorData.temperature.toFixed(1)}°C`)
        .fontSize(12)
        .fontColor('#FFD700');

      Text(`${this.sensorData.humidity.toFixed(0)}%`)
        .fontSize(12)
        .fontColor('#87CEEB')
        .margin({ left: 8 });
    }
    .width('100%');
  }

  @Builder
  DeviceGrid() {
    Column({ space: 8 }) {
      Row({ space: 12 }) {
        this.DeviceIcon('💡', '灯光', 'light_living');
        this.DeviceIcon('🎛️', '空调', 'ac_living');
        this.DeviceIcon('🪟', '窗帘', 'curtain_main');
        this.DeviceIcon('🚨', '安防', 'security_001');
      }

      Row({ space: 12 }) {
        this.DeviceIcon('🌬️', '净化', 'purifier_001');
        this.DeviceIcon('🔌', '插座', 'socket_living');
        this.DeviceIcon('📊', '能耗', '');
      }
    }
    .margin({ top: 12, bottom: 12 });
  }

  @Builder
  DeviceIcon(icon: string, name: string, deviceId: string) {
    Column() {
      Text(icon)
        .fontSize(24);

      Text(name)
        .fontSize(10)
        .fontColor(Color.White)
        .margin({ top: 4 });
    }
    .width(50)
    .height(50)
    .justifyContent(FlexAlign.Center)
    .borderRadius(12)
    .backgroundColor(deviceId && this.stateMachine.getDevice(deviceId)?.isOn ? '#4CAF50' : '#333344')
    .onClick(() => {
      if (deviceId) {
        this.stateMachine.toggleDevice(deviceId);
      } else {
        // 点击能耗，激活互动卡片
        this.requestLiveCard();
      }
    });
  }

  @Builder
  SceneBar() {
    Row({ space: 8 }) {
      this.SceneButton('🏠', '回家', SceneType.HOME);
      this.SceneButton('🚶', '离家', SceneType.AWAY);
      this.SceneButton('😴', '睡眠', SceneType.SLEEP);
      this.SceneButton('🎬', '观影', SceneType.MOVIE);
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceEvenly);
  }

  @Builder
  SceneButton(icon: string, name: string, scene: SceneType) {
    Column() {
      Text(icon)
        .fontSize(16);
      Text(name)
        .fontSize(9)
        .fontColor(Color.White);
    }
    .padding({ top: 6, bottom: 6, left: 8, right: 8 })
    .borderRadius(16)
    .backgroundColor('#2a2a4a')
    .onClick(() => {
      this.stateMachine.executeScene(scene);
    });
  }

  private requestLiveCard(): void {
    // 请求激活互动卡片溢出动画
    FormUtils.requestSmartHomeLiveCard();
  }
}
