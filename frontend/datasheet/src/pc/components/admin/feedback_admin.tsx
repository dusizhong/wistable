import React, { useEffect, useState, useCallback } from 'react';
import { Table, Input, Tag, message, Modal, Tooltip } from 'antd';
import { Api } from '@apitable/core';
import { SearchOutlined } from '@apitable/icons';
import { TextInput } from '@apitable/components';
import { useAppSelector } from 'pc/store/react-redux';
import { useRouter } from 'next/router';
import { useDebounce } from 'ahooks';
import dayjs from 'dayjs';

const FeedbackAdmin: React.FC = () => {
  const router = useRouter();
  const userInfo = useAppSelector((state) => state.user.info);
  const [loading, setLoading] = useState(false);
  const [list, setList] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [pageNo, setPageNo] = useState(1);
  const [pageSize] = useState(20);
  const [keyword, setKeyword] = useState('');
  const [searchValue, setSearchValue] = useState('');
  const debouncedSearch = useDebounce(searchValue, { wait: 300 });

  useEffect(() => {
    if (userInfo && userInfo.role !== 'admin') {
      router.replace('/workbench');
    }
  }, [userInfo, router]);

  useEffect(() => {
    setKeyword(debouncedSearch);
    setPageNo(1);
  }, [debouncedSearch]);

  const fetchList = useCallback(async () => {
    if (!userInfo || userInfo.role !== 'admin') return;
    setLoading(true);
    try {
      const res = await Api.getAdminFeedbackList({ pageNo, pageSize, keyword: keyword || undefined });
      const { success, data } = res.data;
      if (success && data) {
        setList(data.records || []);
        setTotal(data.total || 0);
      }
    } catch (e: any) {
      message.error(e?.message || '加载反馈列表失败');
    } finally {
      setLoading(false);
    }
  }, [pageNo, pageSize, keyword, userInfo]);

  useEffect(() => {
    fetchList();
  }, [fetchList]);

  const handleProcess = (record: any) => {
    Modal.confirm({
      title: '确认处理',
      content: `确定将「${record.nickName}」的反馈标记为已处理吗？`,
      okText: '确定',
      cancelText: '取消',
      onOk: async () => {
        try {
          await Api.adminProcessFeedback(record.id);
          message.success('已处理');
          fetchList();
        } catch (e: any) {
          message.error(e?.message || '处理失败');
        }
      },
    });
  };

  const columns = [
    {
      title: '序号',
      key: 'index',
      width: 60,
      align: 'center' as const,
      render: (_: any, __: any, index: number) => (pageNo - 1) * pageSize + index + 1,
    },
    { title: '反馈人', dataIndex: 'nickName', key: 'nickName', width: 120, ellipsis: true },
    { title: '邮箱', dataIndex: 'email', key: 'email', width: 180, ellipsis: true },
    { title: '反馈意见', dataIndex: 'content', key: 'content', width: 280, ellipsis: true },
    {
      title: '反馈时间',
      dataIndex: 'createdAt',
      key: 'createdAt',
      width: 160,
      render: (val: string) => val ? (
        <Tooltip title={dayjs(val).format('YYYY-MM-DD HH:mm:ss')}>{dayjs(val).format('YYYY-MM-DD')}</Tooltip>
      ) : '-',
    },
    {
      title: '处理时间',
      dataIndex: 'processedAt',
      key: 'processedAt',
      width: 160,
      render: (val: string) => val ? (
        <Tooltip title={dayjs(val).format('YYYY-MM-DD HH:mm:ss')}>{dayjs(val).format('YYYY-MM-DD')}</Tooltip>
      ) : '-',
    },
    {
      title: '状态',
      dataIndex: 'status',
      key: 'status',
      width: 100,
      render: (val: number) =>
        val === 1 ? <Tag color="green">已处理</Tag> : <Tag color="orange">未处理</Tag>,
    },
    {
      title: '操作',
      key: 'action',
      width: 100,
      render: (_: any, record: any) =>
        record.status === 0 ? (
          <a onClick={() => handleProcess(record)}>处理</a>
        ) : null,
    },
  ];

  return (
    <div style={{ padding: '24px 16px', height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <h2 style={{ margin: '0 0 16px' }}>反馈管理</h2>
      <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'flex-end' }}>
        <div style={{ width: 320 }}>
          <TextInput
            size="small"
            placeholder="搜索昵称、邮箱或反馈内容"
            value={searchValue}
            onChange={(e) => setSearchValue(e.target.value)}
            prefix={<SearchOutlined />}
            block
          />
        </div>
      </div>
      <div style={{ flex: 1, overflow: 'auto' }}>
        <Table
          rowKey="id"
          columns={columns}
          dataSource={list}
          loading={loading}
          scroll={{ x: 'max-content' }}
          pagination={{
            current: pageNo,
            pageSize,
            total,
            onChange: (p) => setPageNo(p),
            showSizeChanger: false,
            showTotal: (t) => `共 ${t} 条反馈`,
          }}
        />
      </div>
    </div>
  );
};

export default FeedbackAdmin;
