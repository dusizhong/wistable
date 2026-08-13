import { useState } from 'react';
import { Button } from '@apitable/components';
import { IReduxState, shallowEqual, Strings, t } from '@apitable/core';
import { CreateDataSheetModal } from 'pc/components/workspace/welcome/components/create_datasheet_modal';
import styles from 'pc/components/workspace/welcome/style.module.less';
import { useAppSelector } from 'pc/store/react-redux';

export const CreateDatasheet = () => {
  const [show, setShow] = useState(false);
  const { treeNodesMap, rootId } = useAppSelector(
    (state: IReduxState) => ({
      treeNodesMap: state.catalogTree.treeNodesMap,
      rootId: state.catalogTree.rootId,
      user: state.user.info,
    }),
    shallowEqual,
  );

  return (
    <div className={styles.welcome}>
      <div className={styles.contentWrapper}>
        {treeNodesMap[rootId].permissions.childCreatable ? (
          <>
            <div className={styles.tip}>{t(Strings.welcome_workspace_tip1)}</div>
            <Button style={{ width: 200 }} color="primary" size="large" onClick={() => setShow(true)}>
              {t(Strings.create)}
            </Button>
          </>
        ) : (
          <div className={styles.tip}>{t(Strings.welcome_workspace_tip1)}</div>
        )}
      </div>

      {show && <CreateDataSheetModal setShow={setShow} />}
    </div>
  );
};
