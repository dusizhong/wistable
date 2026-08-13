import classNames from 'classnames';
import { FC, useState } from 'react';
import * as React from 'react';
import { useDispatch } from 'react-redux';
import { TextInput, Button } from '@apitable/components';
import { t, Strings, IReduxState, StoreActions, StatusCode } from '@apitable/core';
import { PasswordInput } from 'pc/components/common/input/password_input/password_input';
import { WithTipWrapper } from 'pc/components/common/input/with_tip_wrapper/with_tip_wrapper';
import { Message } from 'pc/components/common/message/message';
import { useRequest } from 'pc/hooks/use_request';
import { useSetState } from 'pc/hooks/use_set_state';
import { useUserRequest } from 'pc/hooks/use_user_request';
import { useAppSelector } from 'pc/store/react-redux';
import styles from './style.module.less';

export interface IModifyPasswordProps {
  setActiveItem: React.Dispatch<React.SetStateAction<number>>;
}

const defaultData = {
  oldPassword: '',
  password: '',
};

export const ModifyPassword: FC<React.PropsWithChildren<IModifyPasswordProps>> = (props) => {
  const { setActiveItem } = props;
  const [data, setData] = useSetState<{
    oldPassword: string;
    password: string;
  }>(defaultData);

  const [errMsg, setErrMsg] = useSetState<{
    oldPasswordErrMsg: string;
    passwordErrMsg: string;
  }>({
    oldPasswordErrMsg: '',
    passwordErrMsg: '',
  });

  const dispatch = useDispatch();
  const user = useAppSelector((state: IReduxState) => state.user.info)!;
  const { modifyPasswordReq } = useUserRequest();
  const { run: modifyPassword, loading } = useRequest(modifyPasswordReq, { manual: true });

  const handleOldPasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.trim();
    if (errMsg.oldPasswordErrMsg) {
      setErrMsg({ oldPasswordErrMsg: '' });
    }
    setData({ oldPassword: value });
  };

  const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.trim();
    if (errMsg.passwordErrMsg) {
      setErrMsg({ passwordErrMsg: '' });
    }
    setData({ password: value });
  };

  const handleSubmit = async () => {
    if (!data.oldPassword) {
      setErrMsg({ oldPasswordErrMsg: t(Strings.placeholder_input_password) });
      return;
    }
    if (!data.password) {
      setErrMsg({ passwordErrMsg: t(Strings.placeholder_input_password) });
      return;
    }
    if (data.password.length < 8) {
      setErrMsg({ passwordErrMsg: t(Strings.password_rules) });
      return;
    }

    const result = await modifyPassword(data.password, data.oldPassword);

    if (!result) {
      return;
    }

    const { success, code, message } = result;

    if (success) {
      Message.success({ content: t(Strings.change_password_success) });
      setData(defaultData);
      dispatch(StoreActions.updateUserInfo({ needPwd: false }));
      setActiveItem(0);
      return;
    }

    // Wrong current password (code 302) → show under current password
    // New password format/length error (code 305) → show under new password
    if (code === StatusCode.NAME_AND_PWD_ERR) {
      setErrMsg({ oldPasswordErrMsg: message || t(Strings.password_err) });
    } else {
      setErrMsg({ passwordErrMsg: message });
    }
  };

  const btnDisabled = !(data.oldPassword && data.password);

  return (
    <div className={styles.modifyPasswordWrapper}>
      <div className={styles.title}>{user!.needPwd ? t(Strings.set_password) : t(Strings.change_password)}</div>
      <div className={styles.form}>
        <div className={classNames([styles.item, styles.newPassword])}>
          <div className={styles.label}>{t(Strings.current_password)}:</div>
          <div className={styles.content}>
            <WithTipWrapper tip={errMsg.oldPasswordErrMsg}>
              <PasswordInput
                value={data.oldPassword}
                onChange={handleOldPasswordChange}
                placeholder={t(Strings.placeholder_input_password)}
                autoComplete="current-password"
                error={Boolean(errMsg.oldPasswordErrMsg)}
                block
              />
            </WithTipWrapper>
          </div>
        </div>
        <div className={classNames([styles.item, styles.newPassword])}>
          <div className={styles.label}>{t(Strings.input_new_password)}:</div>
          <div className={styles.content}>
            <WithTipWrapper tip={errMsg.passwordErrMsg}>
              <PasswordInput
                value={data.password}
                onChange={handlePasswordChange}
                placeholder={t(Strings.password_rules)}
                autoComplete="new-password"
                error={Boolean(errMsg.passwordErrMsg)}
                block
              />
            </WithTipWrapper>
          </div>
        </div>
        <Button
          color="primary"
          className={styles.saveBtn}
          htmlType="submit"
          size="large"
          disabled={btnDisabled}
          loading={loading}
          onClick={handleSubmit}
          block
        >
          {t(Strings.save)}
        </Button>
      </div>
    </div>
  );
};
