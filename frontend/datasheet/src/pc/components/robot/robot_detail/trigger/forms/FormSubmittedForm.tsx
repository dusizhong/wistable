/**
 * Fixed form for "form_submitted" trigger.
 * Single field: form selector using SelectForm component.
 */
import React, { useCallback } from 'react';
import { Box } from '@apitable/components';
import { SelectForm } from '../../../../automation/select_dst';
import { getOperandValue, literal2Operand, setOperandValue } from '../../node_form/expression_form_utils';

interface IFormSubmittedFormProps {
  formData: any;
  onChange: (formData: any) => void;
}

export const FormSubmittedForm: React.FC<IFormSubmittedFormProps> = ({ formData, onChange }) => {
  const currentValue = getOperandValue<string>(formData, 'formId') ?? '';

  const handleChange = useCallback(
    (formId: string | undefined) => {
      onChange(setOperandValue(formData, 'formId', literal2Operand(formId)));
    },
    [formData, onChange],
  );

  return (
    <Box>
      <Box marginBottom="8px" fontSize="13px" color="var(--textCommonTertiary)">
        选择表单
      </Box>
      <SelectForm value={currentValue} onChange={handleChange} />
    </Box>
  );
};
