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

@Entry
@Component
struct SmartHomeLiveCard {
  localStorage: LocalStorage = this.getUIContext().getLocalStorage();
  private stateMachine: DeviceStateMachine = this.localStorage.get('stateMachine');
  @State sensorData = this.stateMachine.getSensorData();
  @State hourlyData = this.stateMachine.getHourlyData();
  @State totalEnergy = this.stateMachine.getTotalEnergyToday();
  @State devices = this.stateMachine.getAllDevices();

  build() {
    Column() {
      // 溢出卡片头部
      this.Header();

      // 设备列表
      this.DeviceList();

      // 24小时温度曲线图表区
      this.ChartArea();

      // 场景按钮
      this.SceneButtons();

      // 能耗统计
      this.EnergyStats();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#12121a')
    .padding(16);
  }

  @Builder
  Header() {
    Row() {
      Text('🏠 智能中控中心')
        .fontSize(18)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold);

      Blank();

      Column({ space: 4 }) {
        Text(`🌡️ ${this.sensorData.temperature.toFixed(1)}°C`)
          .fontSize(14)
          .fontColor('#FFD700');
        Text(`💧 ${this.sensorData.humidity.toFixed(0)}%`)
          .fontSize(14)
          .fontColor('#87CEEB');
        Text(`🌬️ PM2.5 ${this.sensorData.pm25}`)
          .fontSize(12)
          .fontColor(this.sensorData.pm25 < 35 ? '#4CAF50' : '#FF9800');
      }
      .alignItems(HorizontalAlign.End);
    }
    .width('100%')
    .margin({ bottom: 16 });
  }

  @Builder
  DeviceList() {
    Column({ space: 8 }) {
      ForEach(this.devices.slice(0, 6), (device) => {
        Row() {
          Text(this.getDeviceIcon(device.type))
            .fontSize(20);

          Text(device.name)
            .fontSize(14)
            .fontColor(Color.White)
            .margin({ left: 12 });

          Blank();

          // 开关状态指示器
          Circle({ width: 12, height: 12 })
            .fill(device.isOn ? '#4CAF50' : '#666666');
        }
        .width('100%')
        .padding(12)
        .borderRadius(12)
        .backgroundColor('#1e1e2e')
        .onClick(() => {
          this.stateMachine.toggleDevice(device.id);
          this.devices = this.stateMachine.getAllDevices();
        });
      });
    }
    .margin({ bottom: 16 });
  }

  @Builder
  ChartArea() {
    Column() {
      Text('📈 24小时温度曲线')
        .fontSize(14)
        .fontColor(Color.White)
        .margin({ bottom: 8 });

      // 简化版曲线图展示
      Row({ space: 2 }) {
        ForEach(this.hourlyData.slice(8, 20), (data) => {
          Column() {
            Blank();
            Rect()
              .width(8)
              .height((data.temperature - 18) * 8)
              .fill(this.getTempColor(data.temperature))
              .borderRadius(4);
          }
          .height(60);
        });
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly);
    }
    .width('100%')
    .padding(12)
    .borderRadius(12)
    .backgroundColor('#1e1e2e')
    .margin({ bottom: 16 });
  }

  @Builder
  SceneButtons() {
    Row({ space: 8 }) {
      this.SceneBtn('🏠', SceneType.HOME);
      this.SceneBtn('🚶', SceneType.AWAY);
      this.SceneBtn('😴', SceneType.SLEEP);
      this.SceneBtn('🎬', SceneType.MOVIE);
      this.SceneBtn('📖', SceneType.READ);
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({ bottom: 16 });
  }

  @Builder
  SceneBtn(icon: string, scene: SceneType) {
    Column() {
      Text(icon)
        .fontSize(24);
      Text(DeviceConstants.SCENE_NAMES[scene])
        .fontSize(11)
        .fontColor(Color.White)
        .margin({ top: 4 });
    }
    .width(56)
    .height(56)
    .justifyContent(FlexAlign.Center)
    .borderRadius(16)
    .backgroundColor('#2a2a4a')
    .onClick(() => {
      this.stateMachine.executeScene(scene);
      this.devices = this.stateMachine.getAllDevices();
    });
  }

  @Builder
  EnergyStats() {
    Row() {
      Column() {
        Text('⚡ 今日能耗')
          .fontSize(12)
          .fontColor('#888888');
        Text(`${this.totalEnergy.toFixed(1)} kWh`)
          .fontSize(20)
          .fontColor('#FFD700')
          .fontWeight(FontWeight.Bold);
        Text('≈ ¥2.10')
          .fontSize(12)
          .fontColor('#4CAF50');
      }

      Blank();

      Column() {
        Text('📱 在线设备')
          .fontSize(12)
          .fontColor('#888888');
        Text(`${this.devices.filter(d => d.isOn).length}/${this.devices.length}`)
          .fontSize(20)
          .fontColor('#4CAF50')
          .fontWeight(FontWeight.Bold);
        Text('运行中')
          .fontSize(12)
          .fontColor('#4CAF50');
      }
    }
    .width('100%')
    .padding(16)
    .borderRadius(12)
    .backgroundColor('#1e1e2e');
  }

  private getDeviceIcon(type: string): string {
    const icons: Record<string, string> = {
      'light': '💡',
      'ac': '🎛️',
      'curtain': '🪟',
      'security': '🚨',
      'purifier': '🌬️',
      'socket': '🔌'
    };
    return icons[type] || '📱';
  }

  private getTempColor(temp: number): string {
    if (temp < 22) return '#4FC3F7';
    if (temp < 26) return '#81C784';
    if (temp < 28) return '#FFB74D';
    return '#FF8A65';
  }
}
