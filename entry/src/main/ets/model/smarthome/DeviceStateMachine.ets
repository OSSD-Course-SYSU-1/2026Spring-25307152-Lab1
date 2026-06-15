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

import { IDeviceState, DeviceDataFactory, ISensorData, IHourlyData } from './DeviceData';
import { RoomType, DeviceType, SceneType, DeviceConstants } from './DeviceConstants';
import preferencesUtil from '../../database/PreferencesUtil';

/**
 * 状态变更监听器类型
 */
export type StateChangeListener = (device: IDeviceState) => void;

/**
 * 设备状态机 - 单例模式
 */
export class DeviceStateMachine {
  private static instance: DeviceStateMachine;
  private devices: Map<string, IDeviceState> = new Map();
  private listeners: StateChangeListener[] = [];
  private sensorData: ISensorData;
  private hourlyData: IHourlyData[];
  private totalEnergyToday: number = 3.5;

  private constructor() {
    this.initDevices();
    this.sensorData = DeviceDataFactory.createSensorData();
    this.hourlyData = DeviceDataFactory.createHourlyData();
  }

  /**
   * 获取单例
   */
  static getInstance(): DeviceStateMachine {
    if (!DeviceStateMachine.instance) {
      DeviceStateMachine.instance = new DeviceStateMachine();
    }
    return DeviceStateMachine.instance;
  }

  /**
   * 初始化所有设备
   */
  private initDevices(): void {
    // 客厅灯光
    this.devices.set('light_living', DeviceDataFactory.createDefaultLight(
      'light_living', '客厅主灯', RoomType.LIVING_ROOM
    ));

    // 卧室灯光
    this.devices.set('light_bedroom', DeviceDataFactory.createDefaultLight(
      'light_bedroom', '卧室灯', RoomType.BEDROOM
    ));

    // 书房灯光
    this.devices.set('light_study', DeviceDataFactory.createDefaultLight(
      'light_study', '书房灯', RoomType.STUDY
    ));

    // 客厅空调
    this.devices.set('ac_living', DeviceDataFactory.createDefaultAC(
      'ac_living', '客厅空调', RoomType.LIVING_ROOM
    ));

    // 卧室空调
    this.devices.set('ac_bedroom', DeviceDataFactory.createDefaultAC(
      'ac_bedroom', '卧室空调', RoomType.BEDROOM
    ));

    // 主窗帘
    this.devices.set('curtain_main', DeviceDataFactory.createDefaultCurtain(
      'curtain_main', '主窗帘', RoomType.LIVING_ROOM
    ));

    // 安防系统
    this.devices.set('security_001', DeviceDataFactory.createDefaultSecurity());

    // 空气净化器
    this.devices.set('purifier_001', DeviceDataFactory.createDefaultPurifier());

    // 客厅插座
    this.devices.set('socket_living', DeviceDataFactory.createDefaultSocket(
      'socket_living', '客厅插座', RoomType.LIVING_ROOM
    ));
  }

  /**
   * 获取所有设备
   */
  getAllDevices(): IDeviceState[] {
    return Array.from(this.devices.values());
  }

  /**
   * 根据类型获取设备
   */
  getDevicesByType(type: DeviceType): IDeviceState[] {
    return Array.from(this.devices.values()).filter(d => d.type === type);
  }

  /**
   * 获取单个设备
   */
  getDevice(deviceId: string): IDeviceState | undefined {
    return this.devices.get(deviceId);
  }

  /**
   * 切换设备开关
   */
  toggleDevice(deviceId: string): void {
    const device = this.devices.get(deviceId);
    if (device) {
      device.isOn = !device.isOn;
      device.lastUpdate = Date.now();
      this.notifyListeners(device);
      this.saveState();
    }
  }

  /**
   * 更新设备数值
   */
  updateDeviceValue(deviceId: string, value: number): void {
    const device = this.devices.get(deviceId);
    if (device) {
      device.value = Math.max(0, Math.min(100, value));
      device.lastUpdate = Date.now();
      this.notifyListeners(device);
      this.saveState();
    }
  }

  /**
   * 更新设备模式
   */
  updateDeviceMode(deviceId: string, mode: number): void {
    const device = this.devices.get(deviceId);
    if (device && device.mode !== undefined) {
      device.mode = mode;
      device.lastUpdate = Date.now();
      this.notifyListeners(device);
      this.saveState();
    }
  }

  /**
   * 执行场景模式
   */
  executeScene(scene: SceneType): void {
    switch (scene) {
      case SceneType.HOME:
        this.executeHomeScene();
        break;
      case SceneType.AWAY:
        this.executeAwayScene();
        break;
      case SceneType.SLEEP:
        this.executeSleepScene();
        break;
      case SceneType.MOVIE:
        this.executeMovieScene();
        break;
      case SceneType.READ:
        this.executeReadScene();
        break;
    }
  }

  /**
   * 回家场景
   */
  private executeHomeScene(): void {
    // 灯光渐亮
    this.updateDeviceValue('light_living', 80);
    this.devices.get('light_living')!.isOn = true;

    // 开启空调
    this.updateDeviceValue('ac_living', 26);
    this.devices.get('ac_living')!.isOn = true;

    // 打开窗帘
    this.updateDeviceValue('curtain_main', 100);

    // 安防撤防
    this.updateDeviceMode('security_001', 0);

    // 通知所有监听器
    this.devices.forEach(d => this.notifyListeners(d));
  }

  /**
   * 离家场景
   */
  private executeAwayScene(): void {
    // 关闭所有灯
    this.getDevicesByType(DeviceType.LIGHT).forEach(light => {
      light.isOn = false;
      this.notifyListeners(light);
    });

    // 关闭空调
    this.getDevicesByType(DeviceType.AIR_CONDITIONER).forEach(ac => {
      ac.isOn = false;
      this.notifyListeners(ac);
    });

    // 关闭窗帘
    this.updateDeviceValue('curtain_main', 0);

    // 安防布防
    this.updateDeviceMode('security_001', 1);

    // 关闭净化器
    this.devices.get('purifier_001')!.isOn = false;
  }

  /**
   * 睡眠场景
   */
  private executeSleepScene(): void {
    // 主灯关闭，夜灯开启
    this.devices.get('light_living')!.isOn = false;
    this.devices.get('light_bedroom')!.isOn = true;
    this.updateDeviceValue('light_bedroom', 10);

    // 空调睡眠模式
    this.updateDeviceValue('ac_bedroom', 26);
    this.devices.get('ac_bedroom')!.isOn = true;
    this.updateDeviceMode('ac_bedroom', 1);

    // 关闭窗帘
    this.updateDeviceValue('curtain_main', 0);

    // 睡眠布防
    this.updateDeviceMode('security_001', 2);
  }

  /**
   * 观影场景
   */
  private executeMovieScene(): void {
    // 主灯关闭，氛围灯开启
    this.devices.get('light_living')!.isOn = true;
    this.updateDeviceValue('light_living', 10);

    // 关闭窗帘
    this.updateDeviceValue('curtain_main', 0);

    // 空调26度
    this.updateDeviceValue('ac_living', 26);
    this.devices.get('ac_living')!.isOn = true;
  }

  /**
   * 阅读场景
   */
  private executeReadScene(): void {
    // 阅读灯最亮
    this.devices.get('light_study')!.isOn = true;
    this.updateDeviceValue('light_study', 100);

    // 其他灯30%
    this.updateDeviceValue('light_living', 30);
    this.devices.get('light_living')!.isOn = true;

    // 空调25度
    this.updateDeviceValue('ac_living', 25);
    this.devices.get('ac_living')!.isOn = true;
  }

  /**
   * 获取传感器数据
   */
  getSensorData(): ISensorData {
    // 模拟实时更新
    this.sensorData.temperature += (Math.random() - 0.5) * 0.1;
    this.sensorData.humidity += (Math.random() - 0.5) * 1;
    return this.sensorData;
  }

  /**
   * 获取24小时数据
   */
  getHourlyData(): IHourlyData[] {
    return this.hourlyData;
  }

  /**
   * 获取今日总能耗
   */
  getTotalEnergyToday(): number {
    return this.totalEnergyToday;
  }

  /**
   * 添加状态监听器
   */
  addListener(listener: StateChangeListener): void {
    this.listeners.push(listener);
  }

  /**
   * 移除状态监听器
   */
  removeListener(listener: StateChangeListener): void {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }

  /**
   * 通知所有监听器
   */
  private notifyListeners(device: IDeviceState): void {
    this.listeners.forEach(listener => listener(device));
  }

  /**
   * 保存状态到Preferences
   */
  private saveState(): void {
    // 持久化设备状态
    preferencesUtil.putDeviceState(JSON.stringify(Array.from(this.devices.entries())));
  }
}
