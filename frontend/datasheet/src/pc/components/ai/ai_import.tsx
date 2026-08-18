/**
 * AI 智能导入：文档类别 + 拖拽上传 → 解析 → 字段预览 → 确认写回表格。
 *
 * 由右侧 AI 抽屉承载（不再是独立 Modal），dstId 为当前打开的表格。
 */
import { Button, Select, Spin, Table, Upload } from 'antd';
import { FC, useState } from 'react';
import { useThemeColors } from '@apitable/components';
import { Strings, t } from '@apitable/core';
import { ImportOutlined } from '@apitable/icons';
import { Message } from 'pc/components/common';

const { Dragger } = Upload;

export interface IAiImportProps {
  dstId: string;
}

interface IAiRecord {
  [key: string]: any;
}

export const AiImport: FC<IAiImportProps> = ({ dstId }) => {
  const colors = useThemeColors();
  const [category, setCategory] = useState('invoice');
  const [parsing, setParsing] = useState(false);
  const [committing, setCommitting] = useState(false);
  const [errMsg, setErrMsg] = useState('');
  const [records, setRecords] = useState<IAiRecord[]>([]);
  const [markdown, setMarkdown] = useState('');
  const [fileName, setFileName] = useState('');

  const categories = [
    { value: 'invoice', label: t(Strings.ai_import_category_invoice) },
    { value: 'bid', label: t(Strings.ai_import_category_bid) },
    { value: 'other', label: t(Strings.ai_import_category_other) },
  ];

  const reset = () => {
    setRecords([]);
    setMarkdown('');
    setFileName('');
    setErrMsg('');
  };

  const parseFile = async (file: File) => {
    setParsing(true);
    setErrMsg('');
    try {
      const fd = new FormData();
      fd.append('file', file);
      fd.append('dst_id', dstId);
      fd.append('category', category);
      const res = await fetch('/ai/import/parse', { method: 'POST', body: fd });
      const body = await res.json();
      if (!body.success) {
        setErrMsg(body.message || '解析失败');
        return;
      }
      setFileName(file.name);
      setMarkdown(body.data?.markdown || '');
      setRecords(body.data?.records || []);
    } catch (e: any) {
      setErrMsg(e?.message || '解析失败，请确认 AI 服务已启动');
    } finally {
      setParsing(false);
    }
  };

  const commit = async () => {
    setCommitting(true);
    setErrMsg('');
    try {
      const res = await fetch('/ai/import/commit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ dst_id: dstId, records }),
      });
      const body = await res.json();
      if (!body.success) {
        setErrMsg(body.message || '写入失败');
        return;
      }
      Message.success({ content: `成功导入 ${body.data?.count ?? records.length} 条记录` });
      reset();
    } catch (e: any) {
      setErrMsg(e?.message || '写入失败');
    } finally {
      setCommitting(false);
    }
  };

  const columns = records.length ? Object.keys(records[0]).map((k) => ({ title: k, dataIndex: k, ellipsis: true })) : [];

  return (
    <div>
      <div style={{ marginBottom: 12 }}>
        <div style={{ marginBottom: 4, color: colors.thirdLevelText }}>{t(Strings.ai_import_category)}</div>
        <Select value={category} onChange={setCategory} style={{ width: '100%' }} disabled={parsing || committing}>
          {categories.map((c) => (
            <Select.Option key={c.value} value={c.value}>
              {c.label}
            </Select.Option>
          ))}
        </Select>
      </div>

      {!records.length ? (
        <div>
          <Dragger
            accept=".pdf,.png,.jpg,.jpeg,.webp"
            showUploadList={false}
            disabled={parsing}
            customRequest={({ file }: any) => parseFile(file as File)}
          >
            <div>
              <ImportOutlined size={50} color={colors.fourthLevelText} />
            </div>
            <div style={{ marginTop: 8 }}>点击或拖拽 PDF / 图片到此处</div>
            <div style={{ color: colors.fourthLevelText, marginTop: 4, fontSize: 12 }}>AI 自动提取字段，导入到当前表格</div>
          </Dragger>
          {parsing && (
            <div style={{ marginTop: 16, textAlign: 'center' }}>
              <Spin size="large" />
              <div style={{ marginTop: 12, color: colors.thirdLevelText }}>正在解析文档，大文件可能需要较长时间，请稍候…</div>
            </div>
          )}
        </div>
      ) : (
        <div>
          <div style={{ marginBottom: 12, color: colors.thirdLevelText }}>
            已解析 <b>{records.length}</b> 条记录{fileName ? `（${fileName}）` : ''}
          </div>
          <Table
            size="small"
            columns={columns}
            dataSource={records.map((r, i) => ({ ...r, key: i }))}
            pagination={records.length > 10 ? { pageSize: 10 } : false}
            scroll={{ x: 'max-content', y: 320 }}
          />
          {markdown && (
            <details style={{ marginTop: 12 }}>
              <summary style={{ cursor: 'pointer', color: colors.thirdLevelText }}>查看解析原文</summary>
              <pre style={{ maxHeight: 200, overflow: 'auto', whiteSpace: 'pre-wrap', fontSize: 12, marginTop: 8 }}>{markdown}</pre>
            </details>
          )}
        </div>
      )}

      {errMsg && <div style={{ color: colors.errorColor, marginTop: 12 }}>{errMsg}</div>}

      {records.length > 0 && (
        <div style={{ marginTop: 16, display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
          <Button onClick={reset}>重新上传</Button>
          <Button type="primary" loading={committing} onClick={commit}>
            确认导入 {records.length} 条
          </Button>
        </div>
      )}
    </div>
  );
};
