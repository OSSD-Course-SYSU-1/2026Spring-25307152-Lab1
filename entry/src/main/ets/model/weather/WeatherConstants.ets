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
 * 天气类型枚举
 */
export enum WeatherType {
  SUNNY = 'sunny',
  CLOUDY = 'cloudy',
  RAINY = 'rainy',
  SNOWY = 'snowy'
}

/**
 * 城市信息
 */
export interface CityInfo {
  id: string;
  name: string;
  defaultWeather: WeatherType;
  defaultTemp: number;
}

/**
 * 天气常量配置
 */
export class WeatherConstants {
  // 支持的城市列表
  static readonly CITIES: CityInfo[] = [
    { id: 'beijing', name: '北京', defaultWeather: WeatherType.SUNNY, defaultTemp: 25 },
    { id: 'shanghai', name: '上海', defaultWeather: WeatherType.CLOUDY, defaultTemp: 28 },
    { id: 'guangzhou', name: '广州', defaultWeather: WeatherType.RAINY, defaultTemp: 32 },
    { id: 'shenzhen', name: '深圳', defaultWeather: WeatherType.RAINY, defaultTemp: 31 },
    { id: 'chengdu', name: '成都', defaultWeather: WeatherType.CLOUDY, defaultTemp: 26 }
  ];

  // 卡片尺寸
  static readonly CARD_WIDTH: number = 360;
  static readonly CARD_HEIGHT: number = 720;

  // 动画配置
  static readonly PARTICLE_COUNT: number = 100;
  static readonly ANIMATION_DURATION: number = 3000;

  // 路由名称
  static readonly ROUTE_WEATHER_PAGE: string = 'WeatherPage';
}
