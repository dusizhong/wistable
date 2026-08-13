import { automationApiClient, IResponseDataAutomationVO, IResponseDataListAutomationSimpleVO } from 'pc/common/api-client';

export const getRobotDetail = async (
  automationId: string,
  shareId?: string
): Promise<IResponseDataAutomationVO | IResponseDataListAutomationSimpleVO> => {

  const res = await automationApiClient.getResourceRobots({
    resourceId: automationId ?? '',
    shareId: shareId ?? ''
  });

  const data = res.data?.[0];
  if (!Boolean(data)) {
    return res;
  }

  const automationDetail = await automationApiClient.getNodeRobot({
    resourceId: data?.resourceId ?? '',
    robotId: data?.robotId ?? '',
    shareId: shareId ?? ''
  });

  return automationDetail;
};
