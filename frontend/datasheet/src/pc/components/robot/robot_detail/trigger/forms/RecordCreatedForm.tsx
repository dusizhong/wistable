/**
 * Fixed form for "record_created" trigger.
 * Single field: datasheet selector.
 */
import React, { useCallback } from 'react';
import { Box, Typography } from '@apitable/components';
import { SelectDst } from '../../../../automation/select_dst';
import { getOperandValue, literal2Operand, setOperandValue } from '../../node_form/expression_form_utils';

interface IRecordCreatedFormProps {
  formData: any;
  onChange: (formData: any) => void;
  defaultDatasheetId?: string;
}

export const RecordCreatedForm: React.FC<IRecordCreatedFormProps> = ({ formData, onChange, defaultDatasheetId }) => {
  const currentValue = getOperandValue<string>(formData, 'datasheetId') ?? defaultDatasheetId ?? '';

  const handleChange = useCallback(
    (dstId: string | undefined) => {
      const newFormData = setOperandValue(formData, 'datasheetId', literal2Operand(dstId));
      onChange(newFormData);
    },
    [formData, onChange],
  );

  return (
    <Box>
      <Typography variant="body4" style={{ marginBottom: 8 }}>
        选择表格
      </Typography>
      <SelectDst value={currentValue} onChange={handleChange} />
    </Box>
  );
};
