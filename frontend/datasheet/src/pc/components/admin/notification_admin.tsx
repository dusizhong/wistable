/**
 * 系统管理员「通知管理」页面组件。
 * 提供通知草稿的增删改查，以及发送全局通知功能。
 * 已发送的通知不可编辑、不可删除。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

import React, { useEffect, useState, useCallback } from 'react';
import { Table, Input, Modal, message, Space, Tag, Button as AntButton } from 'antd';
import { Button } from '@apitable/components';
import { SearchOutlined } from '@apitable/icons';
import { Api } from '@apitable/core';
import { useAppSelector } from 'pc/store/react-redux';
import { useRouter } from 'next/router';
import { useDebounce } from 'ahooks';

const { TextArea } = Input;

const NotificationAdmin: React.FC = () => {
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

  const [editModal, setEditModal] = useState<{ visible: boolean; isNew: boolean; record: any }>({
    visible: false, isNew: false, record: null,
  });
  const [formData, setFormData] = useState({ title: '', content: '', url: '' });

  useEffect(() => {
    setKeyword(debouncedSearch);
    setPageNo(1);
  }, [debouncedSearch]);

  useEffect(() => {
    if (userInfo && userInfo.role !== 'admin') {
      router.replace('/workbench');
    }
  }, [userInfo, router]);

  const fetchList = useCallback(async () => {
    if (!userInfo || userInfo.role !== 'admin') return;
    setLoading(true);
    try {
      const res = await Api.getAdminNotificationList({ pageNo, pageSize, keyword: keyword || undefined });
      const { success, data } = res.data;
      if (success && data) {
        setList(data.records || []);
        setTotal(data.total || 0);
      }
    } catch (e: any) {
      message.error(e?.message || '加载通知列表失败');
    } finally {
      setLoading(false);
    }
  }, [pageNo, pageSize, keyword, userInfo]);

  useEffect(() => {
    fetchList();
  }, [fetchList]);

  const openCreateModal = () => {
    setFormData({ title: '', content: '', url: '' });
    setEditModal({ visible: true, isNew: true, record: null });
  };

  const openEditModal = (record: any) => {
    setFormData({ title: record.title, content: record.content, url: record.url || '' });
    setEditModal({ visible: true, isNew: false, record });
  };

  const handleSave = async () => {
    if (!formData.title || !formData.content) {
      message.warning('标题和内容不能为空');
      return;
    }
    try {
      if (editModal.isNew) {
        await Api.adminCreateNotification(formData);
        message.success('通知创建成功');
      } else {
        await Api.adminUpdateNotification(editModal.record.id, formData);
        message.success('通知更新成功');
      }
      setEditModal({ visible: false, isNew: false, record: null });
      fetchList();
    } catch (e: any) {
      message.error(e?.message || '保存失败');
    }
  };

  const handleDelete = (record: any) => {
    Modal.confirm({
      title: '确认删除',
      content: `确定要删除通知「${record.title}」吗？`,
      onOk: async () => {
        try {
          await Api.adminDeleteNotification(record.id);
          message.success('删除成功');
          fetchList();
        } catch (e: any) {
          message.error(e?.message || '删除失败');
        }
      },
    });
  };

  const handleSend = (record: any) => {
    Modal.confirm({
      title: '确认发送',
      content: `确定要发送通知「${record.title}」给所有用户吗？发送后不可撤销。`,
      onOk: async () => {
        try {
          await Api.adminSendNotification(record.id);
          message.success('通知已发送，正在推送给所有用户');
          fetchList();
        } catch (e: any) {
          message.error(e?.message || '发送失败');
        }
      },
    });
  };

  const columns = [
    {
      title: 'ID',
      dataIndex: 'id',
      width: 80,
    },
    {
      title: '标题',
      dataIndex: 'title',
      width: 180,
      ellipsis: true,
    },
    {
      title: '内容',
      dataIndex: 'content',
      width: 200,
      ellipsis: true,
    },
    {
      title: '跳转链接',
      dataIndex: 'url',
      width: 140,
      ellipsis: true,
      render: (val: string) => val || '-',
    },
    {
      title: '状态',
      dataIndex: 'status',
      width: 100,
      render: (val: number) =>
        val === 1 ? <Tag color="green">已发送</Tag> : <Tag>草稿</Tag>,
    },
    {
      title: '发送时间',
      dataIndex: 'updatedAt',
      width: 180,
      render: (val: string, record: any) =>
        record.status === 1 ? val : '-',
    },
    {
      title: '操作',
      width: 240,
      render: (_: any, record: any) => {
        const isDraft = record.status === 0;
        return (
          <Space size="small">
            {isDraft ? (
              <>
                <AntButton type="link" size="small" onClick={() => openEditModal(record)}>
                  编辑
                </AntButton>
                <AntButton type="link" size="small" danger onClick={() => handleDelete(record)}>
                  删除
                </AntButton>
                <AntButton type="link" size="small" onClick={() => handleSend(record)}>
                  发送
                </AntButton>
              </>
            ) : (
              <AntButton type="link" size="small" onClick={() => openEditModal(record)} disabled>
                已发送
              </AntButton>
            )}
          </Space>
        );
      },
    },
  ];

  return (
    <div style={{ padding: '24px 16px', height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <h2 style={{ margin: '0 0 16px' }}>通知管理</h2>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
        <Button color="primary" onClick={openCreateModal}>新建通知</Button>
        <Input
          placeholder="搜索标题..."
          prefix={<SearchOutlined />}
          value={searchValue}
          onChange={(e) => setSearchValue(e.target.value)}
          allowClear
          style={{ width: 280 }}
        />
      </div>

      <div style={{ flex: 1, overflow: 'auto' }}>
        <Table
          dataSource={list}
          columns={columns}
          rowKey="id"
          loading={loading}
          scroll={{ x: 'max-content' }}
          pagination={{
            current: pageNo,
            pageSize,
            total,
            showSizeChanger: false,
            onChange: (p) => setPageNo(p),
          }}
        />
      </div>

      <Modal
        title={editModal.isNew ? '新建通知' : '编辑通知'}
        open={editModal.visible}
        onCancel={() => setEditModal({ visible: false, isNew: false, record: null })}
        onOk={handleSave}
        okText="保存草稿"
        width={560}
      >
        <div style={{ marginBottom: 16 }}>
          <div style={{ marginBottom: 8, fontWeight: 500 }}>通知标题 *</div>
          <Input
            value={formData.title}
            onChange={(e) => setFormData({ ...formData, title: e.target.value })}
            placeholder="请输入通知标题"
          />
        </div>
        <div style={{ marginBottom: 16 }}>
          <div style={{ marginBottom: 8, fontWeight: 500 }}>通知内容 *</div>
          <TextArea
            value={formData.content}
            onChange={(e) => setFormData({ ...formData, content: e.target.value })}
            placeholder="请输入通知内容（支持多行文本）"
            rows={6}
          />
        </div>
        <div style={{ marginBottom: 8 }}>
          <div style={{ marginBottom: 8, fontWeight: 500 }}>跳转链接（可选）</div>
          <Input
            value={formData.url}
            onChange={(e) => setFormData({ ...formData, url: e.target.value })}
            placeholder="如 /news/123 或 https://example.com"
          />
        </div>
      </Modal>
    </div>
  );
};

export default NotificationAdmin;
