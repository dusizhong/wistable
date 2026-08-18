/**
 * 智能问数（Phase 2）：占位。Phase 1 验收通过后再实现。
 */
import { FC } from 'react';
import { useThemeColors } from '@apitable/components';
import { Strings, t } from '@apitable/core';

export const AiAsk: FC = () => {
  const colors = useThemeColors();
  return (
    <div style={{ padding: '48px 24px', textAlign: 'center', color: colors.thirdLevelText }}>
      <div style={{ fontSize: 16, marginBottom: 8 }}>{t(Strings.ai_panel_ask_tab)}</div>
      <div style={{ fontSize: 13 }}>{t(Strings.ai_panel_ask_coming)}</div>
    </div>
  );
};
