/**
 * Fixed form for "record_matches_conditions" trigger.
 * Fields: datasheetId (selector) + filter (condition builder).
 */
import React, { useCallback, useMemo } from 'react';
import { Box, Typography } from '@apitable/components';
import { ILiteralOperand, OperatorEnums } from '@apitable/core';
import { SelectDst } from '../../../../automation/select_dst';
import { RecordMatchesConditionsFilter } from '../record_matches_conditions_filter';
import { getOperandSlot, getOperandValue, literal2Operand, setOperandValue } from '../../node_form/expression_form_utils';

interface IRecordMatchesConditionsFormProps {
  formData: any;
  onChange: (formData: any) => void;
  defaultDatasheetId?: string;
  datasheetId: string;
}

export const RecordMatchesConditionsForm: React.FC<IRecordMatchesConditionsFormProps> = ({
  formData,
  onChange,
  defaultDatasheetId,
  datasheetId,
}) => {
  // Use the value from formData first, then fall back to props
  const effectiveDstId = getOperandValue<string>(formData, 'datasheetId') ?? datasheetId ?? defaultDatasheetId ?? '';

  const filterOperand = getOperandSlot(formData, 'filter');

  const filterValue = useMemo(() => {
    if (filterOperand == null || filterOperand.value == null) {
      return { operator: OperatorEnums.And, operands: [] };
    }
    return filterOperand.value;
  }, [filterOperand]);

  const handleFilterChange = useCallback(
    (value: ILiteralOperand) => {
      const newFormData = setOperandValue(formData, 'filter', value);
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const handleDstChange = useCallback(
    (dstId: string | undefined) => {
      const nextFormData = setOperandValue(formData, 'datasheetId', literal2Operand(dstId));
      onChange(nextFormData);
    },
    [formData, onChange],
  );

  return (
    <Box>
      <Typography variant="body4" style={{ marginBottom: 8 }}>
        选择表格
      </Typography>
      <SelectDst value={effectiveDstId} onChange={handleDstChange} />

      {effectiveDstId ? (
        <Box marginTop="16px">
          <Typography variant="body4" style={{ marginBottom: 8 }}>
            筛选条件
          </Typography>
          <RecordMatchesConditionsFilter
            datasheetId={effectiveDstId}
            filter={filterValue}
            onChange={handleFilterChange}
          />
        </Box>
      ) : (
        <Typography variant="body4" style={{ marginTop: 8 }} color="textCommonTertiary">
          请选择表格后配置筛选条件
        </Typography>
      )}
    </Box>
  );
};
