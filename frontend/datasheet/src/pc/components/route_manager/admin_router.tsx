/**
 * 管理员页面布局。只做鉴权 + 导航，不保留侧边栏（左侧菜单已有入口），内容全宽。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

import dynamic from 'next/dynamic';
import { Skeleton } from '@apitable/components';
import { PrivateRoute } from 'pc/components/route_manager/private_route';
import { SideWrapper } from 'pc/components/route_manager/side_wrapper';

const AdminRouter = ({ children }: any) => {
  return (
    <PrivateRoute>
      <SideWrapper>
        {children}
      </SideWrapper>
    </PrivateRoute>
  );
};

export default AdminRouter;