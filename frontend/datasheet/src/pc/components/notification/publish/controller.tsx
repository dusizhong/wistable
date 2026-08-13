/**
 * APITable <https://github.com/apitable/apitable>
 * Copyright (C) 2022 APITable Ltd. <https://apitable.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import { INoticeDetail, Navigation } from '@apitable/core';
import { navigationToUrl } from 'pc/components/route_manager/navigation_to_url';
import { Router } from 'pc/components/route_manager/router';
import { getPlatformType } from 'pc/utils/os';
import { showBannerAlert } from '../banner_alert';
import { isUserInOldVersionOrLocal, requestWebNotification, stringToActions } from '../utils';
// @ts-ignore
import { isSocialDingTalk } from 'enterprise/home/social_platform/utils';
// @ts-ignore
import { showVikaby } from 'enterprise/vikaby';

export interface IToast {
  btnText?: string;
  closable?: boolean;
  title?: string;
  content: string;
  destroyPrev?: boolean;
  duration?: number;
  onBtnClick?: string[] | (() => void);
  onClose?: string[] | (() => void);
  showVikaby?: boolean;
  url?: string | { text: string };
}

enum NotifyChannel {
  BANNER_ALERT = 'banner_alert',
  VIKABY_DIALOG = 'vikaby_dialog',
  WEB_NOTIFICATION = 'web_notification',
  NOTIFICATION_CENTER = 'notification_center',
}

const transformToastData = (toast: IToast, id: string) => {
  return {
    ...toast,
    id,
    onClose: () => {
      if (toast.onClose instanceof Array) {
        stringToActions(toast.onClose, id, toast.url);
      }
    },
    onBtnClick: () => {
      if (toast.onBtnClick instanceof Array) {
        stringToActions(toast.onBtnClick, id, toast.url);
      }
    },
  };
};

// For online users, all of them have to be processed, for offline users, only two types of ui need to be processed
export const PublishController = (props: INoticeDetail) => {
  const { notifyBody, id } = props;
  try {
    const { version, needVersionCompare, toast, channel, platform, socialPlatformType } = notifyBody.extras;
    // Applications that are not in the specified environment do not process notifications
    if (platform != null && platform !== getPlatformType()) {
      return;
    }
    const isVersionRuleTrue = !needVersionCompare || (needVersionCompare && version && isUserInOldVersionOrLocal(version));
    if (!isVersionRuleTrue) {
      return;
    }

    const isSocialRulePassed = socialPlatformType === 2 ? isSocialDingTalk?.() : true;

    const channelArr = channel.split(',');
    if (channelArr.length) {
      channelArr.forEach((uiKey: string) => {
        const ui = uiKey.trim();
        switch (ui) {
          case NotifyChannel.BANNER_ALERT:
            showBannerAlert({ ...transformToastData(toast, id) });
            break;
          case NotifyChannel.VIKABY_DIALOG:
            isSocialRulePassed &&
              showVikaby({
                defaultExpandDialog: true,
                dialogConfig: { ...transformToastData(toast, id) },
              });
            break;
          case NotifyChannel.WEB_NOTIFICATION:
            requestWebNotification({
              options: { body: toast.content },
              onClick: () => {
                if (!toast.url) {
                  Router.push(Navigation.HOME);
                } else {
                  navigationToConfigUrl(toast.url);
                }
              },
            });
            break;
          default:
            break;
        }
      });
    }
  } catch (_e) {}
};

export const navigationToConfigUrl = (configUrl: string) => {
  try {
    if (configUrl.startsWith('/')) {
      const url = new URL(configUrl, window.location.origin);
      navigationToUrl(url.href);
    } else if (configUrl.startsWith('http://') || configUrl.startsWith('https://')) {
      navigationToUrl(configUrl);
    } else {
      const url = new URL(configUrl, window.location.origin);
      navigationToUrl(url.href);
    }
  } catch (_e) {}
};

export const PublishControllers = (arr: INoticeDetail[]) => {
  if (!arr.length) return;
  arr.forEach((notify) => {
    PublishController(notify);
  });
};
