import axios from 'axios';

export interface IAutomationTriggerVO {
  triggerId?: string;
  triggerTypeId?: string;
  prevTriggerId?: string;
  input?: any;
  relatedResourceId?: string;
}

export interface IAutomationActionVO {
  actionId?: string;
  actionTypeId?: string;
  prevActionId?: string;
  input?: any;
}

export interface IAutomationVO {
  robotId?: string;
  name?: string;
  description?: string;
  resourceId?: string;
  isActive?: number;
  updatedBy?: { uuid?: string; nickName?: string; avatar?: string };
  updatedAt?: number;
  props?: { failureNotifyEnable?: boolean };
  recentlyRunCount?: number;
  triggers?: IAutomationTriggerVO[];
  actions?: IAutomationActionVO[];
  relatedResources?: { nodeId?: string; nodeName?: string; icon?: string }[];
  isOverLimit?: boolean;
}

export interface IAutomationSimpleVO {
  robotId?: string;
  name?: string;
  description?: string;
  resourceId?: string;
  isActive?: number;
  triggers?: IAutomationTriggerVO[];
  actions?: IAutomationActionVO[];
  isOverLimit?: boolean;
}

export interface IResponseDataAutomationVO {
  success?: boolean;
  code?: number;
  message?: string;
  data?: IAutomationVO;
}

export interface IResponseDataListAutomationSimpleVO {
  success?: boolean;
  code?: number;
  message?: string;
  data?: IAutomationSimpleVO[];
}

export const isAutomationDetailResponse = (
  resp: IResponseDataAutomationVO | IResponseDataListAutomationSimpleVO | undefined
): resp is IResponseDataAutomationVO => resp != null && resp.data != null && !Array.isArray(resp.data);

export const automationApiClient = {
  getResourceRobots: async (param: { resourceId: string; shareId?: string }): Promise<IResponseDataListAutomationSimpleVO> => {
    const res = await axios.get('/api/v1/automation/robots', {
      params: { resourceId: param.resourceId, shareId: param.shareId ?? '' },
    });
    return res.data;
  },
  getNodeRobot: async (param: { resourceId: string; robotId: string; shareId?: string }): Promise<IResponseDataAutomationVO> => {
    const res = await axios.get(
      `/api/v1/automation/${encodeURIComponent(param.resourceId)}/robots/${encodeURIComponent(param.robotId)}`,
      { params: { shareId: param.shareId ?? '' } }
    );
    return res.data;
  },
};
