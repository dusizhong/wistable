import { useMount } from 'ahooks';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { shallowEqual } from 'react-redux';
import { useContextMenu } from '@apitable/components';
import { Events, IReduxState, Player, ScreenWidth, StoreActions, Strings, t } from '@apitable/core';
import { Modal } from 'pc/components/common';
import { ScreenSize } from 'pc/components/common/component_display/enum';
import { ScrollBar } from 'pc/components/scroll_bar';
import { useDispatch, useResponsive, useSideBarVisible } from 'pc/hooks';
import { useAppSelector } from 'pc/store/react-redux';
import { DelConfirmModal, DelSpaceModal, DelSuccess, RecoverSpace } from './components';
import { Lg, Md, Sm, Xs } from './layout';
import { DELETE_SPACE_CONTEXT_MENU_ID } from './utils';

export const SpaceInfo = () => {
  const { spaceInfo, spaceFeatures, subscription, spaceId } = useAppSelector(
    (state: IReduxState) => ({
      spaceInfo: state.space.curSpaceInfo,
      spaceFeatures: state.space.spaceFeatures,
      subscription: state.billing?.subscription,
      spaceId: state.space.activeId,
    }),
    shallowEqual,
  );
  const { setSideBarVisible } = useSideBarVisible();
  const [isDelConfirmModal, setIsDelConfirmModal] = useState(false);
  const [isDelSpaceModal, setIsDelSpaceModal] = useState(false);
  const [isDelSuccessModal, setIsDelSuccessModal] = useState(false);
  const dispatch = useDispatch();
  useMount(() => {
    spaceId && dispatch(StoreActions.getSpaceInfo(spaceId));
    Player.doTrigger(Events.space_setting_overview_shown);
  });

  const { clientWidth, screenIsAtMost } = useResponsive();
  const isMobile = screenIsAtMost(ScreenSize.md);

  useEffect(() => {
    if (isMobile) {
      setSideBarVisible(false);
    }
  }, [isMobile, setSideBarVisible]);

  const Layout = useMemo(() => {
    if (clientWidth < ScreenWidth.sm) {
      return Xs;
    } else if (clientWidth < ScreenWidth.xl) {
      return Sm;
    } else if (clientWidth < ScreenWidth.xxl) {
      return Md;
    }
    return Lg;
  }, [clientWidth]);

  const { show: showContextMenu } = useContextMenu({ id: DELETE_SPACE_CONTEXT_MENU_ID });

  const handleDelSpace = useCallback(() => {
    setIsDelConfirmModal(true);
  }, []);

  if (spaceInfo && spaceInfo.delTime) {
    return <RecoverSpace />;
  }

  const layoutProps = {
    handleDelSpace,
    showContextMenu,
    subscription: subscription!,
    spaceId: spaceId!,
    spaceInfo: spaceInfo!,
    spaceFeatures: spaceFeatures!,
    isMobile,
  };

  return (
    <ScrollBar style={{ width: '100%', height: '100%' }}>
      <Layout {...layoutProps} />
      {isDelConfirmModal && (
        <DelConfirmModal setIsDelSpaceModal={setIsDelSpaceModal} setIsDelConfirmModal={setIsDelConfirmModal} isMobile={isMobile} />
      )}
      {isDelSpaceModal && <DelSpaceModal setIsDelSpaceModal={setIsDelSpaceModal} setIsDelSuccessModal={setIsDelSuccessModal} />}
      {isDelSuccessModal && <DelSuccess tip={t(Strings.tip_del_success)} />}
    </ScrollBar>
  );
};
