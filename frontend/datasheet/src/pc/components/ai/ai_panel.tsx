/**
 * AI 助手右侧抽屉：融合「智能导入」与「智能问数」两个 Tab。
 * overlay 式 Drawer，不推挤表格网格，符合主流 AI 对话侧栏习惯。
 */
import { Drawer, Tabs } from 'antd';
import { FC, useState } from 'react';
import { IconButton, useThemeColors } from '@apitable/components';
import { Strings, t } from '@apitable/core';
import { AiFilled, CloseOutlined } from '@apitable/icons';
import { AiAsk } from './ai_ask';
import { AiImport } from './ai_import';

export interface IAiPanelProps {
  dstId: string;
  onClose: () => void;
}

export const AiPanel: FC<IAiPanelProps> = ({ dstId, onClose }) => {
  const [tab, setTab] = useState('import');
  const colors = useThemeColors();

  return (
    <Drawer
      title={
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', width: '100%' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <AiFilled size={20} color={colors.primaryColor} />
            <span>{t(Strings.ai_panel_title)}</span>
          </div>
          <IconButton shape="square" onClick={onClose} icon={CloseOutlined} />
        </div>
      }
      placement="right"
      width={480}
      open
      closable={false}
      mask={false}
      onClose={onClose}
      headerStyle={{ padding: '16px 16px 16px 24px' }}
      bodyStyle={{ padding: 16 }}
    >
      <Tabs activeKey={tab} onChange={setTab}>
        <Tabs.TabPane tab={t(Strings.ai_panel_import_tab)} key="import">
          <AiImport dstId={dstId} />
        </Tabs.TabPane>
        <Tabs.TabPane tab={t(Strings.ai_panel_ask_tab)} key="ask">
          <AiAsk />
        </Tabs.TabPane>
      </Tabs>
    </Drawer>
  );
};
