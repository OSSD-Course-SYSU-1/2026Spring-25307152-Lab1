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

import { WeatherType } from './WeatherConstants';

/**
 * 每日预报数据
 */
export interface ForecastDay {
  date: string;
  icon: Resource;
  high: number;
  low: number;
  weatherType: WeatherType;
}

/**
 * 天气数据模型
 */
export class WeatherData {
  city: string = '北京';
  cityId: string = 'beijing';
  weatherType: WeatherType = WeatherType.SUNNY;
  temperature: number = 25;
  temperatureHigh: number = 30;
  temperatureLow: number = 20;
  humidity: number = 65;
  windLevel: string = '3级';
  windDirection: string = '东北风';
  aqi: number = 52;
  aqiLevel: string = '良';
  updateTime: string = '';
  forecast: ForecastDay[] = [];

  constructor() {
    this.updateTime = new Date().toLocaleString();
    this.initForecast();
  }

  /**
   * 获取天气类型名称
   */
  getWeatherTypeName(): string {
    const typeMap = {
      [WeatherType.SUNNY]: '晴天',
      [WeatherType.CLOUDY]: '多云',
      [WeatherType.RAINY]: '雨天',
      [WeatherType.SNOWY]: '雪天'
    };
    return typeMap[this.weatherType] || '未知';
  }

  /**
   * 获取AQI等级颜色
   */
  getAqiColor(): string {
    if (this.aqi <= 50) return '#00e400';
    if (this.aqi <= 100) return '#ffff00';
    if (this.aqi <= 150) return '#ff7e00';
    if (this.aqi <= 200) return '#ff0000';
    return '#7e0023';
  }

  /**
   * 初始化7天预报
   */
  private initForecast(): void {
    const weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    const today = new Date().getDay();

    for (let i = 0; i < 7; i++) {
      const dayIndex = (today + i) % 7;
      this.forecast.push({
        date: weekDays[dayIndex],
        icon: $r('app.media.ic_weather_sunny'),
        high: 28 + Math.floor(Math.random() * 5),
        low: 20 + Math.floor(Math.random() * 5),
        weatherType: WeatherType.SUNNY
      });
    }
  }
}
