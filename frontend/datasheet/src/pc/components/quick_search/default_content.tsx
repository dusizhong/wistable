import { Box, Typography } from '@apitable/components';
import { Strings, t } from '@apitable/core';
import styles from './style.module.less';

export const DefaultContent = () => {
  return (
    <div className={styles.defaultContent}>
      <Typography style={{ paddingBottom: 8 }} align="center" variant={'h7'}>
        {t(Strings.quick_search_title)}
      </Typography>
      <Typography variant={'body3'}>{t(Strings.quick_search_intro)}</Typography>
    </div>
  );
};
