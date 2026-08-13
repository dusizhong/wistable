/**
 * APITable <https://github.com/apitable/apitable>
 * Copyright (C) 2022 APITable Ltd. <https://apitable.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import { useMount } from 'ahooks';
import produce from 'immer';
import { useAtom, useAtomValue, useSetAtom } from 'jotai';
import { identity, isEqual, isEqualWith, isNil, pickBy } from 'lodash';
import * as React from 'react';
import { memo, MutableRefObject, useCallback, useContext, useEffect, useMemo, useRef } from 'react';
import { shallowEqual } from 'react-redux';
import styled from 'styled-components';
import useSWR from 'swr';
import { Box, IDropdownControl, SearchSelect, Typography } from '@apitable/components';
import {
  ButtonActionType,
  CollaCommandName,
  Events,
  FieldType,
  IButtonField,
  IReduxState,
  IServerFormPack,
  Player,
  ResourceType,
  Selectors,
  Strings,
  t,
} from '@apitable/core';
import { fetchFormPack } from '@apitable/core/dist/modules/database/api/form_api';
import { CONST_MAX_TRIGGER_COUNT } from 'pc/components/automation/config';
import { getDataParameter, getDataSlot } from 'pc/components/automation/controller/hooks/get_data_parameter';
import { getDatasheetId } from 'pc/components/automation/controller/hooks/get_datasheet_id';
import { getFieldId } from 'pc/components/automation/controller/hooks/get_field_id';
import { getFormId } from 'pc/components/automation/controller/hooks/get_form_id';
import { Message, Modal } from 'pc/components/common';
import { OrEmpty } from 'pc/components/common/or_empty';
import { OrTooltip } from 'pc/components/common/or_tooltip';
import { Trigger } from 'pc/components/robot/robot_context';
import { TimeScheduleManager } from 'pc/components/robot/robot_detail/trigger/time_schedule_manager';
import { useCssColors } from 'pc/components/robot/robot_detail/trigger/use_css_colors';
import { getTriggerList } from 'pc/components/robot/robot_detail/utils';
import { ShareContext } from 'pc/components/share';
import { useResponsive, useSideBarVisible } from 'pc/hooks';
import { resourceService } from 'pc/resource_service';
import { useAppSelector } from 'pc/store/react-redux';
import {
  automationCurrentTriggerId,
  automationLocalMap,
  automationPanelAtom,
  automationSourceAtom,
  automationStateAtom,
  automationTriggerDatasheetAtom,
  IAutomationPanel,
  loadableFormItemAtom,
  loadableFormList,
  PanelName,
  useAutomationController,
} from '../../../automation/controller';
import { getRelativedId } from '../../../automation/controller/hooks/use_robot_fields';
import { useAutomationResourcePermission } from '../../../automation/controller/use_automation_permission';
import { ScreenSize } from '../../../common/component_display';
import { IFormNodeItem } from '../../../tool_bar/foreign_form/form_list_panel';
import { changeTriggerTypeId, updateTriggerInput } from '../../api';
import { getNodeTypeOptions } from '../../helper';
import { AutomationScenario, IRobotTrigger, ITriggerType } from '../../interface';
import { getAutomationServiceLogo } from '../../utils';
import { DropdownTrigger } from '../action/robot_action';
import { INodeFormControlProps, NodeFormInfo } from '../node_form';
import { RobotTriggerCreateForm } from './robot_trigger_create';
import {
  FormSubmittedForm,
  RecordMatchesConditionsForm,
  RecordCreatedForm,
  ButtonClickedForm,
  ScheduledTimeForm,
} from './forms';
import itemStyle from './select_styles.module.less';

interface IRobotTriggerProps {
  robotId: string;
  triggerTypes: ITriggerType[];
  editType?: EditType;
}

interface IRobotTriggerBase {
  index: number;
  trigger: IRobotTrigger;
  triggerTypes: ITriggerType[];
  editType?: EditType;
}

export enum EditType {
  entry = 'entry',
  detail = 'detail',
}

export const customizer = (objValue, othValue) => {
  if (isNil(objValue) && isNil(othValue)) {
    return true;
  }
  if(objValue === '******' || othValue === '******') {
    return true;
  }
  const l = pickBy(objValue, identity);
  const r = pickBy(othValue, identity);
  if (isEqual(l, r)) {
    return true;
  }
  return undefined;
};

const useAutomationLocalStateMap = () => {
  const [localStateMap, setLocalStateMap] = useAtom(automationLocalMap);

  const clear = useCallback(
    (id: string) => {
      setLocalStateMap(
        produce(localStateMap, (draft) => {
          draft.delete(id);
        }),
      );
    },
    [localStateMap, setLocalStateMap],
  );

  return useMemo(
    () => ({
      clear,
    }),
    [clear],
  );
};
export const RobotTriggerBase = memo((props: IRobotTriggerBase) => {
  const { trigger, editType, triggerTypes, index } = props;
  const triggerTypeId = trigger.triggerTypeId;
  const triggerType = triggerTypes.find((t) => t.triggerTypeId === trigger.triggerTypeId);
  const [localStateMap, setLocalStateMap] = useAtom(automationLocalMap);
  const { clear } = useAutomationLocalStateMap();

  const {
    api: { refreshItem },
  } = useAutomationController();

  const buttonFieldTrigger = triggerTypes.find((item) => item.endpoint === 'button_field' || item.endpoint === 'button_clicked');
  const formData = localStateMap.get(trigger.triggerId!) ?? trigger.input;

  if (!formData) {
    setLocalStateMap(
      produce(localStateMap, (draft) => {
        draft.set(trigger.triggerId!, trigger.input);
      }),
    );
  }

  const mapFormData = localStateMap.get(trigger.triggerId!);

  const modified = useMemo(() => {
    return mapFormData != null && !isEqualWith(trigger.input, mapFormData, customizer);
  }, [mapFormData, trigger.input]);

  const { data: formList } = useAtomValue(loadableFormList);

  const triggerDatasheetValue = useAtomValue(automationTriggerDatasheetAtom);
  const setTriggerDatasheetValue = useSetAtom(automationTriggerDatasheetAtom);
  let datasheetId = triggerDatasheetValue.id;

  useEffect(() => {
    if (datasheetId && resourceService.instance?.initialized && datasheetId.startsWith('dst')) {
      resourceService.instance?.switchResource({
        to: datasheetId as string,
        resourceType: ResourceType.Datasheet,
      });
    }
  }, [datasheetId]);

  const automationState = useAtomValue(automationStateAtom);
  const activeDstId = useAppSelector(Selectors.getActiveDatasheetId);

  if (automationState?.scenario === AutomationScenario.datasheet) {
    datasheetId = activeDstId;
  }

  const datasheet = useAppSelector((a) => Selectors.getDatasheet(a, datasheetId), shallowEqual);
  const datasheetName = datasheet?.name;

  const treeMaps = useAppSelector((state: IReduxState) => state.catalogTree.treeNodesMap);
  const datasheetMaps = useAppSelector((state: IReduxState) => state.datasheetMap);

  const ref = useRef<IDropdownControl>();
  const {
    api: { refresh },
  } = useAutomationController();

  const dstId = getDatasheetId({ input: formData } as any);
  const snapshot = useAppSelector((state) => {
    return Selectors.getSnapshot(state, dstId);
  });

  const fieldMap = snapshot?.meta?.fieldMap;

  const handleDelete = useCallback(() => {
    if (buttonFieldTrigger?.triggerTypeId === trigger?.triggerTypeId) {
      const fieldId = getFieldId(trigger);
      if (fieldMap) {
        const field = fieldMap[fieldId];
        if (!field) {
          return;
        }
        if (field.type === FieldType.Button) {
          const buttonField = field as IButtonField;
          const newButtonField = produce(buttonField, (draft) => {
            if (draft.property.action.type === ButtonActionType.TriggerAutomation) {
              draft.property.action.type = undefined;
            }
          });
          const result = resourceService.instance!.commandManager.execute({
            cmd: CollaCommandName.SetFieldAttr,
            fieldId: fieldId,
            data: newButtonField,
            datasheetId,
          });
        }
      }
    }
  }, [buttonFieldTrigger?.triggerTypeId, datasheetId, fieldMap, trigger]);

  const handleTriggerTypeChange = useCallback(
    (triggerTypeId: string) => {
      if (triggerTypeId === trigger?.triggerTypeId) {
        return;
      }
      Modal.confirm({
        title: t(Strings.robot_change_trigger_tip_title),
        content: t(Strings.robot_change_trigger_tip_content),
        cancelText: t(Strings.cancel),
        okText: t(Strings.confirm),
        onOk: () => {
          if (!automationState?.resourceId) {
            console.error('resourceId is empty');
            return;
          }
          if (!automationState?.robot?.robotId) {
            console.error('robotId is empty');
            return;
          }

          if (buttonFieldTrigger?.triggerTypeId === trigger?.triggerTypeId) {
            const fieldId = getFieldId(trigger);
            if (fieldMap) {
              const field = fieldMap[fieldId];
              if (field != null) {
                if (field.type === FieldType.Button) {
                  const buttonField = field as IButtonField;
                  const newButtonField = produce(buttonField, (draft) => {
                    if (draft.property.action.type === ButtonActionType.TriggerAutomation) {
                      draft.property.action.type = undefined;
                    }
                  });
                  const result = resourceService.instance!.commandManager.execute({
                    cmd: CollaCommandName.SetFieldAttr,
                    fieldId: fieldId,
                    data: newButtonField,
                    datasheetId,
                  });
                }
              }
            }
          }
          changeTriggerTypeId(automationState?.resourceId, trigger?.triggerId!, triggerTypeId, automationState?.robot?.robotId).then(async () => {
            clear(trigger.triggerId!);
            await refresh({
              resourceId: automationState?.resourceId!,
              robotId: automationState?.currentRobotId!,
            });
          });
        },
        onCancel: () => {
          ref.current?.resetIndex?.();
          return;
        },
        type: 'warning',
      });
    },
    [
      trigger,
      automationState?.resourceId,
      automationState?.robot?.robotId,
      automationState?.currentRobotId,
      buttonFieldTrigger?.triggerTypeId,
      fieldMap,
      datasheetId,
      clear,
      refresh,
    ],
  );

  const userTimezone = useAppSelector(Selectors.getUserTimeZone)!;

  const triggerTypeOptionsWithoutButtonIsClicked = useMemo(() => {
    if (automationState?.scenario === AutomationScenario.datasheet) {
      return getNodeTypeOptions(triggerTypes.filter((r) => r.endpoint !== 'button_field' && r.endpoint !== 'button_clicked'));
    }
    return getNodeTypeOptions(triggerTypes);
  }, [automationState?.scenario, triggerTypes]);

  const getDstIdItem = useMemo(() => {
    return getDatasheetId({ input: formData });
  }, [formData]);

  const getFormIdItem = useMemo(() => {
    return getFormId({ input: formData });
  }, [formData]);

  useEffect(() => {
    setTriggerDatasheetValue((draft) => ({
      ...draft,
      formId: getFormIdItem,
    }));
  }, [getFormIdItem, setTriggerDatasheetValue]);

  useEffect(() => {
    setTriggerDatasheetValue((draft) => ({
      ...draft,
      id: getDstIdItem,
    }));
  }, [getDstIdItem, setTriggerDatasheetValue]);

  // Trigger form component map — routes endpoint to fixed form component
  const triggerFormMap: Record<string, React.FC<any>> = useMemo(() => ({
    form_submitted: FormSubmittedForm,
    record_matches_conditions: RecordMatchesConditionsForm,
    record_created: RecordCreatedForm,
    button_clicked: ButtonClickedForm,
    button_field: ButtonClickedForm,
    scheduled_time_arrive: ScheduledTimeForm,
  }), []);

  const handleUpdateFormChange = useCallback(
    (formData: any) => {
      if (!shallowEqual(formData, trigger.input)) {
        if (!automationState?.resourceId) {
          console.error('resourceId is empty');
          return;
        }
        if (!automationState?.robot?.robotId) {
          console.error('robotId is empty');
          return;
        }

        const operands = formData?.value?.operands ?? [];

        const getDstIdItem = () => {
          if (operands.length === 0) {
            return undefined;
          }
          const f = operands.findIndex((item: string) => item === 'datasheetId');
          return operands[f + 1].value;
        };

        const getFormIdItem = () => {
          if (operands.length === 0) {
            return undefined;
          }
          const f = operands.findIndex((item: string) => item === 'formId');
          return operands[f + 1].value;
        };

        const relatedResourceId = getDstIdItem() || getFormIdItem() || '';

        const scheduleConfigInput = getDataSlot<any>(formData, 'scheduleRule');
        const scheduleConfig = scheduleConfigInput
          ? { ...TimeScheduleManager.getCronWithTimeZone(scheduleConfigInput), ['timeZone']: getDataParameter<string>(formData, 'timeZone')! }
          : undefined;
        updateTriggerInput(automationState?.resourceId, trigger.triggerId, formData, automationState?.robot?.robotId, {
          relatedResourceId,
          scheduleConfig,
        })
          .then(() => {
            refreshItem();
            setLocalStateMap(
              produce(localStateMap, (draft) => {
                draft.set(trigger.triggerId!, formData);
              }),
            );
            Message.success({
              content: t(Strings.robot_save_step_success),
            });
          })
          .catch(() => {
            Message.error({
              content: t(Strings.robot_save_step_failed),
            });
          });
      }
    },
    [automationState?.resourceId, automationState?.robot?.robotId, localStateMap, refreshItem, setLocalStateMap, trigger.input, trigger.triggerId],
  );
  const { screenIsAtMost } = useResponsive();
  const isMobile = screenIsAtMost(ScreenSize.lg);

  const { sideBarVisible, setSideBarVisible } = useSideBarVisible();
  const [panelState, setAutomationPanel] = useAtom(automationPanelAtom);

  const isActive = panelState.dataId === trigger.triggerId;

  const permissions = useAutomationResourcePermission();
  const colors = useCssColors();
  const nodeItemControlRef = useRef<INodeFormControlProps | null>(null);

  // Expose submit() for external components (e.g., CreateNewTrigger button creation)
  const triggerFormSubmit = useCallback(() => {
    handleUpdateFormChange(formData);
  }, [formData, handleUpdateFormChange]);
  nodeItemControlRef.current = { submit: triggerFormSubmit };

  const isEntryMode = editType === EditType.entry;
  const TriggerFormComponent = triggerFormMap[triggerType?.endpoint ?? ''];

  const setItem = useSetAtom(automationCurrentTriggerId);
  const handleClick = useCallback(() => {
    if (!permissions.editable) {
      return;
    }
    if (isMobile) {
      setSideBarVisible(false);
    }

    setItem(trigger.triggerId);
    setAutomationPanel({
      panelName: PanelName.Trigger,
      dataId: trigger.triggerId,
      // @ts-ignore
      data: trigger,
    });
  }, [isMobile, permissions.editable, setAutomationPanel, setItem, setSideBarVisible, trigger]);

  const memorisedHandleClick = useMemo(() => {
    return editType === EditType.entry ? handleClick : undefined;
  }, [editType, handleClick]);

  const formMeta = useAtomValue(loadableFormItemAtom);

  let formItemInfo = (formMeta?.data as any)?.form;

  const formId = getFormId({ input: formData });

  const { data } = useSWR(['fetchFormPack', formId], () => fetchFormPack(String(formId!)).then((res) => res?.data?.data ?? ({} as IServerFormPack)), {
    isPaused: () => formId == null,
  });

  if (editType === EditType.entry) {
    formItemInfo = data?.form;
  }

  const handleUpdate = useCallback(
    (newFormData: any) => {
      const previous = getRelativedId({ input: formData });
      const current = getRelativedId({ input: newFormData });

      const removeFiltered = produce(newFormData, (draft) => {
        draft.value.operands.splice(2);
      });

      const data = TimeScheduleManager.checkScheduleConfig(formData, newFormData);
      setLocalStateMap(
        produce((draft) => {
          if (previous !== current) {
            draft.set(trigger.triggerId, removeFiltered);
            return;
          }

          draft.set(trigger.triggerId, data);
        }),
      );
    },
    [formData, setLocalStateMap, trigger.triggerId],
  );

  const { shareInfo } = useContext(ShareContext);

  // === Entry mode: show summary card (NodeFormInfo) ===
  if (isEntryMode) {
    return (
      <NodeFormInfo
        disabled={!permissions.editable}
        index={index}
        ref={nodeItemControlRef}
        handleClick={memorisedHandleClick}
        itemId={buttonFieldTrigger?.triggerTypeId === trigger?.triggerTypeId ? 'NODE_FORM_ACTIVE' : undefined}
        nodeId={trigger.triggerId}
        key={trigger.triggerId}
        formData={formData}
        handleDelete={handleDelete}
        unsaved={modified}
        title={triggerType?.name}
        description={triggerType?.description}
        serviceLogo={triggerType?.service ? getAutomationServiceLogo(triggerType.service) : undefined}
        type="trigger"
      >
        <SearchSelect
          // @ts-ignore
          ref={ref}
          clazz={{
            item: itemStyle.item,
            icon: itemStyle.icon,
          }}
          disabled={!permissions.editable}
          options={{
            placeholder: t(Strings.search_field),
            minWidth: '384px',
            noDataText: t(Strings.empty_data),
          }}
          list={triggerTypeOptionsWithoutButtonIsClicked}
          onChange={(item) => handleTriggerTypeChange(String(item.value))}
          value={triggerTypeId}
        >
          <span>
            <DropdownTrigger isActive={isActive} editable={permissions.editable}>
              <>
                {1}. {triggerType?.name}
              </>
            </DropdownTrigger>
          </span>
        </SearchSelect>
      </NodeFormInfo>
    );
  }

  // === Detail mode: render fixed form component ===
  return (
    <Box height="100%" display="flex" flexDirection="column" overflow="hidden">
      <Box flex="1 1 auto" overflow="auto" minHeight={0}>
        <Typography variant="h6" color={colors.textCommonPrimary}>
          {triggerType?.name}
        </Typography>
        <Typography variant="body4" style={{ marginTop: 8 }} color={colors.textCommonTertiary}>
          {triggerType?.description}
        </Typography>

        <Box marginTop="16px">
          {TriggerFormComponent ? (
            <TriggerFormComponent
              formData={formData}
              onChange={(newFormData: any) => {
                setLocalStateMap(
                  produce((draft) => {
                    draft.set(trigger.triggerId, newFormData);
                  }),
                );
              }}
              defaultDatasheetId={datasheetId}
              defaultTimeZone={userTimezone}
              datasheetId={datasheetId}
              triggerId={trigger.triggerId}
              resourceId={automationState?.resourceId ?? ''}
            />
          ) : (
            <Typography variant="body4" color={colors.textCommonTertiary}>
              {t(Strings.robot_config_empty_warning)}
            </Typography>
          )}
        </Box>
      </Box>

      <Box flex="0 0 32px" marginTop="16px" display="flex" width="100%" justifyContent="center" flexDirection="row-reverse">
        <Box display="flex">
          <button
            type="button"
            style={{
              width: '128px',
              height: '32px',
              background: '#5586FF',
              color: '#fff',
              border: 'none',
              borderRadius: '4px',
              cursor: 'pointer',
              fontSize: '14px',
              position: 'relative',
              zIndex: 10,
            }}
            onClick={() => handleUpdateFormChange(formData)}
          >
            {t(Strings.robot_save_step_button)}
          </button>
        </Box>
      </Box>
    </Box>
  );
});

const readOnlyArray: ReadonlyArray<Trigger> = [];

const UpperTypography = styled(Typography)`
  text-transform: uppercase;
`;

export const RobotTrigger = memo(({ robotId, editType, triggerTypes }: IRobotTriggerProps) => {
  const robot = useAtomValue(automationStateAtom);
  const setItem = useSetAtom(automationCurrentTriggerId);
  const triggerList = getTriggerList((robot?.robot?.triggers ?? readOnlyArray) as IRobotTrigger[]);

  const currentTriggerId = useAtomValue(automationCurrentTriggerId);
  const permissions = useAutomationResourcePermission();
  const colors = useCssColors();

  const { setSideBarVisible } = useSideBarVisible();
  const setAutomationPanel = useSetAtom(automationPanelAtom);
  const buttonFieldTrigger = triggerTypes.find((item) => item.endpoint === 'button_field' || item.endpoint === 'button_clicked');
  let list = triggerList;

  const [atomValue, setAutomationSource] = useAtom(automationSourceAtom);

  const checkGuideRef: MutableRefObject<boolean> = useRef(false);

  useMount(() => {
    if (editType === EditType.detail) {
      return;
    }
    checkGuideRef.current = atomValue === 'datasheet';
    setAutomationSource(undefined);
  });

  useEffect(() => {
    const item = list.find((trigger) => trigger.triggerTypeId === buttonFieldTrigger?.triggerTypeId);
    if (item == null) {
      return;
    }
    if (!permissions.editable) {
      return;
    }

    if (editType === EditType.detail) {
      return;
    }
    if (robot?.scenario === AutomationScenario.datasheet) {
      return;
    }
    if (checkGuideRef.current) {
      setSideBarVisible(true);
      setTimeout(() => {
        setItem(item.triggerId);
        const newPanel: IAutomationPanel = {
          panelName: PanelName.Trigger,
          dataId: item.triggerId,
          // @ts-ignore
          data: item,
        };
        setAutomationPanel(newPanel);
        Player.doTrigger(Events['guide_use_button_column_first_time']);
      }, 2000);
    }
    checkGuideRef.current = false;
    setAutomationSource(undefined);
  }, [
    atomValue,
    buttonFieldTrigger?.triggerTypeId,
    editType,
    list,
    permissions.editable,
    robot?.scenario,
    setAutomationPanel,
    setAutomationSource,
    setItem,
    setSideBarVisible,
  ]);

  if (!triggerTypes) {
    return null;
  }

  if (editType === EditType.detail) {
    list = triggerList.filter((trigger) => trigger.triggerId === currentTriggerId);
  }

  if (triggerList.length === 0) {
    return (
      <OrEmpty visible={permissions?.editable}>
        <RobotTriggerCreateForm robotId={robotId} triggerTypes={triggerTypes} preTriggerId={undefined} />
      </OrEmpty>
    );
  }

  // The default value of the rich input form, the trigger, is officially controllable.
  return (
    <>
      {list.map((trigger, index) => (
        <>
          <RobotTriggerBase
            key={`${trigger.triggerId}${trigger.prevTriggerId}`}
            index={index}
            trigger={trigger}
            editType={editType}
            triggerTypes={triggerTypes}
          />

          <OrEmpty visible={index < CONST_MAX_TRIGGER_COUNT - 1 && editType === EditType.entry}>
            <Box display={'flex'} padding={index === list.length - 1 ? '16px 0 0 0' : '16px 0'} justifyContent={'center'} alignItems={'center'}>
              <Box borderRadius={'12px'} background={colors.bgBrandLightDefault} padding={'2px 12px'}>
                <UpperTypography variant={'body3'} color={colors.textBrandDefault}>
                  {t(Strings.or)}
                </UpperTypography>
              </Box>
            </Box>
          </OrEmpty>
        </>
      ))}

      <OrEmpty visible={triggerList.length < CONST_MAX_TRIGGER_COUNT && editType === EditType.entry}>
        <OrTooltip
          tooltipEnable={triggerList?.length >= CONST_MAX_TRIGGER_COUNT}
          tooltip={t(Strings.automation_action_num_warning, {
            value: CONST_MAX_TRIGGER_COUNT,
          })}
          placement={'top'}
        >
          <RobotTriggerCreateForm robotId={robotId} triggerTypes={triggerTypes} preTriggerId={triggerList[triggerList?.length - 1].triggerId} />
        </OrTooltip>
      </OrEmpty>
    </>
  );
});
