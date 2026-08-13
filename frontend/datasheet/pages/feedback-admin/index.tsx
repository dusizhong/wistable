import dynamic from 'next/dynamic';
import React from 'react';

const DynamicComponentWithNoSSR = dynamic(
  () => import('pc/components/route_manager/admin_router'),
  { ssr: false },
);
const FeedbackAdminPageWithNoSSR = dynamic(
  () => import('pc/components/admin/feedback_admin'),
  { ssr: false },
);
const App = () => {
  return (
    <DynamicComponentWithNoSSR>
      <FeedbackAdminPageWithNoSSR />
    </DynamicComponentWithNoSSR>
  );
};
export default App;
