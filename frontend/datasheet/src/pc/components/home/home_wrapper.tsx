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

import { Typography, useThemeColors } from '@apitable/components';
import { getAssetUrl } from '@apitable/core';
import { getEnvVariables } from 'pc/utils/env';
import { ActionType } from './pc_home';
import styles from './style.module.less';

interface IHomeWrapper {
  action?: ActionType
}

export const HomeWrapper: React.FC<React.PropsWithChildren<IHomeWrapper>> = ({ children }) => {
  const colors = useThemeColors();

  const logo = getEnvVariables().LOGIN_LOGO!;

  return (
    <div className={styles.pcHome}>
      <div className={styles.header}>
        <div className={styles.brand}>
          <img src={getAssetUrl(logo)} height={28} width={28} className={styles.logo} alt="logo" />
          <Typography variant={'h4'} color={colors.textCommonPrimary}>
            智能表格系统
          </Typography>
        </div>
      </div>
      <div className={styles.main}>{children}</div>
      <div className={styles.footer}>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2 }}>
          <Typography variant={'body4'} color={colors.textCommonSecondary} style={{ fontSize: 12 }}>
            智能表格系统 v1.0
          </Typography>
          <Typography variant={'body4'} color={colors.textCommonTertiary} style={{ fontSize: 9, opacity: 0.5 }}>
            Powered by APITable
          </Typography>
        </div>
      </div>
    </div>
  );
};
