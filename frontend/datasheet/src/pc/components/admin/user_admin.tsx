/**
 * 系统管理员「用户管理」页面组件。
 * 提供用户列表（搜索/分页）、新增用户、编辑信息、修改密码、启用/停用、删除等功能。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

import React, { useEffect, useState, useCallback } from 'react';
import { Table, Input, Select, Modal, message, Space, Tag, Button as AntButton, Tooltip } from 'antd';
import { TextInput } from '@apitable/components';
import { SearchOutlined, CloseCircleFilled } from '@apitable/icons';
import { Api } from '@apitable/core';
import { useAppSelector } from 'pc/store/react-redux';
import { useRouter } from 'next/router';
import dayjs from 'dayjs';

import { useDebounce } from 'ahooks';

const UserAdmin: React.FC = () => {
  const router = useRouter();
  const userInfo = useAppSelector((state) => state.user.info);
  const [loading, setLoading] = useState(false);
  const [users, setUsers] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [pageNo, setPageNo] = useState(1);
  const [pageSize] = useState(20);
  const [keyword, setKeyword] = useState('');
  const [searchValue, setSearchValue] = useState('');
  const debouncedSearch = useDebounce(searchValue, { wait: 300 });

  useEffect(() => {
    setKeyword(debouncedSearch);
    setPageNo(1);
  }, [debouncedSearch]);
  const [editModal, setEditModal] = useState<{ visible: boolean; record: any }>({ visible: false, record: null });
  const [createModal, setCreateModal] = useState(false);
  const [createForm, setCreateForm] = useState({ email: '', password: '', nickName: '', mobile: '', role: 'user' });
  const [passwordModal, setPasswordModal] = useState<{ visible: boolean; userId: string; nickName: string }>({
    visible: false, userId: '', nickName: '',
  });
  const [newPassword, setNewPassword] = useState('');

  useEffect(() => {
    if (userInfo && userInfo.role !== 'admin') {
      router.replace('/workbench');
    }
  }, [userInfo, router]);

  const fetchUsers = useCallback(async () => {
    if (!userInfo || userInfo.role !== 'admin') return;
    setLoading(true);
    try {
      const res = await Api.getAdminUserList({ pageNo, pageSize, keyword: keyword || undefined });
      const { success, data } = res.data;
      if (success && data) {
        setUsers(data.records || []);
        setTotal(data.total || 0);
      }
    } catch (e: any) {
      message.error(e?.message || '加载用户失败');
    } finally {
      setLoading(false);
    }
  }, [pageNo, pageSize, keyword, userInfo]);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const handleCreate = async () => {
    if (!createForm.email || !createForm.password) {
      message.warning('邮箱和密码不能为空');
      return;
    }
    try {
      await Api.adminCreateUser(createForm);
      message.success('用户创建成功');
      setCreateModal(false);
      setCreateForm({ email: '', password: '', nickName: '', mobile: '', role: 'user' });
      fetchUsers();
    } catch (e: any) {
      message.error(e?.message || '创建失败');
    }
  };

  const handleToggle = async (record: any) => {
    try {
      await Api.adminToggleUser(record.userId);
      message.success(record.isPaused ? '用户已启用' : '用户已停用');
      fetchUsers();
    } catch (e: any) {
      message.error(e?.message || '操作失败');
    }
  };

  const handleDelete = async (record: any) => {
    Modal.confirm({
      title: '删除用户',
      content: `确定要删除用户「${record.nickName}」吗？`,
      okText: '确定',
      cancelText: '取消',
      onOk: async () => {
        try {
          await Api.adminDeleteUser(record.userId);
          message.success('已删除');
          fetchUsers();
        } catch (e: any) {
          message.error(e?.message || '删除失败');
        }
      },
    });
  };

  const handleEdit = (record: any) => {
    setEditModal({
      visible: true,
      record: { ...record },
    });
  };

  const saveEdit = async () => {
    try {
      await Api.adminUpdateUser(editModal.record.userId, {
        role: editModal.record.role,
        nickName: editModal.record.nickName,
        email: editModal.record.email,
        mobile: editModal.record.mobile,
      });
      message.success('修改成功');
      setEditModal({ visible: false, record: null });
      fetchUsers();
    } catch (e: any) {
      message.error(e?.message || '修改失败');
    }
  };

  const handleSetPassword = (record: any) => {
    setPasswordModal({ visible: true, userId: record.userId, nickName: record.nickName });
    setNewPassword('');
  };

  const savePassword = async () => {
    if (!newPassword) {
      message.warning('请输入新密码');
      return;
    }
    try {
      await Api.adminSetUserPassword(passwordModal.userId, { password: newPassword });
      message.success('密码已修改');
      setPasswordModal({ visible: false, userId: '', nickName: '' });
      setNewPassword('');
    } catch (e: any) {
      message.error(e?.message || '修改密码失败');
    }
  };

  const columns = [
    {
      title: '序号',
      key: 'index',
      width: 60,
      align: 'center' as const,
      render: (_: any, __: any, index: number) => (pageNo - 1) * pageSize + index + 1,
    },
    { title: '昵称', dataIndex: 'nickName', key: 'nickName', width: 120, ellipsis: true },
    { title: '邮箱', dataIndex: 'email', key: 'email', width: 200, ellipsis: true },
    { title: '手机号', dataIndex: 'mobile', key: 'mobile', width: 130, ellipsis: true },
    {
      title: '角色',
      dataIndex: 'role',
      key: 'role',
      width: 90,
      render: (role: string) => (
        <Tag color={role === 'admin' ? 'red' : 'blue'}>{role === 'admin' ? '管理员' : '普通用户'}</Tag>
      ),
    },
    {
      title: '状态',
      key: 'status',
      width: 90,
      render: (_: any, record: any) => (
        <span>
          <span style={{
            display: 'inline-block', width: 6, height: 6, borderRadius: '50%',
            background: record.isPaused ? '#faad14' : '#52c41a',
            marginRight: 6, verticalAlign: 'middle',
          }} />
          {record.isPaused ? '已停用' : '正常'}
        </span>
      ),
    },
    { title: '空间数', dataIndex: 'spaceCount', key: 'spaceCount', width: 80, align: 'center' },
    {
      title: '创建时间',
      dataIndex: 'signUpTime',
      key: 'signUpTime',
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
      width: 230,
      render: (_: any, record: any) => (
        <Space wrap>
          <a onClick={() => handleEdit(record)}>编辑</a>
          <a onClick={() => handleSetPassword(record)}>改密</a>
          <a onClick={() => handleToggle(record)}>{record.isPaused ? '启用' : '停用'}</a>
          <a onClick={() => handleDelete(record)} style={{ color: 'red' }}>删除</a>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: '24px 16px', height: '100%', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <h2 style={{ margin: '0 0 16px' }}>用户管理</h2>
      <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap', gap: 8 }}>
        <AntButton type="primary" onClick={() => setCreateModal(true)} style={{ flexShrink: 0 }}>
          新增用户
        </AntButton>
        <div style={{ width: 320 }}>
          <TextInput
            size="small"
            placeholder="搜索昵称、邮箱或手机号"
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
          rowKey="userId"
          columns={columns as any}
          dataSource={users}
          loading={loading}
          scroll={{ x: 'max-content' }}
          pagination={{
            current: pageNo,
            pageSize,
            total,
            onChange: (p) => setPageNo(p),
            showSizeChanger: false,
            showTotal: (t) => `共 ${t} 个用户`,
          }}
        />
      </div>

      {/* 新建用户弹窗 */}
      <Modal
        title="新增用户"
        open={createModal}
        onOk={handleCreate}
        onCancel={() => { setCreateModal(false); setCreateForm({ email: '', password: '', nickName: '', mobile: '', role: 'user' }); }}
        okText="创建"
        cancelText="取消"
      >
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          <div>
            <span style={{ color: 'red' }}>* </span>邮箱：
            <Input placeholder="请输入邮箱" allowClear value={createForm.email} onChange={(e) => setCreateForm({ ...createForm, email: e.target.value })} style={{ width: '100%' }} />
          </div>
          <div>
            <span style={{ color: 'red' }}>* </span>密码：
            <Input.Password placeholder="请输入密码" value={createForm.password} onChange={(e) => setCreateForm({ ...createForm, password: e.target.value })} style={{ width: '100%' }} />
          </div>
          <div>
            昵称：
            <Input placeholder="选填" allowClear value={createForm.nickName} onChange={(e) => setCreateForm({ ...createForm, nickName: e.target.value })} style={{ width: '100%' }} />
          </div>
          <div>
            手机号：
            <Input placeholder="选填" allowClear value={createForm.mobile} onChange={(e) => setCreateForm({ ...createForm, mobile: e.target.value })} style={{ width: '100%' }} />
          </div>
          <div>
            角色：
            <Select value={createForm.role} onChange={(val) => setCreateForm({ ...createForm, role: val })} style={{ width: '100%' }}>
              <Select.Option value="user">普通用户</Select.Option>
              <Select.Option value="admin">管理员</Select.Option>
            </Select>
          </div>
        </div>
      </Modal>

      {/* 编辑用户弹窗 */}
      <Modal
        title="编辑用户"
        open={editModal.visible}
        onOk={saveEdit}
        onCancel={() => setEditModal({ visible: false, record: null })}
        okText="保存"
        cancelText="取消"
      >
        {editModal.record && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            <div>
              昵称：
              <Input placeholder="请输入昵称" allowClear value={editModal.record.nickName} onChange={(e) => setEditModal({ ...editModal, record: { ...editModal.record, nickName: e.target.value } })} style={{ width: '100%' }} />
            </div>
            <div>
              邮箱：
              <Input placeholder="请输入邮箱" allowClear value={editModal.record.email} onChange={(e) => setEditModal({ ...editModal, record: { ...editModal.record, email: e.target.value } })} style={{ width: '100%' }} />
            </div>
            <div>
              手机号：
              <Input placeholder="请输入手机号" allowClear value={editModal.record.mobile} onChange={(e) => setEditModal({ ...editModal, record: { ...editModal.record, mobile: e.target.value } })} style={{ width: '100%' }} />
            </div>
            <div>
              角色：
              <Select value={editModal.record.role} onChange={(val) => setEditModal({ ...editModal, record: { ...editModal.record, role: val } })} style={{ width: '100%' }}>
                <Select.Option value="user">普通用户</Select.Option>
                <Select.Option value="admin">管理员</Select.Option>
              </Select>
            </div>
          </div>
        )}
      </Modal>

      {/* 修改密码弹窗 */}
      <Modal
        title={`修改密码 - ${passwordModal.nickName}`}
        open={passwordModal.visible}
        onOk={savePassword}
        onCancel={() => { setPasswordModal({ visible: false, userId: '', nickName: '' }); setNewPassword(''); }}
        okText="保存"
        cancelText="取消"
      >
        <div>
          新密码：
          <Input.Password placeholder="请输入新密码" value={newPassword} onChange={(e) => setNewPassword(e.target.value)} style={{ width: '100%' }} />
        </div>
      </Modal>
    </div>
  );
};

export default UserAdmin;
