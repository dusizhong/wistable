/**
 * Shared utility functions for fixed form components.
 *
 * All automation form data uses the Expression/operand format:
 *   { type: 'Expression', value: { operator: 'newObject', operands: [key1, {type:'Literal',value:val1}, key2, ...] } }
 *
 * These helpers bridge between React form components (work with plain values)
 * and the backend's Expression format.
 */

/** Wrap a plain JS value into an operand literal */
export const literal2Operand = (literal: any): object => {
  return {
    type: 'Literal',
    value: literal,
  };
};

/** Unwrap an operand literal back to plain value */
export const operand2Literal = (operand: any): any => {
  if (operand == null) {
    return null;
  }
  if (operand.type === 'Literal') {
    return operand.value;
  }
  return operand;
};

/**
 * Extract a plain value from an Expression formData by field name.
 * Returns undefined if the field doesn't exist.
 */
export function getOperandValue<T = any>(formData: any, fieldName: string): T | undefined {
  if (!formData?.value?.operands) {
    return undefined;
  }
  const operands = formData.value.operands;
  const idx = operands.findIndex((item: any) => typeof item === 'string' && item === fieldName);
  if (idx === -1 || idx + 1 >= operands.length) {
    return undefined;
  }
  return operand2Literal(operands[idx + 1]);
}

/**
 * Extract the raw operand for a field.
 * Returns undefined if the field doesn't exist.
 */
export function getOperandSlot(formData: any, fieldName: string): any | undefined {
  if (!formData?.value?.operands) {
    return undefined;
  }
  const operands = formData.value.operands;
  const idx = operands.findIndex((item: any) => typeof item === 'string' && item === fieldName);
  if (idx === -1 || idx + 1 >= operands.length) {
    return undefined;
  }
  return operands[idx + 1];
}

/**
 * Set or update a field in the Expression formData.
 * Returns a new formData object with the field set to the given operand value.
 */
export function setOperandValue(formData: any, fieldName: string, operandValue: any): any {
  const operands = formData?.value?.operands ? [...formData.value.operands] : [];
  const idx = operands.findIndex((item: any) => typeof item === 'string' && item === fieldName);

  if (idx !== -1) {
    operands[idx + 1] = operandValue;
  } else {
    operands.push(fieldName, operandValue);
  }

  return {
    type: 'Expression',
    value: {
      operator: 'newObject',
      operands,
    },
  };
}

/**
 * Build a fresh Expression object from key-value pairs.
 * Each value should already be in operand format (i.e. {type:'Literal',value:...}).
 */
export function buildExpressionObject(fields: Record<string, any>): any {
  const operands: any[] = [];
  for (const [key, value] of Object.entries(fields)) {
    operands.push(key, value);
  }
  return {
    type: 'Expression',
    value: {
      operator: 'newObject',
      operands,
    },
  };
}
