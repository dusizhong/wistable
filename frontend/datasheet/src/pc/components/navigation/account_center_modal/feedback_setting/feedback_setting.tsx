import React, { useState } from 'react';
import { Input, message } from 'antd';
import { Button } from '@apitable/components';
import { Api, Strings, t } from '@apitable/core';
import { useAppSelector } from 'pc/store/react-redux';

const { TextArea } = Input;

export const FeedbackSetting: React.FC = () => {
  const userInfo = useAppSelector((state) => state.user.info);
  const [nickName, setNickName] = useState(userInfo?.nickName || '');
  const [email, setEmail] = useState(userInfo?.email || '');
  const [content, setContent] = useState('');
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async () => {
    if (!content.trim()) {
      message.warning('反馈意见不能为空');
      return;
    }
    if (!nickName.trim()) {
      message.warning('请输入昵称');
      return;
    }
    if (!email.trim()) {
      message.warning('请输入邮箱');
      return;
    }
    setSubmitting(true);
    try {
      await Api.submitFeedback({ nickName: nickName.trim(), email: email.trim(), content: content.trim() });
      message.success('感谢您的反馈！');
      setContent('');
    } catch (e: any) {
      message.error(e?.message || '提交失败，请稍后重试');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div style={{ padding: 16, maxWidth: 520 }}>
      <h3 style={{ marginBottom: 20 }}>意见反馈</h3>
      <div style={{ marginBottom: 16 }}>
        <div style={{ marginBottom: 6, fontWeight: 500 }}>昵称</div>
        <Input
          value={nickName}
          onChange={(e) => setNickName(e.target.value)}
          placeholder="请输入您的昵称"
        />
      </div>
      <div style={{ marginBottom: 16 }}>
        <div style={{ marginBottom: 6, fontWeight: 500 }}>邮箱</div>
        <Input
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="请输入您的邮箱"
        />
      </div>
      <div style={{ marginBottom: 16 }}>
        <div style={{ marginBottom: 6, fontWeight: 500 }}>反馈意见 *</div>
        <TextArea
          value={content}
          onChange={(e) => setContent(e.target.value)}
          placeholder="请详细描述您的意见或建议..."
          rows={5}
        />
      </div>
      <Button color="primary" onClick={handleSubmit} loading={submitting}>
        提交反馈
      </Button>
    </div>
  );
};
