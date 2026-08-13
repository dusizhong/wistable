/**
 * Fixed form for "button_clicked" trigger.
 * Fields: datasheetId + buttonFieldId (button column selector).
 */
import React, { useCallback } from 'react';
import { Box, Typography } from '@apitable/components';
import { SelectDst } from '../../../../automation/select_dst';
import { CreateNewTrigger } from '../../create_new_trigger/create_new_trigger';
import { ReadonlyFieldColumn } from '../../trigger/readonly_field_column';
import { getOperandValue, literal2Operand, setOperandValue } from '../../node_form/expression_form_utils';

interface IButtonClickedFormProps {
  formData: any;
  onChange: (formData: any) => void;
  datasheetId: string;
  triggerId: string;
  resourceId: string;
  onSubmitTrigger?: () => void;
}

export const ButtonClickedForm: React.FC<IButtonClickedFormProps> = ({
  formData,
  onChange,
  datasheetId,
  triggerId,
  resourceId,
  onSubmitTrigger,
}) => {
  const currentDstId = getOperandValue<string>(formData, 'datasheetId') ?? datasheetId ?? '';
  const currentFieldId = getOperandValue<string>(formData, 'buttonFieldId') ?? '';

  const handleDstChange = useCallback(
    (dstId: string | undefined) => {
      const newFormData = setOperandValue(formData, 'datasheetId', literal2Operand(dstId));
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const effectiveDstId = currentDstId || datasheetId;

  const handleFieldChange = useCallback(
    (fieldId: string) => {
      let newFormData = formData;
      // Ensure datasheetId is in formData when saving buttonFieldId
      if (!getOperandValue<string>(formData, 'datasheetId') && effectiveDstId) {
        newFormData = setOperandValue(newFormData, 'datasheetId', literal2Operand(effectiveDstId));
      }
      newFormData = setOperandValue(newFormData, 'buttonFieldId', literal2Operand(fieldId));
      onChange(newFormData);
      setTimeout(() => {
        onSubmitTrigger?.();
      }, 1000);
    },
    [formData, onChange, onSubmitTrigger, effectiveDstId],
  );

  return (
    <Box>
      <Typography variant="body4" style={{ marginBottom: 8 }}>
        选择表格
      </Typography>
      <SelectDst value={currentDstId} onChange={handleDstChange} />

      <Box marginTop="16px">
        <Typography variant="body4" style={{ marginBottom: 8 }}>
          选择按钮字段
        </Typography>
        {!currentFieldId && resourceId && effectiveDstId && (
          <CreateNewTrigger
            datasheetId={effectiveDstId}
            resourceId={resourceId}
            triggerId={triggerId}
            onSubmit={handleFieldChange}
          />
        )}
        {effectiveDstId && resourceId && (
          <ReadonlyFieldColumn
            triggerId={triggerId}
            resourceId={resourceId}
            onSubmit={handleFieldChange}
            datasheetId={effectiveDstId}
            fieldId={currentFieldId}
          />
        )}
      </Box>
    </Box>
  );
};
