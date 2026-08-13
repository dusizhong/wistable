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

import { FC } from 'react';
import { colorVars, Select, Typography } from '@apitable/components';
import { t, Strings, getClientTimeZone, getTimeZone } from '@apitable/core';
import styles from './style.module.less';

const options = [
  {
    label: getClientTimeZone(),
    value: getTimeZone(),
  },
];

export const TimezoneSetting: FC = () => {
  return (
    <div className={styles.timezoneSetting}>
      <Typography variant="h7" className={styles.title}>
        {t(Strings.user_setting_time_zone_title)}
      </Typography>
      <Select
        options={options}
        value={getTimeZone()}
        dropdownMatchSelectWidth={false}
        triggerStyle={{ width: 200 }}
        searchPlaceholder={t(Strings.search)}
        highlightStyle={{ backgroundColor: colorVars.bgBrandLightDefault, color: 'inherit', borderRadius: '4px' }}
      />
    </div>
  );
};
