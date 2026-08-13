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
import { Typography, useThemeColors } from '@apitable/components';
import { t, Strings } from '@apitable/core';
import { CopyOutlined } from '@apitable/icons';
import { Message, Avatar, Tooltip } from 'pc/components/common';
import { AvatarSize, AvatarType } from 'pc/components/common/avatar';
import { useAppSelector } from 'pc/store/react-redux';
import { copy2clipBoard } from 'pc/utils';
import styles from './style.module.less';

export const SpaceInfoPopover: FC<React.PropsWithChildren<unknown>> = () => {
  const { spaceInfo, spaceId, userInfo } = useAppSelector(
    (state) => ({
      spaceInfo: state.space.curSpaceInfo,
      spaceId: state.space.activeId || '',
      userInfo: state.user.info,
    }),
  );

  const colors = useThemeColors();

  if (!spaceInfo || !userInfo) return null;

  const { ownerName } = spaceInfo;

  return (
    <div className={styles.spaceBaseInfoPopover}>
      <Avatar title={spaceInfo.spaceName} size={AvatarSize.Size40} id={userInfo.spaceId} src={spaceInfo.spaceLogo} type={AvatarType.Space} />
      <Tooltip title={spaceInfo.spaceName} placement="top" textEllipsis>
        <div className={styles.spaceName}>{spaceInfo.spaceName}</div>
      </Tooltip>

      <div className={styles.sepLine} />

      <Typography variant="body3" className={styles.item}>
        <span className={styles.label}>{t(Strings.primary_admin)}：</span>
        {ownerName}
      </Typography>
      <Typography variant="body3" className={styles.item}>
        <span className={styles.label}>{t(Strings.space_id)}：</span>
        {spaceId}
        <span onClick={() => copy2clipBoard(spaceId, () => Message.success({ content: t(Strings.copy_success) }))}>
          <CopyOutlined size={16} color={colors.textCommonPrimary} className={styles.copy} />
        </span>
      </Typography>
    </div>
  );
};
