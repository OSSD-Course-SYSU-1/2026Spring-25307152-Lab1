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

/**
 * 设备类型枚举
 */
export enum DeviceType {
  LIGHT = 'light',
  AIR_CONDITIONER = 'ac',
  CURTAIN = 'curtain',
  SECURITY = 'security',
  PURIFIER = 'purifier',
  SOCKET = 'socket',
  SENSOR = 'sensor',
  CAMERA = 'camera'
}

/**
 * 房间枚举
 */
export enum RoomType {
  LIVING_ROOM = 'living_room',
  BEDROOM = 'bedroom',
  STUDY = 'study',
  KITCHEN = 'kitchen',
  BATHROOM = 'bathroom'
}

/**
 * 空调工作模式
 */
export enum ACMode {
  COOL = 0,
  HEAT = 1,
  FAN = 2,
  DRY = 3,
  AUTO = 4
}

/**
 * 安防布防模式
 */
export enum SecurityMode {
  AT_HOME = 0,
  AWAY = 1,
  SLEEP = 2
}

/**
 * 场景类型枚举
 */
export enum SceneType {
  HOME = 'home',
  AWAY = 'away',
  SLEEP = 'sleep',
  MOVIE = 'movie',
  READ = 'read'
}

/**
 * 手势类型
 */
export enum GestureType {
  CLICK = 'click',
  LONG_PRESS = 'long_press',
  SWIPE_LEFT = 'swipe_left',
  SWIPE_RIGHT = 'swipe_right',
  DOUBLE_TAP = 'double_tap',
  PINCH = 'pinch'
}

/**
 * 设备常量配置
 */
export class DeviceConstants {
  // 灯光配置
  static readonly LIGHT_BRIGHTNESS_MIN: number = 0;
  static readonly LIGHT_BRIGHTNESS_MAX: number = 100;
  static readonly LIGHT_TEMP_MIN: number = 2700;
  static readonly LIGHT_TEMP_MAX: number = 6500;

  // 空调配置
  static readonly AC_TEMP_MIN: number = 16;
  static readonly AC_TEMP_MAX: number = 30;
  static readonly AC_TEMP_DEFAULT: number = 26;

  // 窗帘配置
  static readonly CURTAIN_POS_MIN: number = 0;
  static readonly CURTAIN_POS_MAX: number = 100;

  // PM2.5阈值
  static readonly PM25_GOOD: number = 35;
  static readonly PM25_MODERATE: number = 75;

  // 手势识别阈值
  static readonly LONG_PRESS_TIME: number = 500;      // 长按500ms
  static readonly SWIPE_THRESHOLD: number = 50;       // 滑动50px
  static readonly DOUBLE_TAP_INTERVAL: number = 300;  // 双击间隔300ms

  // 房间名称映射
  static readonly ROOM_NAMES: Record<RoomType, string> = {
    [RoomType.LIVING_ROOM]: '客厅',
    [RoomType.BEDROOM]: '卧室',
    [RoomType.STUDY]: '书房',
    [RoomType.KITCHEN]: '厨房',
    [RoomType.BATHROOM]: '卫生间'
  };

  // 设备名称映射
  static readonly DEVICE_NAMES: Record<DeviceType, string> = {
    [DeviceType.LIGHT]: '灯光',
    [DeviceType.AIR_CONDITIONER]: '空调',
    [DeviceType.CURTAIN]: '窗帘',
    [DeviceType.SECURITY]: '安防',
    [DeviceType.PURIFIER]: '净化器',
    [DeviceType.SOCKET]: '插座',
    [DeviceType.SENSOR]: '传感器',
    [DeviceType.CAMERA]: '摄像头'
  };

  // 场景名称映射
  static readonly SCENE_NAMES: Record<SceneType, string> = {
    [SceneType.HOME]: '回家',
    [SceneType.AWAY]: '离家',
    [SceneType.SLEEP]: '睡眠',
    [SceneType.MOVIE]: '观影',
    [SceneType.READ]: '阅读'
  };
}
