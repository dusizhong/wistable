import { ISpaceBasicInfo, ISpaceFeatures } from '@apitable/core';

export interface ILayoutProps {
  showContextMenu: (e: React.MouseEvent<HTMLElement>) => void;
  handleDelSpace: () => void;
  spaceId: string;
  spaceInfo: ISpaceBasicInfo;
  spaceFeatures: ISpaceFeatures;
  subscription: any;
  isMobile?: boolean;
}

export interface IHooksParams {
  spaceInfo?: ISpaceBasicInfo;
  subscription?: any;
}

export interface IHooksResult {
  used: number;
  usedText: string;
  total: number;
  totalText: string;
  remain: number;
  usedPercent: number;
  remainPercent: number;
  remainText: string;
}

export interface IMultiLineItemProps {
  unit: string;
  total?: number;
  used?: number;
  name: string;
  icon: React.ReactNode;
  percent?: number;
  showProgress?: boolean;
  customIntro?: React.ReactNode;
}
