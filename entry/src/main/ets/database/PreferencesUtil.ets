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

import dataPreferences from '@ohos.data.preferences';

const PREFERENCES_NAME = 'LiveCardPreferences';
const KEY_DEVICE_STATE = 'deviceState';

class PreferencesUtil {
  private preferences: dataPreferences.Preferences | null = null;

  async init(context: Context): Promise<void> {
    this.preferences = await dataPreferences.getPreferences(context, PREFERENCES_NAME);
  }

  async putDeviceState(state: string): Promise<void> {
    if (this.preferences) {
      await this.preferences.put(KEY_DEVICE_STATE, state);
      await this.preferences.flush();
    }
  }

  async getDeviceState(): Promise<string> {
    if (this.preferences) {
      return await this.preferences.get(KEY_DEVICE_STATE, '') as string;
    }
    return '';
  }
}

export default new PreferencesUtil();
