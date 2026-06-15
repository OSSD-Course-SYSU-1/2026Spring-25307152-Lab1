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

import type { UIExtensionContentSession } from '@ohos.arkui.UIExtensionContext';
import type { LiveFormInfo } from '@ohos.app.form.liveForm';
import LiveFormExtensionAbility from '@ohos.app.form.LiveFormExtensionAbility';
import { DeviceStateMachine } from '../model/smarthome/DeviceStateMachine';

export default class SmartHomeLiveCardAbility extends LiveFormExtensionAbility {
  onLiveFormCreate(liveFormInfo: LiveFormInfo, session: UIExtensionContentSession): void {
    let storage: LocalStorage = new LocalStorage();
    storage.setOrCreate('context', this.context);
    storage.setOrCreate('session', session);
    storage.setOrCreate('formId', liveFormInfo.formId);
    storage.setOrCreate('borderRadius', liveFormInfo.borderRadius);
    storage.setOrCreate('formRect', liveFormInfo.rect);
    storage.setOrCreate('stateMachine', DeviceStateMachine.getInstance());

    session.loadContent('livecardability/pages/SmartHomeLiveCard', storage);
  }
}
