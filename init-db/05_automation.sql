-- automation service, trigger type & action type seed data
-- Reconstructed from APITable init-appdata (upstream open-source)
-- ID prefix: asv = AUTOMATION_SERVICE, att = AUTOMATION_TRIGGER_TYPE, aat = AUTOMATION_ACTION_TYPE

-- 1. Services

-- 1.1 APITable service (for triggers and built-in actions)
INSERT INTO `apitable_automation_service` (`id`, `service_id`, `slug`, `name`, `description`, `logo`, `base_url`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000001, 'asvApitable01', 'apitable', 'svc_apitable_name', 'svc_apitable_desc', '/static/icon/automation/apitable.svg', NULL, '{"zh": {"svc_apitable_name": "APITable", "svc_apitable_desc": "APITable 原生自动化服务"}, "en": {"svc_apitable_name": "APITable", "svc_apitable_desc": "APITable native automation service"}}', 0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `slug` = VALUES(`slug`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `logo` = VALUES(`logo`),
  `base_url` = VALUES(`base_url`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 1.2 Webhook service (for sendRequest action)
INSERT INTO `apitable_automation_service` (`id`, `service_id`, `slug`, `name`, `description`, `logo`, `base_url`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000002, 'asvWebhook01', 'webhook', 'svc_webhook_name', 'svc_webhook_desc', '/static/icon/automation/webhook.svg', 'automation://webhook', '{"zh": {"svc_webhook_name": "Webhook", "svc_webhook_desc": "Webhook 请求服务"}, "en": {"svc_webhook_name": "Webhook", "svc_webhook_desc": "Webhook request service"}}', 0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `slug` = VALUES(`slug`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `logo` = VALUES(`logo`),
  `base_url` = VALUES(`base_url`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 1.3 Email service (sendMail action, module: sms)
INSERT INTO `apitable_automation_service` (`id`, `service_id`, `slug`, `name`, `description`, `logo`, `base_url`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000003, 'asvEmail01', 'email', 'svc_email_name', 'svc_email_desc', '/static/icon/automation/email.svg', 'automation://sms', '{"zh": {"svc_email_name": "邮件", "svc_email_desc": "邮件发送服务"}, "en": {"svc_email_name": "Email", "svc_email_desc": "Email sending service"}}', 0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `slug` = VALUES(`slug`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `logo` = VALUES(`logo`),
  `base_url` = VALUES(`base_url`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 2. Trigger types (5 triggers, using apitable service)

-- 2.1 Form Submitted
INSERT INTO `apitable_automation_trigger_type` (`id`, `service_id`, `trigger_type_id`, `name`, `description`, `endpoint`, `input_json_schema`, `output_json_schema`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000101, 'asvApitable01', 'attFormSubmitted', 'trigger_form_submitted_name', 'trigger_form_submitted_desc', 'form_submitted',
  '{"schema": {"type": "object", "title": "trigger_form_submitted_input", "properties": {"formId": {"type": "string", "title": "trigger_input_form_selector"}}, "required": ["formId"]}, "uiSchema": {"formId": {"ui:options": {"showTitle": false}}}}',
  '{"schema": {"type": "object", "title": "trigger_form_submitted_output", "properties": {"recordId": {"type": "string", "title": "trigger_output_record_id"}, "fields": {"type": "object", "title": "trigger_output_record_fields"}}}, "uiSchema": {}}',
  '{"zh": {"trigger_form_submitted_name": "表单提交时", "trigger_form_submitted_desc": "当有人通过表单提交数据时触发", "trigger_form_submitted_input": "输入", "trigger_form_submitted_output": "输出", "trigger_input_form_selector": "选择表单", "trigger_output_record_id": "记录 ID", "trigger_output_record_fields": "字段数据"}, "en": {"trigger_form_submitted_name": "When form is submitted", "trigger_form_submitted_desc": "Triggers when a form is submitted", "trigger_form_submitted_input": "Input", "trigger_form_submitted_output": "Output", "trigger_input_form_selector": "Select a form", "trigger_output_record_id": "Record ID", "trigger_output_record_fields": "Field data"}}',
  0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `endpoint` = VALUES(`endpoint`),
  `input_json_schema` = VALUES(`input_json_schema`),
  `output_json_schema` = VALUES(`output_json_schema`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 2.2 Record Matches Conditions
INSERT INTO `apitable_automation_trigger_type` (`id`, `service_id`, `trigger_type_id`, `name`, `description`, `endpoint`, `input_json_schema`, `output_json_schema`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000102, 'asvApitable01', 'attRecordMatch', 'trigger_record_match_name', 'trigger_record_match_desc', 'record_matches_conditions',
  '{"schema": {"type": "object", "title": "trigger_record_match_input", "properties": {"datasheetId": {"type": "string", "title": "trigger_input_datasheet"}, "filter": {"type": "object", "title": "trigger_input_filter"}}, "required": ["datasheetId"]}, "uiSchema": {"datasheetId": {"ui:options": {"showTitle": false}}, "filter": {"ui:options": {"showTitle": false}}}}',
  '{"schema": {"type": "object", "title": "trigger_record_match_output", "properties": {"recordId": {"type": "string", "title": "trigger_output_record_id"}, "fields": {"type": "object", "title": "trigger_output_record_fields"}}}, "uiSchema": {}}',
  '{"zh": {"trigger_record_match_name": "记录满足条件时", "trigger_record_match_desc": "当记录满足指定筛选条件时触发", "trigger_record_match_input": "筛选条件", "trigger_record_match_output": "输出", "trigger_input_datasheet": "关联表格", "trigger_input_filter": "筛选条件", "trigger_output_record_id": "记录 ID", "trigger_output_record_fields": "字段数据"}, "en": {"trigger_record_match_name": "When record matches conditions", "trigger_record_match_desc": "Triggers when a record matches the specified conditions", "trigger_record_match_input": "Conditions", "trigger_record_match_output": "Output", "trigger_input_datasheet": "Datasheet", "trigger_input_filter": "Filter conditions", "trigger_output_record_id": "Record ID", "trigger_output_record_fields": "Field data"}}',
  0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `endpoint` = VALUES(`endpoint`),
  `input_json_schema` = VALUES(`input_json_schema`),
  `output_json_schema` = VALUES(`output_json_schema`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 2.3 Record Created
INSERT INTO `apitable_automation_trigger_type` (`id`, `service_id`, `trigger_type_id`, `name`, `description`, `endpoint`, `input_json_schema`, `output_json_schema`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000103, 'asvApitable01', 'attRecordCreated', 'trigger_record_created_name', 'trigger_record_created_desc', 'record_created',
  '{"schema": {"type": "object", "title": "trigger_record_created_input", "properties": {"datasheetId": {"type": "string", "title": "trigger_input_datasheet"}}, "required": ["datasheetId"]}, "uiSchema": {"datasheetId": {"ui:options": {"showTitle": false}}}}',
  '{"schema": {"type": "object", "title": "trigger_record_created_output", "properties": {"recordId": {"type": "string", "title": "trigger_output_record_id"}, "fields": {"type": "object", "title": "trigger_output_record_fields"}}}, "uiSchema": {}}',
  '{"zh": {"trigger_record_created_name": "有记录创建时", "trigger_record_created_desc": "当表中新增记录时触发", "trigger_record_created_input": "输入", "trigger_record_created_output": "输出", "trigger_input_datasheet": "关联表格", "trigger_output_record_id": "记录 ID", "trigger_output_record_fields": "字段数据"}, "en": {"trigger_record_created_name": "When record is created", "trigger_record_created_desc": "Triggers when a new record is created", "trigger_record_created_input": "Input", "trigger_record_created_output": "Output", "trigger_input_datasheet": "Datasheet", "trigger_output_record_id": "Record ID", "trigger_output_record_fields": "Field data"}}',
  0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `endpoint` = VALUES(`endpoint`),
  `input_json_schema` = VALUES(`input_json_schema`),
  `output_json_schema` = VALUES(`output_json_schema`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 2.4 Button Clicked
INSERT INTO `apitable_automation_trigger_type` (`id`, `service_id`, `trigger_type_id`, `name`, `description`, `endpoint`, `input_json_schema`, `output_json_schema`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000104, 'asvApitable01', 'attButtonClick', 'trigger_button_clicked_name', 'trigger_button_clicked_desc', 'button_clicked',
  '{"schema": {"type": "object", "title": "trigger_button_clicked_input", "properties": {"datasheetId": {"type": "string", "title": "trigger_input_datasheet"}, "buttonFieldId": {"type": "string", "title": "trigger_input_button_field"}}, "required": ["datasheetId", "buttonFieldId"]}, "uiSchema": {"datasheetId": {"ui:options": {"showTitle": false}}, "buttonFieldId": {"ui:options": {"showTitle": false}}}}',
  '{"schema": {"type": "object", "title": "trigger_button_clicked_output", "properties": {"recordId": {"type": "string", "title": "trigger_output_record_id"}, "fields": {"type": "object", "title": "trigger_output_record_fields"}}}, "uiSchema": {}}',
  '{"zh": {"trigger_button_clicked_name": "按钮点击时", "trigger_button_clicked_desc": "当用户点击记录中的按钮时触发", "trigger_button_clicked_input": "按钮配置", "trigger_button_clicked_output": "输出", "trigger_input_datasheet": "关联表格", "trigger_input_button_field": "按钮字段", "trigger_output_record_id": "记录 ID", "trigger_output_record_fields": "字段数据"}, "en": {"trigger_button_clicked_name": "When button is clicked", "trigger_button_clicked_desc": "Triggers when a button in a record is clicked", "trigger_button_clicked_input": "Button Config", "trigger_button_clicked_output": "Output", "trigger_input_datasheet": "Datasheet", "trigger_input_button_field": "Button field", "trigger_output_record_id": "Record ID", "trigger_output_record_fields": "Field data"}}',
  0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `endpoint` = VALUES(`endpoint`),
  `input_json_schema` = VALUES(`input_json_schema`),
  `output_json_schema` = VALUES(`output_json_schema`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 2.5 Scheduled Time
INSERT INTO `apitable_automation_trigger_type` (`id`, `service_id`, `trigger_type_id`, `name`, `description`, `endpoint`, `input_json_schema`, `output_json_schema`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000105, 'asvApitable01', 'attScheduleTime', 'trigger_scheduled_name', 'trigger_scheduled_desc', 'scheduled_time_arrive',
  '{"schema": {"type": "object", "title": "trigger_scheduled_input", "properties": {"timeZone": {"type": "string", "title": "trigger_input_timezone"}, "scheduleRule": {"type": "object", "title": "trigger_input_schedule_rule"}}, "required": ["timeZone"]}, "uiSchema": {"timeZone": {"ui:options": {"showTitle": false}}, "scheduleRule": {"ui:options": {"showTitle": false}}}}',
  '{"schema": {"type": "object", "title": "trigger_scheduled_output", "properties": {"triggerTime": {"type": "string", "title": "trigger_output_trigger_time"}}}, "uiSchema": {}}',
  '{"zh": {"trigger_scheduled_name": "定时触发", "trigger_scheduled_desc": "按设定的时间规则自动触发", "trigger_scheduled_input": "定时配置", "trigger_scheduled_output": "输出", "trigger_input_timezone": "时区", "trigger_input_schedule_rule": "定时规则", "trigger_output_trigger_time": "触发时间"}, "en": {"trigger_scheduled_name": "Scheduled time", "trigger_scheduled_desc": "Triggers based on a time schedule", "trigger_scheduled_input": "Schedule Config", "trigger_scheduled_output": "Output", "trigger_input_timezone": "Timezone", "trigger_input_schedule_rule": "Schedule rule", "trigger_output_trigger_time": "Trigger time"}}',
  0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `endpoint` = VALUES(`endpoint`),
  `input_json_schema` = VALUES(`input_json_schema`),
  `output_json_schema` = VALUES(`output_json_schema`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 3. Action types

-- 3.1 Send Webhook (service: webhook)
INSERT INTO `apitable_automation_action_type` (`id`, `service_id`, `action_type_id`, `name`, `description`, `endpoint`, `input_json_schema`, `output_json_schema`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000201, 'asvWebhook01', 'aatSendWebhook', 'action_webhook_name', 'action_webhook_desc', 'sendRequest',
  '{"schema": {"type": "object", "title": "action_webhook_input", "required": ["url", "method"], "properties": {"url": {"type": "string", "title": "action_input_request_url", "default": "https://"}, "method": {"type": "string", "title": "action_input_http_method", "enum": ["GET", "POST", "PUT", "PATCH", "DELETE"], "default": "POST"}, "headers": {"type": "array", "title": "action_input_headers", "items": {"type": "object", "title": "action_input_header_item", "properties": {"key": {"type": "string", "title": "action_input_header_key"}, "value": {"type": "string", "title": "action_input_header_value"}}}}, "body": {"type": "object", "title": "action_input_request_body", "properties": {"type": {"type": "string", "title": "action_input_body_type", "enum": ["json", "raw", "form-data"], "default": "json"}, "data": {"type": "string", "title": "action_input_body_data"}}}}}, "uiSchema": {"url": {"ui:options": {"showTitle": false}}, "headers": {"ui:options": {"showTitle": true, "addable": true, "removable": true, "orderable": false}, "items": {"key": {"ui:placeholder": "action_input_header_key_placeholder"}, "value": {"ui:placeholder": "action_input_header_value_placeholder"}}}, "body": {"ui:options": {"showTitle": true}, "type": {}, "data": {"ui:placeholder": "action_input_body_data_placeholder", "ui:help": "action_input_body_data_hint"}}}}',
  '{"schema": {"type": "object", "title": "action_webhook_output", "properties": {"statusCode": {"type": "number", "title": "action_output_status_code"}, "body": {"type": "string", "title": "action_output_response_body"}}}, "uiSchema": {}}',
  '{"zh": {"action_webhook_name": "发送 Webhook 请求", "action_webhook_desc": "向指定 URL 发送 HTTP 请求", "action_webhook_input": "请求配置", "action_webhook_output": "响应", "action_input_request_url": "请求 URL", "action_input_http_method": "HTTP 方法", "action_input_headers": "请求头", "action_input_header_item": "请求头项", "action_input_header_key": "Key", "action_input_header_value": "Value", "action_input_header_key_placeholder": "例如: Content-Type", "action_input_header_value_placeholder": "例如: application/json", "action_input_request_body": "请求体", "action_input_body_type": "体类型", "action_input_body_data": "数据", "action_input_body_data_placeholder": "JSON: {key: value}  |  Raw: 输入文本  |  Form-Data: key=value", "action_input_body_data_hint": "支持引用变量, 如 {name: {{触发数据.记录.名称}}}", "action_output_status_code": "状态码", "action_output_response_body": "响应体"}, "en": {"action_webhook_name": "Send Webhook Request", "action_webhook_desc": "Send an HTTP request to a specified URL", "action_webhook_input": "Request Config", "action_webhook_output": "Response", "action_input_request_url": "Request URL", "action_input_http_method": "HTTP Method", "action_input_headers": "Headers", "action_input_header_item": "Header Item", "action_input_header_key": "Key", "action_input_header_value": "Value", "action_input_header_key_placeholder": "e.g. Content-Type", "action_input_header_value_placeholder": "e.g. application/json", "action_input_request_body": "Request Body", "action_input_body_type": "Body Type", "action_input_body_data": "Data", "action_input_body_data_placeholder": "JSON: {key: value}  |  Raw: plain text  |  Form-Data: key=value", "action_input_body_data_hint": "Supports variable refs, e.g. {name: {{Trigger Data.Record.Name}}}", "action_output_status_code": "Status Code", "action_output_response_body": "Response Body"}}',
  0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `endpoint` = VALUES(`endpoint`),
  `input_json_schema` = VALUES(`input_json_schema`),
  `output_json_schema` = VALUES(`output_json_schema`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

-- 3.2 Send Email (service: email, module: sms)
INSERT INTO `apitable_automation_action_type` (`id`, `service_id`, `action_type_id`, `name`, `description`, `endpoint`, `input_json_schema`, `output_json_schema`, `i18n`, `is_deleted`, `created_by`, `updated_by`, `created_at`, `updated_at`)
VALUES (2080500000000000202, 'asvEmail01', 'aatSendMail', 'action_send_mail_name', 'action_send_mail_desc', 'sendMail',
  '{"schema": {"type": "object", "title": "action_send_mail_input", "required": ["to", "subject"], "properties": {"to": {"type": "string", "title": "action_input_mail_to"}, "subject": {"type": "string", "title": "action_input_mail_subject"}, "body": {"type": "string", "title": "action_input_mail_body"}}}, "uiSchema": {"to": {"ui:options": {"showTitle": false}}, "subject": {"ui:options": {"showTitle": false}}, "body": {"ui:options": {"showTitle": false}}}}',
  '{"schema": {"type": "object", "title": "action_send_mail_output", "properties": {}}, "uiSchema": {}}',
  '{"zh": {"action_send_mail_name": "发送邮件", "action_send_mail_desc": "通过 SMTP 发送邮件", "action_send_mail_input": "邮件配置", "action_send_mail_output": "发送结果", "action_input_mail_to": "收件人", "action_input_mail_subject": "主题", "action_input_mail_body": "正文"}, "en": {"action_send_mail_name": "Send Email", "action_send_mail_desc": "Send email via SMTP", "action_send_mail_input": "Email Config", "action_send_mail_output": "Result", "action_input_mail_to": "Recipient", "action_input_mail_subject": "Subject", "action_input_mail_body": "Body"}}',
  0, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `service_id` = VALUES(`service_id`),
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `endpoint` = VALUES(`endpoint`),
  `input_json_schema` = VALUES(`input_json_schema`),
  `output_json_schema` = VALUES(`output_json_schema`),
  `i18n` = VALUES(`i18n`),
  `is_deleted` = VALUES(`is_deleted`),
  `updated_by` = VALUES(`updated_by`),
  `updated_at` = NOW();

