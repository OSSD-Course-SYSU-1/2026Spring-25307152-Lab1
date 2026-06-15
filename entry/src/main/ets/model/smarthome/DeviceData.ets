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

import { DeviceType, RoomType, ACMode, SecurityMode } from './DeviceConstants';

/**
 * 设备基础状态接口
 */
export interface IDeviceState {
  id: string;
  name: string;
  room: RoomType;
  type: DeviceType;
  isOn: boolean;
  value: number;           // 通用数值：亮度/温度/开合度/风速
  mode?: number;           // 工作模式
  lastUpdate: number;
}

/**
 * 灯光设备状态
 */
export interface ILightState extends IDeviceState {
  type: DeviceType.LIGHT;
  colorTemp: number;       // 色温 2700-6500K
  colorR: number;          // RGB红色
  colorG: number;          // RGB绿色
  colorB: number;          // RGB蓝色
}

/**
 * 空调设备状态
 */
export interface IACState extends IDeviceState {
  type: DeviceType.AIR_CONDITIONER;
  mode: ACMode;
  fanSpeed: number;        // 风速 0-3
  swing: boolean;          // 扫风
}

/**
 * 窗帘设备状态
 */
export interface ICurtainState extends IDeviceState {
  type: DeviceType.CURTAIN;
  speed: number;           // 开合速度
}

/**
 * 安防系统状态
 */
export interface ISecurityState extends IDeviceState {
  type: DeviceType.SECURITY;
  mode: SecurityMode;
  doorOpen: boolean;       // 门磁状态
  motionDetected: boolean; // 人体感应
  cameraOnline: boolean;   // 摄像头在线
}

/**
 * 空气净化器状态
 */
export interface IPurifierState extends IDeviceState {
  type: DeviceType.PURIFIER;
  pm25: number;            // PM2.5数值
  filterLife: number;      // 滤芯寿命 0-100%
}

/**
 * 智能插座状态
 */
export interface ISocketState extends IDeviceState {
  type: DeviceType.SOCKET;
  power: number;           // 实时功率(W)
  energyToday: number;     // 今日用电量(kWh)
}

/**
 * 环境传感器数据
 */
export interface ISensorData {
  temperature: number;     // 温度(°C)
  humidity: number;        // 湿度(%)
  pm25: number;            // PM2.5
  co2: number;             // CO2浓度(ppm)
  timestamp: number;
}

/**
 * 小时级历史数据
 */
export interface IHourlyData {
  hour: number;
  temperature: number;
  humidity: number;
  energy: number;
}

/**
 * 设备能耗统计
 */
export interface IDeviceEnergy {
  deviceId: string;
  deviceName: string;
  energyToday: number;
  percentage: number;
}

/**
 * 设备数据工厂类
 */
export class DeviceDataFactory {
  /**
   * 创建默认灯光设备
   */
  static createDefaultLight(id: string, name: string, room: RoomType): ILightState {
    return {
      id,
      name,
      room,
      type: DeviceType.LIGHT,
      isOn: false,
      value: 50,
      colorTemp: 4000,
      colorR: 255,
      colorG: 255,
      colorB: 255,
      lastUpdate: Date.now()
    };
  }

  /**
   * 创建默认空调设备
   */
  static createDefaultAC(id: string, name: string, room: RoomType): IACState {
    return {
      id,
      name,
      room,
      type: DeviceType.AIR_CONDITIONER,
      isOn: false,
      value: 26,
      mode: ACMode.AUTO,
      fanSpeed: 2,
      swing: true,
      lastUpdate: Date.now()
    };
  }

  /**
   * 创建默认窗帘设备
   */
  static createDefaultCurtain(id: string, name: string, room: RoomType): ICurtainState {
    return {
      id,
      name,
      room,
      type: DeviceType.CURTAIN,
      isOn: false,
      value: 100,
      speed: 1,
      lastUpdate: Date.now()
    };
  }

  /**
   * 创建默认安防设备
   */
  static createDefaultSecurity(): ISecurityState {
    return {
      id: 'security_001',
      name: '安防系统',
      room: RoomType.LIVING_ROOM,
      type: DeviceType.SECURITY,
      isOn: true,
      value: 0,
      mode: SecurityMode.AT_HOME,
      doorOpen: false,
      motionDetected: false,
      cameraOnline: true,
      lastUpdate: Date.now()
    };
  }

  /**
   * 创建默认净化器
   */
  static createDefaultPurifier(): IPurifierState {
    return {
      id: 'purifier_001',
      name: '空气净化器',
      room: RoomType.LIVING_ROOM,
      type: DeviceType.PURIFIER,
      isOn: false,
      value: 2,
      pm25: 35,
      filterLife: 85,
      lastUpdate: Date.now()
    };
  }

  /**
   * 创建默认插座
   */
  static createDefaultSocket(id: string, name: string, room: RoomType): ISocketState {
    return {
      id,
      name,
      room,
      type: DeviceType.SOCKET,
      isOn: true,
      value: 0,
      power: 45,
      energyToday: 1.2,
      lastUpdate: Date.now()
    };
  }

  /**
   * 创建模拟传感器数据
   */
  static createSensorData(): ISensorData {
    return {
      temperature: 24.5 + Math.random() * 2,
      humidity: 60 + Math.random() * 10,
      pm25: 30 + Math.floor(Math.random() * 20),
      co2: 400 + Math.floor(Math.random() * 200),
      timestamp: Date.now()
    };
  }

  /**
   * 创建24小时模拟数据
   */
  static createHourlyData(): IHourlyData[] {
    const data: IHourlyData[] = [];
    for (let i = 0; i < 24; i++) {
      data.push({
        hour: i,
        temperature: 22 + Math.sin(i / 24 * Math.PI * 2) * 4 + Math.random(),
        humidity: 55 + Math.cos(i / 24 * Math.PI * 2) * 10 + Math.random() * 5,
        energy: 0.1 + Math.random() * 0.3
      });
    }
    return data;
  }
}
