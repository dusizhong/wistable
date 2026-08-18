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

/* eslint-disable max-len */
import React from 'react';
import { makeIcon, IIconProps } from '../utils/icon';

export const AiOutlined: React.FC<IIconProps> = makeIcon({
  Path: ({ colors }) => <>
    <path d="M8 1.2L9.3 6.7L14.8 8L9.3 9.3L8 14.8L6.7 9.3L1.2 8L6.7 6.7ZM8 4.6L8.65 7.35L11.4 8L8.65 8.65L8 11.4L7.35 8.65L4.6 8L7.35 7.35Z" fill={ colors[0] } fillRule="evenodd" clipRule="evenodd"/>

  </>,
  name: 'ai_outlined',
  defaultColors: ['#D9D9D9'],
  colorful: false,
  allPathData: ['M8 1.2L9.3 6.7L14.8 8L9.3 9.3L8 14.8L6.7 9.3L1.2 8L6.7 6.7ZM8 4.6L8.65 7.35L11.4 8L8.65 8.65L8 11.4L7.35 8.65L4.6 8L7.35 7.35Z'],
  width: '16',
  height: '16',
  viewBox: '0 0 16 16',
});
