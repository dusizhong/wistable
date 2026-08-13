/**
 * Fixed form for "sendMail" action.
 * Fields: to, subject, body — all MagicTextField with variable support.
 */
import React, { useCallback, useMemo } from 'react';
import { Box, Typography } from '@apitable/components';
import { MagicTextField, TriggerDataSheetMap } from '../../magic_variable_container/magic_text_field';
import { INodeOutputSchema, ITriggerType } from '../../../interface';
import { getOperandSlot, literal2Operand, setOperandValue } from '../../node_form/expression_form_utils';

interface ISendMailFormProps {
  formData: any;
  onChange: (formData: any) => void;
  nodeOutputSchemaList: INodeOutputSchema[];
  triggerType: ITriggerType | null;
  triggerDataSheetMap: TriggerDataSheetMap;
}

/** Minimal schema shape MagicTextField expects (format: 'json' triggers JSON mode) */
const textSchema: any = { type: 'string' };

export const SendMailForm: React.FC<ISendMailFormProps> = ({
  formData,
  onChange,
  nodeOutputSchemaList,
  triggerType,
  triggerDataSheetMap,
}) => {
  const toValue = getOperandSlot(formData, 'to');
  const subjectValue = getOperandSlot(formData, 'subject');
  const bodyValue = getOperandSlot(formData, 'body');

  const commonProps = useMemo(
    () => ({
      nodeOutputSchemaList,
      triggerType,
      triggerDataSheetMap,
    }),
    [nodeOutputSchemaList, triggerType, triggerDataSheetMap],
  );

  const handleToChange = useCallback(
    (value: any) => {
      const newFormData = setOperandValue(formData, 'to', value);
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const handleSubjectChange = useCallback(
    (value: any) => {
      const newFormData = setOperandValue(formData, 'subject', value);
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const handleBodyChange = useCallback(
    (value: any) => {
      const newFormData = setOperandValue(formData, 'body', value);
      onChange(newFormData);
    },
    [formData, onChange],
  );

  return (
    <Box>
      <Box marginBottom="16px">
        <Typography variant="body4" style={{ marginBottom: 4 }}>
          收件人
        </Typography>
        <Box maxWidth="100%" maxHeight="300px" overflowY="auto" overflowX="auto">
          <MagicTextField
            id="mail_to"
            schema={textSchema}
            value={toValue}
            onChange={handleToChange}
            {...commonProps}
          />
        </Box>
      </Box>

      <Box marginBottom="16px">
        <Typography variant="body4" style={{ marginBottom: 4 }}>
          主题
        </Typography>
        <Box maxWidth="100%" maxHeight="300px" overflowY="auto" overflowX="auto">
          <MagicTextField
            id="mail_subject"
            schema={textSchema}
            value={subjectValue}
            onChange={handleSubjectChange}
            {...commonProps}
          />
        </Box>
      </Box>

      <Box marginBottom="16px">
        <Typography variant="body4" style={{ marginBottom: 4 }}>
          邮件正文
        </Typography>
        <Box maxWidth="100%" maxHeight="300px" overflowY="auto" overflowX="auto">
          <MagicTextField
            id="mail_body"
            schema={textSchema}
            value={bodyValue}
            onChange={handleBodyChange}
            {...commonProps}
          />
        </Box>
      </Box>
    </Box>
  );
};
