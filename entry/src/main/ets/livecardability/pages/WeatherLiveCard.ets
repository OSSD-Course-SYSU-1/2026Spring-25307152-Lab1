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

import { WeatherType } from '../../model/weather/WeatherConstants';
import { WeatherData } from '../../model/weather/WeatherData';

@Component
export struct WeatherLiveCard {
  @LocalStorageProp('weatherData') weatherData: WeatherData = new WeatherData();
  @State currentWeather: WeatherType = WeatherType.SUNNY;
  @State showForecast: boolean = false;

  build() {
    Stack() {
      // 天气背景
      this.WeatherBackground();

      Column() {
        // 天气粒子动画层
        this.WeatherParticleLayer();

        // 天气信息面板
        this.WeatherInfoPanel();

        // 7天预报
        if (this.showForecast) {
          this.SevenDayForecast();
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent);
  }

  @Builder
  WeatherBackground() {
    // 根据天气类型显示不同背景
    Image(this.getBackgroundResource())
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Cover);
  }

  @Builder
  WeatherParticleLayer() {
    // 雨滴/雪花粒子动画系统
    Canvas(this.weatherCanvas)
      .width('100%')
      .height('100%')
      .onReady(() => {
        this.startParticleAnimation();
      });
  }

  @Builder
  WeatherInfoPanel() {
    Column() {
      Text(this.weatherData.city)
        .fontSize(24)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold);

      Text(`${this.weatherData.temperature}°`)
        .fontSize(72)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Light);

      Text(this.weatherData.getWeatherTypeName())
        .fontSize(18)
        .fontColor(Color.White);

      Row() {
        Text(`湿度: ${this.weatherData.humidity}%`)
          .fontSize(14)
          .fontColor(Color.White);
        Text(`风力: ${this.weatherData.windLevel}`)
          .fontSize(14)
          .fontColor(Color.White)
          .margin({ left: 20 });
      }
      .margin({ top: 10 });
    }
    .padding(20);
  }

  @Builder
  SevenDayForecast() {
    // 7天天气预报组件
    Row() {
      ForEach(this.weatherData.forecast, (day) => {
        Column() {
          Text(day.date)
            .fontSize(12)
            .fontColor(Color.White);
          Image(day.icon)
            .width(32)
            .height(32);
          Text(`${day.high}°/${day.low}°`)
            .fontSize(12)
            .fontColor(Color.White);
        }
        .padding(8);
      });
    }
    .backgroundColor('rgba(0, 0, 0, 0.3)')
    .borderRadius(16)
    .padding(12);
  }

  private getBackgroundResource(): Resource {
    // 返回对应天气的背景资源
    return $rawfile('weather/sunny_bg.png');
  }

  private startParticleAnimation(): void {
    // 启动粒子动画系统
  }
}
