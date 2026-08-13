/**
 * 系统管理员「通知管理」模块的 Next.js 页面路由入口。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

import dynamic from 'next/dynamic';
import React from 'react';

const DynamicComponentWithNoSSR = dynamic(
  () => import('pc/components/route_manager/admin_router'),
  { ssr: false },
);

const NotificationAdminPageWithNoSSR = dynamic(
  () => import('pc/components/admin/notification_admin'),
  { ssr: false },
);

const App = () => {
  return (
    <DynamicComponentWithNoSSR>
      <NotificationAdminPageWithNoSSR />
    </DynamicComponentWithNoSSR>
  );
};

export default App;
