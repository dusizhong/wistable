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

import type { StringKeysMapType, StringKeysType } from '../../config/stringkeys.interface';
import ZHCN_DATA from '@apitable/i18n-lang/src/config/strings.zh-CN.json';

export { StringKeysMapType, StringKeysType };

declare const window: any;
declare const global: any;

const _global = global || window;

export function getLanguage() {
  return 'zh-CN';
}

export const Strings = new Proxy({} as Record<keyof StringKeysMapType, string>, {
  get: function (_target, key: string) {
    return key;
  },
}) as StringKeysType;

const currentLang = 'zh-CN';
_global.currentLang = currentLang;

export function t(stringKey: keyof StringKeysMapType | unknown, options: any = null, _isPlural = false): string {
  const text = (ZHCN_DATA as Record<string, string>)[stringKey as string] || (stringKey as string);
  if (!options || typeof text !== 'string') {
    return text;
  }
  // Interpolate `${var}` placeholders with values from `options`.
  return text.replace(/\$\{([\w$]+)\}/g, (match: string, name: string) => {
    const value = options[name];
    return value == null ? match : String(value);
  });
}

