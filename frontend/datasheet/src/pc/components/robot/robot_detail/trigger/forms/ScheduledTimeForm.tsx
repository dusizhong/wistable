/**
 * Fixed form for "scheduled_time_arrive" trigger.
 * Fields: timeZone (dropdown) + scheduleType (day/week/month/hour) + scheduleRule (cron editor).
 */
import React, { useCallback, useMemo } from 'react';
import { DropdownSelect, IOption } from '@apitable/components';
import { CronConverter } from '@apitable/components';
import { AutomationInterval } from '@apitable/components/dist/components/time/utils';
import { getUtcOptionList, Selectors } from '@apitable/core';
import { Just, Maybe } from 'purify-ts/index';
import { AutomationTiming } from '../../automation_timing';
import { TimeScheduleManager, TimeScheduleTransformer, NodeFormData } from '../../trigger/time_schedule_manager';
import { getOperandValue, literal2Operand, setOperandValue, getOperandSlot } from '../../node_form/expression_form_utils';
import { useAppSelector } from 'pc/store/react-redux';

const SCHEDULE_TYPE_OPTIONS: IOption[] = [
  { label: '每天', value: 'day' },
  { label: '每周', value: 'week' },
  { label: '每月', value: 'month' },
  { label: '每小时', value: 'hour' },
];

interface IScheduledTimeFormProps {
  formData: any;
  onChange: (formData: any) => void;
  defaultTimeZone?: string;
}

export const ScheduledTimeForm: React.FC<IScheduledTimeFormProps> = ({
  formData,
  onChange,
  defaultTimeZone,
}) => {
  const userTimezone = useAppSelector(Selectors.getUserTimeZone)!;
  const tz = getOperandValue<string>(formData, 'timeZone') ?? defaultTimeZone ?? userTimezone;
  const scheduleType = (getOperandValue<string>(formData, 'scheduleType') ?? 'day') as AutomationInterval;
  const options = getUtcOptionList();

  const scheduleRuleOperand = getOperandSlot(formData, 'scheduleRule');
  const cronValue = useMemo(() => {
    if (scheduleRuleOperand) {
      return TimeScheduleManager.getCronWithTimeZone(scheduleRuleOperand);
    }
    return {};
  }, [scheduleRuleOperand]);

  const handleTimeZoneChange = useCallback(
    (option: IOption) => {
      const newFormData = setOperandValue(formData, 'timeZone', literal2Operand(option.value as string));
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const handleScheduleTypeChange = useCallback(
    (option: IOption) => {
      const newType = option.value as AutomationInterval;
      let newFormData = setOperandValue(formData, 'scheduleType', literal2Operand(newType));

      // Reset scheduleRule with default cron values for the new schedule type
      const defaultCron = CronConverter.getDefaultValue(newType);
      const extractedCron = CronConverter.extractCron(defaultCron);
      if (extractedCron) {
        const emptyObject: NodeFormData = {
          type: 'Expression',
          value: {
            operator: 'newObject',
            operands: [],
          },
        };
        const newScheduleData: Maybe<NodeFormData> = Just(emptyObject)
          .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'dayOfWeek', literal2Operand(extractedCron.dayOfWeek))))
          .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'minute', literal2Operand(extractedCron.minute))))
          .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'month', literal2Operand(extractedCron.month))))
          .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'hour', literal2Operand(extractedCron.hour))))
          .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'dayOfMonth', literal2Operand(extractedCron.dayOfMonth))));

        newFormData = setOperandValue(newFormData, 'scheduleRule', newScheduleData.extract());
      }
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const handleScheduleChange = useCallback(
    (x: any) => {
      const emptyObject: NodeFormData = {
        type: 'Expression',
        value: {
          operator: 'newObject',
          operands: [],
        },
      };

      const newScheduleData: Maybe<NodeFormData> = Just(emptyObject)
        .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'dayOfWeek', literal2Operand(x.dayOfWeek))))
        .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'minute', literal2Operand(x.minute))))
        .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'month', literal2Operand(x.month))))
        .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'hour', literal2Operand(x.hour))))
        .chain((item) => Just(TimeScheduleTransformer.modifyNodeForm(item, 'dayOfMonth', literal2Operand(x.dayOfMonth))));

      let newFormData = setOperandValue(formData, 'scheduleRule', newScheduleData.extract());
      // Ensure scheduleType is saved
      if (!getOperandValue<string>(formData, 'scheduleType')) {
        newFormData = setOperandValue(newFormData, 'scheduleType', literal2Operand('day'));
      }
      onChange(newFormData);
    },
    [formData, onChange],
  );

  return (
    <div>
      <div style={{ marginBottom: 16 }}>
        <div style={{ marginBottom: 8, fontSize: 13, color: 'var(--textCommonTertiary)' }}>
          时区
        </div>
        <DropdownSelect
          disabled={false}
          triggerStyle={{ minWidth: '64px' }}
          openSearch
          searchPlaceholder="搜索记录"
          value={tz}
          options={options}
          onSelected={handleTimeZoneChange}
        />
      </div>

      <div style={{ marginBottom: 16 }}>
        <div style={{ marginBottom: 8, fontSize: 13, color: 'var(--textCommonTertiary)' }}>
          定时类型
        </div>
        <DropdownSelect
          disabled={false}
          triggerStyle={{ minWidth: '64px' }}
          value={scheduleType}
          options={SCHEDULE_TYPE_OPTIONS}
          onSelected={handleScheduleTypeChange}
        />
      </div>

      <div>
        <div style={{ marginBottom: 8, fontSize: 13, color: 'var(--textCommonTertiary)' }}>
          定时规则
        </div>
        <AutomationTiming
          value={cronValue}
          onUpdate={handleScheduleChange}
          scheduleType={scheduleType}
          tz={tz}
          options={{ userTimezone }}
        />
      </div>
    </div>
  );
};
