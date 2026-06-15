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

import { WeatherType, WeatherConstants } from '../../model/weather/WeatherConstants';
import { WeatherData } from '../../model/weather/WeatherData';
import FormUtils from '../../utils/FormUtils';

@Entry
@Component
struct WeatherCard {
  @LocalStorageProp('cityId') cityId: string = 'beijing';
  @LocalStorageProp('weatherType') weatherType: WeatherType = WeatherType.SUNNY;
  @State weatherData: WeatherData = new WeatherData();

  build() {
    Column() {
      // 城市名称 - 点击切换城市
      Text(this.weatherData.city)
        .fontSize(16)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          this.changeCity();
        });

      // 天气图标 - 点击切换天气类型
      Image(this.getWeatherIcon())
        .width(64)
        .height(64)
        .margin({ top: 8 })
        .onClick(() => {
          this.toggleWeatherType();
        });

      // 温度
      Text(`${this.weatherData.temperature}°`)
        .fontSize(48)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Light)
        .margin({ top: 4 });

      // 天气描述
      Text(this.weatherData.getWeatherTypeName())
        .fontSize(14)
        .fontColor(Color.White);

      // 点击主区域激活互动卡片
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .justifyContent(FlexAlign.Center)
    .backgroundImage(this.getBackgroundImage())
    .backgroundImageSize(ImageSize.Cover)
    .onClick(() => {
      this.requestLiveCard();
    });
  }

  private getWeatherIcon(): Resource {
    // 根据天气类型返回对应图标
    return $r('app.media.ic_weather_sunny');
  }

  private getBackgroundImage(): Resource {
    // 根据天气类型返回对应背景
    return $rawfile('weather/sunny_bg.png');
  }

  private toggleWeatherType(): void {
    // 循环切换天气类型
    const types = [WeatherType.SUNNY, WeatherType.CLOUDY, WeatherType.RAINY, WeatherType.SNOWY];
    const currentIndex = types.indexOf(this.weatherType);
    this.weatherType = types[(currentIndex + 1) % types.length];
    this.weatherData.weatherType = this.weatherType;
  }

  private changeCity(): void {
    // 切换到下一个城市
    const cities = WeatherConstants.CITIES;
    const currentIndex = cities.findIndex(c => c.id === this.cityId);
    const nextCity = cities[(currentIndex + 1) % cities.length];

    this.cityId = nextCity.id;
    this.weatherData.city = nextCity.name;
    this.weatherData.temperature = nextCity.defaultTemp;
    this.weatherData.weatherType = nextCity.defaultWeather;

    // 更新卡片数据
    FormUtils.updateWeatherCard(this.cityId, this.weatherData);
  }

  private requestLiveCard(): void {
    // 请求激活互动卡片溢出动画
    FormUtils.requestWeatherLiveCard(this.cityId);
  }
}
