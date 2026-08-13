import { colors } from '@apitable/components';
import { SpaceInfoFilled } from '@apitable/icons';
import { ThemeIcon } from 'pc/components/common/theme_icon/theme_icon';

export const DELETE_SPACE_CONTEXT_MENU_ID = 'DELETE_SPACE_CONTEXT_MENU_ID';

export const getPercent = (percent: number) => {
  if (percent <= 0) {
    return 0;
  }
  if (percent < 0.01 && percent < 1) {
    return 0.01;
  }
  if (percent >= 1) {
    return 1;
  }
  return percent;
};

const defaultConfig = {
  strokeColor: colors.primaryColor,
  trailColor: colors.fc5,
  hightLightColor: colors.primaryColor,
  spaceLevelTag: {
    label: null,
    logo: <ThemeIcon darkIcon={<SpaceInfoFilled size={20} />} lightIcon={<SpaceInfoFilled size={20} />} />,
  },
};

export const SpaceLevelInfo: Record<string, typeof defaultConfig> = new Proxy(
  {},
  {
    get: () => defaultConfig,
  },
);
