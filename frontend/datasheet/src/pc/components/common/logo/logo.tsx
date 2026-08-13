import classnames from 'classnames';
import { ThemeName } from '@apitable/components';
import { getAssetUrl } from '@apitable/core';

import { getEnvVariables } from 'pc/utils/env';

import styles from './styles.module.less';

const LogoSize = {
  mini: {
    logoSize: 16,
  },
  small: {
    logoSize: 24,
  },
  large: {
    logoSize: 32,
  },
};

interface ILogoProps {
  className?: string;
  text?: boolean;
  size?: 'mini' | 'small' | 'large' | number;
  theme?: ThemeName;
  type?: 'LOGO' | 'SHARE_LOGO';
}

export const Logo: React.FC<React.PropsWithChildren<ILogoProps>> = (props) => {
  const { size = 'small', className, type = 'LOGO' } = props;
  const logoSize = typeof size === 'number' ? { logoSize: size } : LogoSize[size];
  const envVars = getEnvVariables();

  return (
    <span className={classnames(styles.logo, className)}>
      <img
        alt="logo"
        src={getAssetUrl(envVars[type] || envVars.LOGO)}
        style={{ display: 'block', height: `${logoSize.logoSize}px` }}
        width={logoSize.logoSize}
      />
    </span>
  );
};
