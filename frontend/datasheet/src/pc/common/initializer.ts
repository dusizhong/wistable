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

/*
 * Initialization functions, used for some non-constructor type things that need to be initialized and executed at startup again
 */
import { handleResponse, initAxios } from 'api/utils/init_axios';
import dayjs from 'dayjs';
import { getLanguage, injectStore } from '@apitable/core';

import '../../modules/shared/apphook/hook_bindings';
import { APITable } from '../../modules/shared/apitable_lib';
import { initCronjobs } from './cronjob';
import './store_subscribe';

declare let window: any;
if (!process.env.SSR && window !== undefined) {
  window.APITable = APITable;
}

function initDayjs(comlink: any) {
  let lang = getLanguage() || 'zh-cn';
  lang = lang.toLowerCase().replace('_', '-');
  dayjs.locale(lang);
  comlink.proxy?.initHook(lang);
}

export function initializer(comlink: any) {
  initAxios(comlink.store);

  window.__global_handle_response = handleResponse;

  // Initialisation Field.bindModel
  injectStore(comlink.store);
  initCronjobs(comlink.store);
  initDayjs(comlink);
}

