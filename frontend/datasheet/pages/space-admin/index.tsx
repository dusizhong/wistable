/**
 * 系统管理员「空间管理」模块的 Next.js 页面路由入口。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

import dynamic from 'next/dynamic';
import React from 'react';

const DynamicComponentWithNoSSR = dynamic(
  () => import('pc/components/route_manager/admin_router'),
  { ssr: false },
);

const SpaceAdminPageWithNoSSR = dynamic(
  () => import('pc/components/admin/space_admin'),
  { ssr: false },
);

const App = () => {
  return (
    <DynamicComponentWithNoSSR>
      <SpaceAdminPageWithNoSSR />
    </DynamicComponentWithNoSSR>
  );
};

export default App;
