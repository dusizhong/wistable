/**
 * Fixed form for "sendRequest" (webhook) action.
 * Fields: url, method (select), headers (dynamic array), body.type (select), body.data (MagicTextField).
 */
import React, { useCallback, useEffect, useMemo } from 'react';
import { Box, Typography, IOption, DropdownSelect } from '@apitable/components';
import { AddOutlined, DeleteOutlined } from '@apitable/icons';
import { MagicTextField, TriggerDataSheetMap } from '../../magic_variable_container/magic_text_field';
import { INodeOutputSchema, ITriggerType } from '../../../interface';
import { getOperandSlot, getOperandValue, literal2Operand, setOperandValue, buildExpressionObject } from '../../node_form/expression_form_utils';

interface ISendWebhookFormProps {
  formData: any;
  onChange: (formData: any) => void;
  nodeOutputSchemaList: INodeOutputSchema[];
  triggerType: ITriggerType | null;
  triggerDataSheetMap: TriggerDataSheetMap;
}

const HTTP_METHODS = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];
const BODY_TYPES = ['json', 'raw', 'form-data'];

const textSchema: any = { type: 'string' };

export const SendWebhookForm: React.FC<ISendWebhookFormProps> = ({
  formData,
  onChange,
  nodeOutputSchemaList,
  triggerType,
  triggerDataSheetMap,
}) => {
  const urlValue = getOperandSlot(formData, 'url');
  const methodValue = getOperandValue<string>(formData, 'method') ?? 'POST';
  const bodyOperand = getOperandSlot(formData, 'body');
  const bodyType = getOperandValue<string>(bodyOperand, 'type') ?? 'json';
  const bodyDataValue = getOperandSlot(bodyOperand, 'data');
  const headersOperand = getOperandSlot(formData, 'headers');

  // Parse existing headers from Expression format
  const headersList = useMemo(() => {
    if (!headersOperand || headersOperand.type !== 'Expression' || headersOperand.value?.operator !== 'newArray') {
      return [];
    }
    return (headersOperand.value.operands || []).map((item: any) => ({
      key: getOperandValue(item, 'key') ?? '',
      value: getOperandValue(item, 'value') ?? '',
    }));
  }, [headersOperand]);

  const commonProps = useMemo(
    () => ({ nodeOutputSchemaList, triggerType, triggerDataSheetMap }),
    [nodeOutputSchemaList, triggerType, triggerDataSheetMap],
  );

  // Dynamic ID for body data field based on body type (affects placeholder text)
  const bodyDataId = useMemo(() => {
    const cleanType = bodyType.replace(/-/g, '');
    return `body_data_${cleanType}`;
  }, [bodyType]);

  // Initialize default values for required fields so they are saved in the Expression formData
  useEffect(() => {
    let nextFormData = formData;
    if (!getOperandSlot(formData, 'method')) {
      nextFormData = setOperandValue(nextFormData, 'method', literal2Operand('POST'));
    }
    if (nextFormData !== formData) {
      onChange(nextFormData);
    }
    // Only run on mount when formData is empty/new
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleUrlChange = useCallback(
    (value: any) => {
      const newFormData = setOperandValue(formData, 'url', value);
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const handleMethodChange = useCallback(
    (option: IOption) => {
      const newFormData = setOperandValue(formData, 'method', literal2Operand(option.value));
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const handleBodyTypeChange = useCallback(
    (option: IOption) => {
      const newBody = setOperandValue(bodyOperand || buildExpressionObject({}), 'type', literal2Operand(option.value));
      const newFormData = setOperandValue(formData, 'body', newBody);
      onChange(newFormData);
    },
    [formData, bodyOperand, onChange],
  );

  const handleBodyDataChange = useCallback(
    (value: any) => {
      const base = bodyOperand || buildExpressionObject({ type: literal2Operand(bodyType) });
      const newBody = setOperandValue(base, 'data', value);
      const newFormData = setOperandValue(formData, 'body', newBody);
      onChange(newFormData);
    },
    [formData, bodyOperand, bodyType, onChange],
  );

  const handleHeaderKeyChange = useCallback(
    (index: number, newKey: string) => {
      const newHeaders = headersList.map((h, i) => (i === index ? { ...h, key: newKey } : h));
      updateHeaders(newHeaders);
    },
    [headersList, formData, onChange],
  );

  const handleHeaderValueChange = useCallback(
    (index: number, newValue: string) => {
      const newHeaders = headersList.map((h, i) => (i === index ? { ...h, value: newValue } : h));
      updateHeaders(newHeaders);
    },
    [headersList, formData, onChange],
  );

  const updateHeaders = useCallback(
    (headers: { key: string; value: string }[]) => {
      const operands = headers.map((h) =>
        buildExpressionObject({
          key: literal2Operand(h.key),
          value: literal2Operand(h.value),
        }),
      );
      const newHeadersExpr = {
        type: 'Expression',
        value: { operator: 'newArray', operands },
      };
      const newFormData = setOperandValue(formData, 'headers', newHeadersExpr);
      onChange(newFormData);
    },
    [formData, onChange],
  );

  const addHeader = useCallback(() => {
    updateHeaders([...headersList, { key: '', value: '' }]);
  }, [headersList, updateHeaders]);

  const removeHeader = useCallback(
    (index: number) => {
      updateHeaders(headersList.filter((_, i) => i !== index));
    },
    [headersList, updateHeaders],
  );

  const methodOptions = HTTP_METHODS.map((m) => ({ value: m, label: m }));
  const bodyTypeOptions = BODY_TYPES.map((bt) => ({ value: bt, label: bt }));

  return (
    <Box>
      {/* URL */}
      <Box marginBottom="16px">
        <Typography variant="body4" style={{ marginBottom: 4 }}>
          请求 URL
        </Typography>
        <Box maxWidth="100%" maxHeight="300px" overflowY="auto" overflowX="auto">
          <MagicTextField
            id="webhook_url"
            schema={textSchema}
            value={urlValue}
            onChange={handleUrlChange}
            {...commonProps}
          />
        </Box>
      </Box>

      {/* HTTP Method */}
      <Box marginBottom="16px">
        <Typography variant="body4" style={{ marginBottom: 4 }}>
          HTTP 方法
        </Typography>
        <DropdownSelect
          value={methodValue}
          options={methodOptions}
          onSelected={handleMethodChange}
        />
      </Box>

      {/* Headers */}
      <Box marginBottom="16px">
        <Typography variant="body4" style={{ marginBottom: 4 }}>
          请求头
        </Typography>
        {headersList.map((header, index) => (
          <Box key={index} display="flex" alignItems="center" marginBottom="8px" gap="8px">
            <input
              style={{ flex: 1, padding: '4px 8px', border: '1px solid var(--borderCommonDefault)', borderRadius: 4, color: 'var(--textCommonPrimary)', backgroundColor: 'var(--bgCommonLower)' }}
              placeholder="请输入 Key"
              value={header.key}
              onChange={(e) => handleHeaderKeyChange(index, e.target.value)}
            />
            <input
              style={{ flex: 1, padding: '4px 8px', border: '1px solid var(--borderCommonDefault)', borderRadius: 4, color: 'var(--textCommonPrimary)', backgroundColor: 'var(--bgCommonLower)' }}
              placeholder="请输入 Value"
              value={header.value}
              onChange={(e) => handleHeaderValueChange(index, e.target.value)}
            />
            <button
              type="button"
              style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4 }}
              onClick={() => removeHeader(index)}
            >
              <DeleteOutlined />
            </button>
          </Box>
        ))}
        <button
          type="button"
          style={{
            background: 'none',
            border: '1px dashed var(--borderCommonDefault)',
            borderRadius: 4,
            padding: '4px 12px',
            cursor: 'pointer',
            fontSize: 13,
            display: 'flex',
            alignItems: 'center',
            gap: 4,
          }}
          onClick={addHeader}
        >
          <AddOutlined /> 添加请求头
        </button>
      </Box>

      {/* Body */}
      <Box marginBottom="16px">
        <Typography variant="body4" style={{ marginBottom: 4 }}>
          请求体
        </Typography>

        {/* Body type */}
        <Box marginBottom="8px">
          <DropdownSelect
            value={bodyType}
            options={bodyTypeOptions}
            onSelected={handleBodyTypeChange}
          />
        </Box>

        {/* Body data */}
        <Box maxWidth="100%" maxHeight="300px" overflowY="auto" overflowX="auto">
          <MagicTextField
            id={bodyDataId}
            schema={textSchema}
            value={bodyDataValue}
            onChange={handleBodyDataChange}
            {...commonProps}
          />
        </Box>
      </Box>
    </Box>
  );
};
