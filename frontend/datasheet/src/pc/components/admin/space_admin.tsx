/**
 * 系统管理员「空间管理」页面组件。
 * 提供空间列表（搜索/分页）、新建空间、删除空间、自定义用量限额配置等功能。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

import React, { useEffect, useState, useCallback } from 'react';
import { Table, Input, Modal, message, Space, Tag, Button as AntButton, InputNumber, Tooltip } from 'antd';
import { TextInput } from '@apitable/components';
import { SearchOutlined, CloseCircleFilled } from '@apitable/icons';
import { Api } from '@apitable/core';
import { updateSubscription } from 'modules/billing';
import { useAppSelector } from 'pc/store/react-redux';
import { useRouter } from 'next/router';
import { useDebounce } from 'ahooks';
import dayjs from 'dayjs';

const SpaceAdmin: React.FC = () => {
  const router = useRouter();
  const userInfo = useAppSelector((state) => state.user.info);
  const [loading, setLoading] = useState(false);
  const [spaces, setSpaces] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [pageNo, setPageNo] = useState(1);
  const [pageSize] = useState(20);
  const [keyword, setKeyword] = useState('');
  const [searchValue, setSearchValue] = useState('');
  const debouncedSearch = useDebounce(searchValue, { wait: 300 });
  const [createModal, setCreateModal] = useState(false);
  const [createForm, setCreateForm] = useState({ name: '', ownerEmail: '' });
  const [capacityModal, setCapacityModal] = useState<{ visible: boolean; spaceId: string; spaceName: string; config: any }>({
    visible: false, spaceId: '', spaceName: '', config: {},
  });

  useEffect(() => {
    if (userInfo && userInfo.role !== 'admin') {
      router.replace('/workbench');
    }
  }, [userInfo, router]);

  useEffect(() => {
    setKeyword(debouncedSearch);
    setPageNo(1);
  }, [debouncedSearch]);

  const fetchSpaces = useCallback(async () => {
    if (!userInfo || userInfo.role !== 'admin') return;
    setLoading(true);
    try {
      const res = await Api.getAdminSpaceList({ pageNo, pageSize, keyword: keyword || undefined });
      const { success, data } = res.data;
      if (success && data) {
        setSpaces(data.records || []);
        setTotal(data.total || 0);
      }
    } catch (e: any) {
      message.error(e?.message || '加载空间失败');
    } finally {
      setLoading(false);
    }
  }, [pageNo, pageSize, keyword, userInfo]);

  useEffect(() => {
    fetchSpaces();
  }, [fetchSpaces]);

  const handleCreate = async () => {
    if (!createForm.name.trim()) {
      message.warning('空间名称不能为空');
      return;
    }
    try {
      await Api.adminCreateSpace({ name: createForm.name, ownerUserId: undefined, ownerEmail: createForm.ownerEmail || undefined });
      message.success('空间创建成功');
      setCreateModal(false);
      setCreateForm({ name: '', ownerEmail: '' });
      fetchSpaces();
    } catch (e: any) {
      message.error(e?.message || '创建失败');
    }
  };

  const handleDelete = async (record: any) => {
    Modal.confirm({
      title: '删除空间',
      content: `确定要删除「${record.name}」吗？删除后将进入 7 天待删除状态，期间可恢复。`,
      okText: '确定',
      cancelText: '取消',
      onOk: async () => {
        try {
          await Api.adminDeleteSpace(record.spaceId);
          message.success('已进入待删除状态');
          fetchSpaces();
        } catch (e: any) {
          message.error(e?.message || '删除失败');
        }
      },
    });
  };

  const handleRecover = async (record: any) => {
    Modal.confirm({
      title: '恢复空间',
      content: `确定要恢复「${record.name}」吗？恢复后成员可正常访问。`,
      okText: '确定',
      cancelText: '取消',
      onOk: async () => {
        try {
          await Api.recoverSpace(record.spaceId);
          message.success('已恢复');
          fetchSpaces();
        } catch (e: any) {
          message.error(e?.message || '恢复失败');
        }
      },
    });
  };

  const handleCapacity = async (record: any) => {
    try {
      const res = await Api.getAdminSpaceCapacity(record.spaceId);
      const { success, data } = res.data;
      if (success) {
        setCapacityModal({ visible: true, spaceId: record.spaceId, spaceName: record.name, config: data || {} });
      }
    } catch (e: any) {
      message.error(e?.message || '获取用量配置失败');
    }
  };

  const saveCapacity = async () => {
    try {
      const payload: Record<string, number | null> = {};
      for (const [key, value] of Object.entries(capacityModal.config)) {
        if (value !== '' && value !== undefined && value !== null) {
          payload[key] = Number(value);
        } else {
          payload[key] = null;
        }
      }
      await Api.updateAdminSpaceCapacity(capacityModal.spaceId, payload);
      message.success('用量配置已保存');
      updateSubscription(capacityModal.spaceId);
      setCapacityModal({ visible: false, spaceId: '', spaceName: '', config: {} });
    } catch (e: any) {
      message.error(e?.message || '保存失败');
    }
  };

  const fmtDefault = (v: number) => (v === -1 ? '不限' : String(v));

  const capacityFieldGroups = [
    {
      title: '基础限额',
      fields: [
        { key: 'maxSeats', label: '最大成员数', def: '2' },
        { key: 'maxCapacitySizeInBytes', label: '最大附件容量(bytes)', def: '1073741824 (1 GB)' },
        { key: 'maxSheetNums', label: '最大文件数', def: '5' },
        { key: 'maxRowsPerSheet', label: '每表最大行数', def: '100' },
        { key: 'maxRowsInSpace', label: '空间总行数上限', def: '250' },
        { key: 'maxAdminNums', label: '最大管理员数', def: '不限' },
      ],
    },
    {
      title: '视图与功能',
      fields: [
        { key: 'maxGalleryViewsInSpace', label: '最大画廊视图', def: '不限' },
        { key: 'maxKanbanViewsInSpace', label: '最大看板视图', def: '不限' },
        { key: 'maxGanttViewsInSpace', label: '最大甘特视图', def: '不限' },
        { key: 'maxCalendarViewsInSpace', label: '最大日历视图', def: '不限' },
        { key: 'maxFormViewsInSpace', label: '最大表单数', def: '不限' },
        { key: 'maxMirrorNums', label: '最大镜像数', def: '不限' },
        { key: 'maxWidgetNums', label: '最大小组件数', def: '不限' },
      ],
    },
    {
      title: '权限与安全',
      fields: [
        { key: 'fieldPermissionNums', label: '最大列权限数', def: '不限' },
        { key: 'nodePermissionNums', label: '最大节点权限数', def: '不限' },
      ],
    },
    {
      title: '自动化与 AI',
      fields: [
        { key: 'apiCallNumsPerMonth', label: '月API调用上限', def: '不限' },
        { key: 'maxAiAgentNums', label: '最大AI代理数', def: '0' },
        { key: 'automationRunNumsPerMonth', label: '月自动化运行上限', def: '不限' },
      ],
    },
    {
      title: '数据保留',
      fields: [
        { key: 'maxRemainTrashDays', label: '回收站保留天数', def: '不限' },
        { key: 'maxRemainTimeMachineDays', label: '时光机保留天数', def: '不限' },
        { key: 'maxRemainRecordActivityDays', label: '记录活动保留天数', def: '不限' },
      ],
    },
  ];

  const columns = [
    {
      title: '序号',
      key: 'index',
      width: 60,
      align: 'center' as const,
      render: (_: any, __: any, index: number) => (pageNo - 1) * pageSize + index + 1,
    },
    { title: '空间名称', dataIndex: 'name', key: 'name', width: 160, ellipsis: true },
    { title: '空间ID', dataIndex: 'spaceId', key: 'spaceId', width: 140, ellipsis: true },
    { title: '所有者', dataIndex: 'ownerName', key: 'ownerName', width: 100, ellipsis: true },
    { title: '邮箱', dataIndex: 'ownerEmail', key: 'ownerEmail', width: 160, ellipsis: true },
    { title: '成员数', dataIndex: 'memberCount', key: 'memberCount', width: 80, align: 'center' as const },
    {
      title: '状态',
      key: 'status',
      width: 140,
      render: (_: any, record: any) => {
        if (record.preDeletionTime) {
          const delDate = new Date(record.preDeletionTime);
          const restoreDeadline = new Date(delDate.getTime() + 7 * 24 * 3600 * 1000);
          const remainDays = Math.ceil((restoreDeadline.getTime() - Date.now()) / (24 * 3600 * 1000));
          return (
            <span>
              <span style={{
                display: 'inline-block', width: 6, height: 6, borderRadius: '50%',
                background: '#faad14', marginRight: 6, verticalAlign: 'middle',
              }} />
              待删除（{remainDays > 0 ? `${remainDays}天` : '即将'}）
            </span>
          );
        }
        return (
          <span>
            <span style={{
              display: 'inline-block', width: 6, height: 6, borderRadius: '50%',
              background: '#52c41a', marginRight: 6, verticalAlign: 'middle',
            }} />
            正常
          </span>
        );
      },
    },
    {
      title: '创建时间',
      dataIndex: 'createdAt',
      key: 'createdAt',
      width: 120,
      render: (val: string) => val ? (
        <Tooltip title={val}>{dayjs(val).format('YYYY-MM-DD')}</Tooltip>
      ) : '-',
    },
    {
      title: '更新时间',
      dataIndex: 'updatedAt',
      key: 'updatedAt',
      width: 120,
      render: (val: string) => val ? (
        <Tooltip title={val}>{dayjs(val).format('YYYY-MM-DD')}</Tooltip>
      ) : '-',
    },
    {
      title: '操作',
      key: 'action',
      width: 170,
      render: (_: any, record: any) => (
        <Space>
          <a onClick={() => handleCapacity(record)}>用量配置</a>
          {record.preDeletionTime ? (
            <a onClick={() => handleRecover(record)} style={{ color: '#52c41a' }}>恢复</a>
          ) : (
            <a onClick={() => handleDelete(record)} style={{ color: 'red' }}>删除</a>
          )}
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: '24px 16px', height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <h2 style={{ margin: '0 0 16px' }}>空间管理</h2>
      <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap', gap: 8 }}>
        <AntButton type="primary" onClick={() => setCreateModal(true)} style={{ flexShrink: 0 }}>
          新建空间
        </AntButton>
        <div style={{ width: 320 }}>
          <TextInput
            size="small"
            placeholder="搜索空间名称、ID或所有者"
            value={searchValue}
            onChange={(e) => setSearchValue(e.target.value)}
            prefix={<SearchOutlined />}
            suffix={searchValue ? <CloseCircleFilled onClick={() => { setSearchValue(''); setKeyword(''); }} /> : null}
            block
          />
        </div>
      </div>
      <div style={{ flex: 1, overflow: 'auto' }}>
        <Table
          rowKey="spaceId"
          columns={columns}
          dataSource={spaces}
          loading={loading}
          scroll={{ x: 'max-content' }}
          pagination={{
            current: pageNo,
            pageSize,
            total,
            onChange: (p) => setPageNo(p),
            showSizeChanger: false,
            showTotal: (t) => `共 ${t} 个空间`,
          }}
        />
      </div>

      {/* 新建空间弹窗 */}
      <Modal
        title="新建空间"
        open={createModal}
        onOk={handleCreate}
        onCancel={() => { setCreateModal(false); setCreateForm({ name: '', ownerEmail: '' }); }}
        okText="创建"
        cancelText="取消"
      >
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          <div>
            <span style={{ color: 'red' }}>* </span>空间名称：
            <Input
              placeholder="请输入空间名称"
              allowClear
              value={createForm.name}
              onChange={(e) => setCreateForm({ ...createForm, name: e.target.value })}
              style={{ width: '100%' }}
            />
          </div>
          <div>
            所有者邮箱：
            <Input
              placeholder="留空则为当前管理员"
              allowClear
              value={createForm.ownerEmail}
              onChange={(e) => setCreateForm({ ...createForm, ownerEmail: e.target.value })}
              style={{ width: '100%' }}
            />
          </div>
        </div>
      </Modal>

      {/* 用量配置弹窗 */}
      <Modal
        title={`用量限额配置 - ${capacityModal.spaceName}`}
        open={capacityModal.visible}
        onOk={saveCapacity}
        onCancel={() => setCapacityModal({ visible: false, spaceId: '', spaceName: '', config: {} })}
        okText="保存"
        cancelText="取消"
        width={640}
      >
        <div style={{ maxHeight: 500, overflow: 'auto' }}>
          {capacityFieldGroups.map((group) => (
            <div key={group.title} style={{ marginBottom: 16 }}>
              <div style={{ fontSize: 13, fontWeight: 600, color: '#666', marginBottom: 8, paddingBottom: 4, borderBottom: '1px solid #f0f0f0' }}>
                {group.title}
              </div>
              {group.fields.map((f: any) => (
                <div key={f.key} style={{ marginBottom: 10, display: 'flex', alignItems: 'center' }}>
                  <span style={{ width: 160, fontSize: 13 }}>{f.label}：</span>
                  <InputNumber
                    style={{ flex: 1 }}
                    value={capacityModal.config[f.key]}
                    placeholder={f.def}
                    onChange={(val) =>
                      setCapacityModal({
                        ...capacityModal,
                        config: { ...capacityModal.config, [f.key]: val },
                      })
                    }
                  />
                </div>
              ))}
            </div>
          ))}
        </div>
      </Modal>
    </div>
  );
};

export default SpaceAdmin;
