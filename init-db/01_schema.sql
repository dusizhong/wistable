-- === SCHEMA ===
-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- ------------------------------------------------------

/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `apitable_api_statistics_daily`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_api_statistics_daily` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Space ID(link#xxxx_space#space_id)',
  `statistics_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'statistic time',
  `total_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Total calls',
  `success_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Number of successful requests',
  `failure_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Number of request failures',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE,
  KEY `idx_time` (`statistics_time` DESC) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Open Platform - Api Statistic Daily Table';

--
-- Table structure for table `apitable_api_statistics_monthly`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_api_statistics_monthly` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Space ID(link#xxxx_space#space_id)',
  `statistics_time` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'statistic time',
  `total_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Total calls',
  `success_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Number of successful requests',
  `failure_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Number of request failures',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE,
  KEY `idx_time` (`statistics_time` DESC) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Open Platform - Api Statistic Monthly Table';

--
-- Table structure for table `apitable_api_usage`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_api_usage` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `user_id` bigint unsigned NOT NULL COMMENT 'User ID',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Space ID(link#xxxx_space#space_id)',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Datasheet ID(link#xxxx_datasheet#dst_id)',
  `req_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'API path, data behind the domain name, excluding query data',
  `req_method` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'API request mode 1 get 2 post 3 patch 4 put',
  `api_version` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Api version',
  `req_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Client IP',
  `req_detail` json NOT NULL COMMENT 'api call details, including ua, refer, etc',
  `res_detail` json NOT NULL COMMENT 'API call returns information, including code, message, etc',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_dst_id` (`dst_id`),
  KEY `idx_space_id` (`space_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Open Platform - Api Usage Table';

--
-- Table structure for table `apitable_asset`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_asset` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `checksum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Hash and MD5 summary of the whole file',
  `head_sum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Base64 of the first 32 bytes of the resource file',
  `bucket` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Bucket Tag',
  `bucket_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'Bucket name',
  `file_size` int NOT NULL COMMENT 'File size (unit: byte)',
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Cloud file storage path',
  `mime_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'MimeType',
  `extension_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'File extension',
  `preview` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Preview Token',
  `is_template` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Is it a template attachment(0:No,1:Yes)',
  `height` int DEFAULT NULL COMMENT 'Image Height',
  `width` int DEFAULT NULL COMMENT 'Image Width',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_checksum` (`checksum`) USING BTREE,
  KEY `k_file_url` (`file_url`(20)) COMMENT 'Attachment url index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Resource Table';

--
-- Table structure for table `apitable_asset_audit`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_asset_audit` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `asset_id` bigint NOT NULL COMMENT 'Resource ID(link#xxxx_asset#id)',
  `asset_file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Cloud File Storage Path',
  `asset_checksum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '[Redundancy]md5 Abstract',
  `audit_result_score` float(8,8) DEFAULT NULL COMMENT 'Audit result score',
  `audit_result_suggestion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Audit Result Suggestion, include:[“block”,”review”,”pass”]',
  `audit_scenes` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Audit Scenes,Currently supported:pul/terror/politician/ads',
  `auditor_openid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Auditor OpenId',
  `auditor_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Auditor Name',
  `is_audited` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Is Audited(0:No, 1:Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_digest` (`asset_checksum`) USING BTREE,
  KEY `idx_file_url` (`asset_file_url`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Resource Audit Table';

--
-- Table structure for table `apitable_audit_invite_record`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_audit_invite_record` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '[Redundancy]Space ID(link#xxxx_space#space_id)',
  `inviter` bigint NOT NULL COMMENT 'Inviter Member ID(link#xxxx_unit_member#id)',
  `accepter` bigint NOT NULL COMMENT 'Invitee Member ID(link#xxxx_unit_member#id)',
  `type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Invited Type (0: Email Invitation; 1: File Import; 2: Link Invitation)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Invitation Record Audit Table';

--
-- Table structure for table `apitable_audit_upload_parse_record`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_audit_upload_parse_record` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Space ID',
  `file_save_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'File save relative path',
  `row_size` int DEFAULT NULL COMMENT 'Number of file lines',
  `success_count` int DEFAULT NULL COMMENT 'Number of lines successfully parsed',
  `error_count` int DEFAULT NULL COMMENT 'Number of lines failed to parse',
  `error_msg` json DEFAULT NULL COMMENT 'Resolution failure details',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Address Book Upload Analysis Audit Table';

--
-- Table structure for table `apitable_automation_action`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_automation_action` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `robot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Robot ID (link#xxxx_automation_robot#robot_id)',
  `action_type_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Action Type ID (link#xxxx_automation_action_type#action_type_id)',
  `action_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Action ID',
  `prev_action_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Previous Action ID',
  `input` json DEFAULT NULL COMMENT 'Action Input data of the instance',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_action_id` (`action_id`) USING BTREE COMMENT 'Action unique code',
  KEY `idx_robot_id` (`robot_id`) USING BTREE COMMENT 'Robot ID Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Automation - Action Table';

--
-- Table structure for table `apitable_automation_action_type`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_automation_action_type` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `service_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Service ID (link#xxxx_automation_service#service_id)',
  `action_type_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom action prototype ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Name',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Description',
  `input_json_schema` json DEFAULT NULL COMMENT 'Input JSON normal form',
  `output_json_schema` json DEFAULT NULL COMMENT 'Output JSON normal form',
  `endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Call interface',
  `i18n` json DEFAULT NULL COMMENT 'Internationalized Language Pack',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_action_type_id` (`action_type_id`) USING BTREE COMMENT 'Unique code of action prototype'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Automation - Action Type Table';

--
-- Table structure for table `apitable_automation_robot`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_automation_robot` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `resource_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource ID(link#xxxx_node#node_id)',
  `robot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Robot ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Name',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Description',
  `props` json DEFAULT NULL COMMENT 'Option Properties',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Version',
  `is_active` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Is it active',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  `seq_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Request source request number',
  `x_service_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Service Provider Certification Token',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_robot_id` (`robot_id`) USING BTREE COMMENT 'Robot unique code',
  UNIQUE KEY `uk_seq_resource_id` (`seq_id`,`resource_id`) USING BTREE COMMENT 'Unique number of single table robot creation request',
  KEY `idx_resource_id` (`resource_id`) COMMENT 'Resource ID Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Automation - Robot Table';

--
-- Table structure for table `apitable_automation_run_history`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_automation_run_history` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `task_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Run Task ID',
  `robot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Robot ID',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '[Redundancy]ID of the space to which the current task robot belongs',
  `status` tinyint unsigned DEFAULT '0' COMMENT 'Running status (0: Running, 1: Success, 2: Failure)',
  `data` json DEFAULT NULL COMMENT 'Run Context Details',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_id` (`task_id`) USING BTREE COMMENT 'Unique code of running task',
  KEY `idx_robot_id` (`robot_id`) USING BTREE,
  KEY `uk_space_id_created_at` (`space_id`,`created_at`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Automation - Robot Run History Table';

--
-- Table structure for table `apitable_automation_service`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_automation_service` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `service_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Service ID',
  `slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Service readable unique identifier',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'service name',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Description',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Logo Address',
  `base_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Base URL Address',
  `i18n` json DEFAULT NULL COMMENT 'Internationalized Language Pack',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_service_id` (`service_id`) USING BTREE COMMENT 'Service unique code',
  UNIQUE KEY `uk_service_slug` (`slug`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Automation - Service Table';

--
-- Table structure for table `apitable_automation_trigger`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_automation_trigger` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `robot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Robot ID (link#xxxx_automation_robot#robot_id)',
  `trigger_type_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Trigger Type ID (link#xxxx_automation_trigger_type#trigger_type_id)',
  `trigger_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Trigger ID',
  `prev_trigger_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Previous Trigger ID',
  `resource_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Resource ID(link#xxxx_node#node_id)',
  `input` json DEFAULT NULL COMMENT 'Trigger Input data of the instance',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_trigger_id` (`trigger_id`) USING BTREE COMMENT 'Trigger unique code',
  KEY `idx_robot_id` (`robot_id`) USING BTREE,
  KEY `idx_resource_id` (`resource_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Automation - Trigger Table';

--
-- Table structure for table `apitable_automation_trigger_type`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_automation_trigger_type` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `service_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Service ID (link#xxxx_automation_service#service_id)',
  `trigger_type_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Trigger Prototype ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Name',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Description',
  `input_json_schema` json DEFAULT NULL COMMENT 'Input JSON normal form',
  `output_json_schema` json DEFAULT NULL COMMENT 'Output JSON normal form',
  `endpoint` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Trigger prototype endpoint',
  `i18n` json DEFAULT NULL COMMENT 'Internationalized Language Pack',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_trigger_type_id` (`trigger_type_id`) USING BTREE COMMENT 'Unique code of trigger prototype'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Automation - Trigger Type Table';

--
-- Table structure for table `apitable_client_release_version`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_client_release_version` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `version` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Version No',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Version Description',
  `publish_user` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Version Publish User',
  `html_content` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datasheet Template String',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_version` (`version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Client Release Version Table';

--
-- Table structure for table `apitable_code`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_code` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `type` tinyint unsigned NOT NULL COMMENT 'Type (0: official invitation code; 1: personal invitation code; 2: exchange code)',
  `activity_id` bigint DEFAULT NULL COMMENT 'Activity ID(link#xxxx_code_activity#id)',
  `ref_id` bigint DEFAULT NULL COMMENT 'Association ID(Third party member ID/User ID/Redemption template ID)',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'V Code',
  `available_times` int DEFAULT NULL COMMENT 'Total Available',
  `remain_times` int DEFAULT NULL COMMENT 'Remain Times',
  `limit_times` int DEFAULT NULL COMMENT 'Limit the number of uses per person',
  `expired_at` timestamp NULL DEFAULT NULL COMMENT 'Expired Time',
  `assign_user_id` bigint DEFAULT NULL COMMENT 'Assign User ID',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_code` (`code`) USING BTREE COMMENT 'V Code Unique Code',
  KEY `idx_ref_id` (`ref_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='V Code System - V Code Table';

--
-- Table structure for table `apitable_content_censor_report`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_content_censor_report` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'Whistleblower user ID(link#xxxx_user#id)',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Node ID',
  `report_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Report Reason',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Content Report Record Table';

--
-- Table structure for table `apitable_control`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_control` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID',
  `control_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Control Tag',
  `control_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Resource control type (0: workbench node ID, 1: data table field, 2: data table view)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  KEY `control_id_index` (`control_id`(18)) USING BTREE,
  KEY `k_space_id` (`space_id`) USING BTREE COMMENT 'Space ID Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Control Table';

--
-- Table structure for table `apitable_control_role`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_control_role` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `control_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Control Tag',
  `unit_id` bigint unsigned NOT NULL COMMENT 'Unit ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Role Code',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_control_unit_role` (`control_id`,`unit_id`,`role_code`) USING BTREE,
  KEY `k_unit_id` (`unit_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Control Role Table';

--
-- Table structure for table `apitable_control_setting`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_control_setting` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `control_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Control Tag',
  `props` json NOT NULL DEFAULT (_utf8mb4'{}') COMMENT 'Option parameters',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_control_id` (`control_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Control Setting Table';

--
-- Table structure for table `apitable_datasheet`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Custom ID',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Datasheet Node Id(link#xxxx_node#node_id)',
  `dst_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Name',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `creator` bigint DEFAULT NULL COMMENT 'Creator',
  `revision` bigint unsigned DEFAULT '0' COMMENT 'Version No',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dst_id` (`dst_id`) USING BTREE,
  KEY `IX_Space_Id` (`space_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Data Table';

--
-- Table structure for table `apitable_datasheet_cascader_field`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_cascader_field` (
  `id` bigint NOT NULL COMMENT 'id',
  `space_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'space id',
  `datasheet_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'datasheet id',
  `field_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'field id',
  `linked_record_data` json NOT NULL COMMENT 'the cascader source data',
  `linked_record_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'the record where data from',
  `created_by` bigint DEFAULT NULL COMMENT 'Created By',
  `updated_by` bigint DEFAULT NULL COMMENT 'Updated By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Created Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Updated Time',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_sdf_id` (`space_id`,`datasheet_id`,`field_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Datasheet - Cascader Field Snapshot Data';

--
-- Table structure for table `apitable_datasheet_changeset`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_changeset` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `message_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The unique ID of the changeset request, which is used to ensure the uniqueness of the changeset',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Datasheet ID',
  `member_id` bigint DEFAULT NULL COMMENT 'Action member ID(link#xxxx_organization_member#id)',
  `operations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Collection of operation actions',
  `revision` bigint unsigned DEFAULT '0' COMMENT 'Version No',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '1:Delete，0:Not Deleted',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dst_message_id` (`dst_id`,`message_id`) USING BTREE,
  UNIQUE KEY `uk_dst_revision` (`dst_id`,`revision`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Data Table Operation Changeset Collection Table';

--
-- Table structure for table `apitable_datasheet_changeset_source`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_changeset_source` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datasheet ID(link#xxxx_datasheet#dst_id)',
  `resource_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource ID',
  `message_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The unique ID of the changeset request, which is used to ensure the uniqueness of the resource changeset',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Data source ID',
  `source_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Data source type (0: user interface, 1: openapi, 2: relationship effect)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_dst_id` (`dst_id`) USING BTREE,
  KEY `idx_resource_id` (`resource_id`) USING BTREE,
  KEY `idx_message_id` (`message_id`(50)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Changeset Source Table';

--
-- Table structure for table `apitable_datasheet_meta`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_meta` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Number table custom ID(link#xxxx_datasheet#dst_id)',
  `meta_data` json DEFAULT NULL COMMENT 'Metadata',
  `revision` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Version No',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `IX_Dst_id` (`dst_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Data Table Metadata Table';

--
-- Table structure for table `apitable_datasheet_operation`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_operation` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `op_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Operation ID',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Datasheet ID(link#xxxx_datasheet#dst_id)',
  `action_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Operation name',
  `actions` json DEFAULT NULL COMMENT 'Collection of operations',
  `type` tinyint unsigned DEFAULT NULL COMMENT 'Type(1:JOT,2:COT)',
  `member_id` bigint DEFAULT NULL COMMENT 'Action member ID(link#xxxx_organization_member#id)',
  `revision` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Version No',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_op_id` (`op_id`) USING BTREE COMMENT 'Operation unique code'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - datasheet operation table';

--
-- Table structure for table `apitable_datasheet_record`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_record` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `record_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Operation ID',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Datasheet ID(link#xxxx_datasheet#dst_id)',
  `data` json DEFAULT NULL COMMENT 'Data recorded in one row (corresponding to each field)',
  `revision_history` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT 'The historical version number sorted is the revision of the original operation, and the array subscript is the revision of the current record',
  `revision` bigint unsigned DEFAULT '0' COMMENT 'Version No',
  `field_updated_info` json DEFAULT NULL COMMENT 'Field Update Information',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dsId_recordId` (`dst_id`,`record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Record Table';

--
-- Table structure for table `apitable_datasheet_record_alarm`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_record_alarm` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `alarm_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Alarm ID',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Space ID(link#space#space_id)',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Datasheet ID(link#datasheet#dst_id)',
  `resource_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Resource ID(node_id/..)',
  `record_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Record ID(link#datasheet_record#record_id)',
  `field_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Field ID',
  `alarm_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Alarm Time',
  `alarm_status` tinyint NOT NULL DEFAULT '0' COMMENT 'Status: 0 - default, 1 - processing, 2 - process succeeded, 3 - process failed',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_alarm_id` (`alarm_id`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE,
  KEY `idx_dst_rec_id` (`dst_id`,`record_id`) USING BTREE,
  KEY `idx_alarm_at` (`alarm_at`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Record Alarm Table';

--
-- Table structure for table `apitable_datasheet_record_archive`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_record_archive` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `dst_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datasheet ID(link#xxxx_datasheet#dst_id)',
  `record_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Data record ID(link#xxxx_datasheet_record#record_id)',
  `is_archived` tinyint unsigned DEFAULT '0' COMMENT 'Archive tag(0:no,1:yes)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT 'Delete tag(0:no,1:yes)',
  `archived_by` bigint DEFAULT NULL COMMENT 'Archive User',
  `archived_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Archive Time',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Update User',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Created Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Updated Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dst_id_record_id` (`dst_id`,`record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Record Archive';

--
-- Table structure for table `apitable_datasheet_record_comment`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_record_comment` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datasheet ID',
  `record_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Record ID',
  `comment_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'chengeset generated comment_id',
  `comment_msg` json NOT NULL COMMENT 'Comment rich text content',
  `revision` bigint unsigned DEFAULT '0' COMMENT 'Record version number',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT 'Delete tag (0: No, 1: Yes)',
  `unit_id` bigint DEFAULT NULL COMMENT 'Operation User Unit ID(link#xxxx_unit#id)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_dst_id` (`dst_id`) USING BTREE,
  KEY `idx_record_id` (`record_id`) USING BTREE,
  KEY `idx_comment_id` (`comment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Record Comment Table';

--
-- Table structure for table `apitable_datasheet_record_source`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_record_source` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datasheet ID(link#xxxx_datasheet#dst_id)',
  `record_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Data record ID(link#xxxx_datasheet_record#record_id)',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Source ID',
  `type` tinyint unsigned NOT NULL COMMENT 'Data source type(0:user_interface,1:openapi,2:relation_effect)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dst_rec_id` (`dst_id`,`record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Record Source Table';

--
-- Table structure for table `apitable_datasheet_record_subscription`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_record_subscription` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'datasheet id',
  `mirror_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mirror node ID',
  `record_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Data Record ID(link#xxxx_datasheet_record#record_id)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator (subscriber)',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_dst_id_created_by` (`dst_id`,`created_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Record Subscription Table';

--
-- Table structure for table `apitable_datasheet_tablebundle`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_tablebundle` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `space_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space Id',
  `dst_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datasheet ID',
  `tbd_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tablebundle ID',
  `tablebundle_url` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tablebundle file s3 url',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tablebundle name',
  `type` int DEFAULT NULL COMMENT 'tablebundle type，0: template 1: snapshot',
  `status_code` int DEFAULT NULL COMMENT 'tablebundle status，0: generation tablebundle initiation 1:generation tablebundle complete 2: tablebundle deleted',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Created Time',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT 'Deleted Time',
  `expired_at` bigint DEFAULT NULL COMMENT 'Expired Time',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `deleted_by` bigint DEFAULT NULL COMMENT 'Delete User',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag (0: No, 1: Yes)',
  `updated_by` bigint DEFAULT NULL COMMENT 'Updated User',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_tbd_id` (`tbd_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Datasheet-Tablebundle';

--
-- Table structure for table `apitable_datasheet_widget`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_datasheet_widget` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID',
  `dst_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datasheet ID(link#xxxx_datasheet#dst_id)',
  `widget_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Customized component ID',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Widget references source ID, such as mirror',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_widget_id` (`widget_id`) USING BTREE,
  KEY `k_dst_id` (`dst_id`) USING BTREE,
  KEY `k_space_id` (`space_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Datasheet Widget Table';

--
-- Table structure for table `apitable_developer`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_developer` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `user_id` bigint unsigned NOT NULL COMMENT 'User ID',
  `api_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique token of developer platform',
  `created_by` bigint unsigned NOT NULL COMMENT 'Creator',
  `updated_by` bigint unsigned NOT NULL COMMENT 'Last Updated By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user` (`user_id`),
  UNIQUE KEY `uk_api_key` (`api_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Open Platform - Developer Configuration Table';

--
-- Table structure for table `apitable_developer_applet`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_developer_applet` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Associated Workshop Space Id',
  `applet_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Similar to app IDs of other open platforms, globally unique',
  `applet_secret` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The secret key is generally semi hidden and can be reset',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_applet_id` (`applet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Open Platform -  Cloud Program Table';

--
-- Table structure for table `apitable_developer_asset`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_developer_asset` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'Space ID(link#xxxx_space#space_id)',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'Custom Node ID',
  `bucket_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'Bucket name',
  `type` tinyint unsigned NOT NULL COMMENT 'Type (0: widget)',
  `source_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Source file name, the file name of this upload',
  `asset_id` bigint DEFAULT NULL COMMENT 'Resource ID(link#xxxx_asset#id)',
  `asset_checksum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '[Redundancy]md5 Abstract',
  `file_size` int NOT NULL COMMENT '[Redundancy]File size (unit: byte)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  KEY `uk_space_node` (`space_id`,`node_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench-Develop Asset Table';

--
-- Table structure for table `apitable_embed_link`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_embed_link` (
  `id` bigint unsigned NOT NULL COMMENT 'primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'space id',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'node_id',
  `embed_link_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'unique embed link id',
  `props` json DEFAULT NULL COMMENT 'ui attribute',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'deleted (0:no,1:yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'last modified by',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'creation time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_embed_link_id` (`embed_link_id`) USING BTREE,
  KEY `idx_node_id` (`node_id`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='embed - embed link table';

--
-- Table structure for table `apitable_invitation`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_invitation` (
  `id` bigint NOT NULL COMMENT 'primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'space id',
  `team_id` bigint NOT NULL COMMENT 'team id',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'node id',
  `creator` bigint NOT NULL COMMENT 'the creator member id',
  `invite_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'invite token',
  `invite_num` int unsigned DEFAULT '0' COMMENT 'number of successful invitees',
  `status` tinyint unsigned DEFAULT '1' COMMENT 'link status(0:inactivated, 1:activation)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'delete marker(0:false,1:true)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'creation time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_invite_token` (`invite_token`) USING BTREE COMMENT 'unique token',
  KEY `idx_creator` (`creator`) USING BTREE,
  KEY `idx_space_node_id` (`space_id`,`node_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='workbench-invitation table';

--
-- Table structure for table `apitable_labs_applicant`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_labs_applicant` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `applicant_type` tinyint unsigned NOT NULL COMMENT 'Applicant Type(0:user_feature, 1:space_feature)',
  `applicant` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Applicant Id, which can be space Id or user Id',
  `feature_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Feature Key',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint NOT NULL COMMENT 'Application Creator',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Labs Applicant Table';

--
-- Table structure for table `apitable_labs_features`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_labs_features` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `feature_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique identification of laboratory function',
  `feature_scope` tinyint NOT NULL COMMENT 'Labs Features Category (user: user level, space: space level)',
  `type` tinyint NOT NULL COMMENT 'Type of laboratory function (static: no operation, review: can be applied, normal: can be switched on and off normally)',
  `url` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Address of experimental function application form',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Labs Features Table';

--
-- Table structure for table `apitable_marketplace_product`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_marketplace_product` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Product Name',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Product Introduction',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Open Platform - Product Table';

--
-- Table structure for table `apitable_marketplace_sku`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_marketplace_sku` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `type` tinyint unsigned NOT NULL COMMENT '0:Template, 1:Applet',
  `type_id` bigint DEFAULT NULL COMMENT 'The associated number of the correspond type',
  `product_id` bigint DEFAULT NULL COMMENT 'The associated number of the correspond SPU (Product)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Open Platform - SKU Table';

--
-- Table structure for table `apitable_node`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `unit_id` bigint DEFAULT '0' COMMENT 'unit primary Key',
  `parent_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Parent Node Id',
  `pre_node_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID of the previous node under the same level',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Node ID',
  `node_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Node Name',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Node Icon',
  `type` tinyint unsigned NOT NULL COMMENT 'Type (0:Root node,1:Folder,2:Datasheet)',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Cover Draw TOKEN',
  `is_template` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Is Template (0: No, 1: Yes)',
  `extra` json DEFAULT NULL COMMENT 'Other information',
  `creator` bigint DEFAULT NULL COMMENT 'Creator',
  `deleted_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'deleted path',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  `is_rubbish` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Recycle Bin Tag (0: No, 1: Yes)',
  `is_banned` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Banned or not (0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_node_id` (`node_id`) USING BTREE COMMENT 'Node unique code',
  KEY `IX_Parent_id` (`parent_id`),
  KEY `IX_Pre_node_id` (`pre_node_id`),
  KEY `idx_space_id` (`space_id`) USING BTREE,
  KEY `idx_unit_id` (`unit_id`) USING BTREE COMMENT 'unit id index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench -  Node Table';

--
-- Table structure for table `apitable_node_desc`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_desc` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Node ID',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Node Description',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_node_id` (`node_id`) USING BTREE COMMENT 'Node Unique Code'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Description Table';

--
-- Table structure for table `apitable_node_favorite`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_favorite` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `member_id` bigint NOT NULL COMMENT 'Member ID(link#xxxx_unit_member#id)',
  `pre_node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Predecessor Node ID',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Node ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_member_node_id` (`member_id`,`node_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Favorite Table';

--
-- Table structure for table `apitable_node_permission`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_permission` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Node ID',
  `unit_id` bigint unsigned NOT NULL COMMENT 'Org Unit ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Node Role Code',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_node_unit_role` (`node_id`,`unit_id`,`role_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Role Permission Setting Table';

--
-- Table structure for table `apitable_node_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_rel` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `main_node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Master node ID',
  `rel_node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Associated node ID',
  `extra` json DEFAULT NULL COMMENT 'Other information',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_main_node_id` (`main_node_id`) COMMENT 'Primary Node Index',
  KEY `k_rel_node_id` (`rel_node_id`) COMMENT 'Associated Node Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Relation Table';

--
-- Table structure for table `apitable_node_resource`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_resource` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `resource_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Code',
  `resource_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Name',
  `resource_type` tinyint NOT NULL DEFAULT '0' COMMENT 'Resource Type（0:Node,1:View,2:Field,3:Record）',
  `resource_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Description',
  `field_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Field Name',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_resource_code` (`resource_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Resource Table';

--
-- Table structure for table `apitable_node_role`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_role` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `role_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Role Code',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Role Name',
  `role_level` int NOT NULL DEFAULT '1' COMMENT 'Priority, the smaller the priority, the higher the priority',
  `role_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Role Description',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_rule_code` (`role_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Role Table';

--
-- Table structure for table `apitable_node_role_resource_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_role_resource_rel` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Node Role Code',
  `resource_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Node resource code',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_role_code` (`role_code`) USING BTREE,
  KEY `k_resource_code` (`resource_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Role Resource Association Table';

--
-- Table structure for table `apitable_node_share_operate`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_share_operate` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `node_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Share Node ID',
  `operate_event` tinyint unsigned NOT NULL COMMENT 'Operation event type (0: open share, 1: close share, 2: open transfer, 3: close transfer, 4: refresh link)',
  `operator` bigint NOT NULL COMMENT 'Operator',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Share Setting Operation Record Table';

--
-- Table structure for table `apitable_node_share_setting`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_share_setting` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `node_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Node ID',
  `view_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Share View ID',
  `share_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Share unique ID',
  `is_enabled` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Shareable status (0: off, 1: on)',
  `allow_save` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Allow others to transfer (0: No, 1: Yes)',
  `allow_edit` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Allow others to edit (0: No, 1: Yes)',
  `props` json DEFAULT NULL COMMENT 'Share Option Properties',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_node_view_id` (`node_id`,`view_id`) USING BTREE,
  KEY `idx_share_id` (`share_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench Node Share Setting Table';

--
-- Table structure for table `apitable_node_visit_record`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_node_visit_record` (
  `id` bigint NOT NULL,
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_id` bigint NOT NULL,
  `node_type` tinyint unsigned NOT NULL,
  `node_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE,
  KEY `idx_member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Node Visit Record';

--
-- Table structure for table `apitable_player_activity`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_player_activity` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `user_id` bigint NOT NULL COMMENT 'User ID(link#xxxx_user#id)',
  `actions` json DEFAULT NULL COMMENT 'Action Set',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System - Activity Table';

--
-- Table structure for table `apitable_player_notification`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_player_notification` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Space ID',
  `from_user` bigint NOT NULL DEFAULT '0' COMMENT 'Send user,this is system user if 0',
  `to_user` bigint NOT NULL COMMENT 'Receive User',
  `node_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Node ID(Redundant Field)',
  `template_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Notification Template ID',
  `notify_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Notification Type',
  `notify_body` json DEFAULT NULL COMMENT 'Notification Message Body',
  `is_read` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Read or not (0: No, 1: Yes)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_type` (`to_user`,`notify_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Notification Center - Notification Record Table';

--
-- Table structure for table `apitable_admin_notification`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_admin_notification` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Notification Title',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Notification Body',
  `url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Optional Redirect URL',
  `from_user` bigint NOT NULL COMMENT 'Sender Admin User ID',
  `status` tinyint unsigned NOT NULL DEFAULT 0 COMMENT 'Status (0: Draft, 1: Sent)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT 0 COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_title` (`title`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Admin - Global Notification Record Table';

--
-- Table structure for table `apitable_user_feedback`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_user_feedback` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `nick_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '反馈人昵称',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '反馈人邮箱',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '反馈内容',
  `status` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '状态 (0: 未处理, 1: 已处理)',
  `processed_at` timestamp NULL DEFAULT NULL COMMENT '处理时间',
  `processed_by` bigint DEFAULT NULL COMMENT '处理人用户ID',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '删除标记 (0: 否, 1: 是)',
  `created_by` bigint DEFAULT NULL COMMENT '提交人用户ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '反馈时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_email` (`email`) USING BTREE,
  KEY `idx_created_by` (`created_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户反馈记录表';

--
-- Table structure for table `apitable_resource_changeset`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_resource_changeset` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `resource_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource ID(node_id/widget_id/..)',
  `resource_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Resource type (0: number table; 1: collection table; 2: dashboard; 3: component)',
  `message_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The unique ID of the changeset request, which is used to ensure the uniqueness of the changeset',
  `operations` json DEFAULT NULL COMMENT 'Collection of operation actions',
  `revision` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Version',
  `source_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Data source type (0: default)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_rsc_msg_id` (`resource_id`,`message_id`) USING BTREE,
  UNIQUE KEY `uk_rsc_rvs` (`resource_id`,`revision`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Resource Changeset Table';

--
-- Table structure for table `apitable_resource_meta`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_resource_meta` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `resource_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource ID(node_id/..)',
  `resource_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Resource type (0: number table; 1: collection table; 2: dashboard; 3: component)',
  `meta_data` json DEFAULT NULL COMMENT 'Meta Data',
  `revision` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Version',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uk_resource_id` (`resource_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Resource Meta Table';

--
-- Table structure for table `apitable_space`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space unique identifier character',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space Name',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Space Icon',
  `level` bigint DEFAULT NULL COMMENT 'Space Level',
  `props` json NOT NULL DEFAULT (_utf8mb4'{}') COMMENT 'Option properties',
  `pre_deletion_time` timestamp NULL DEFAULT NULL COMMENT 'Pre Delete Time',
  `is_invite` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Whether all members can invite members(0:No,1:Yes)',
  `is_forbid` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Do you want to prohibit all employees from export table(0:No,1:Yes)',
  `allow_apply` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Allow others to apply to join the space station (0: No, 1: Yes)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete tag(0:No,1:Yes)',
  `owner` bigint DEFAULT NULL COMMENT 'Owner',
  `creator` bigint DEFAULT NULL COMMENT 'Creator',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_space_id` (`space_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workspace Table';

--
-- Table structure for table `apitable_space_apply`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_apply` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `status` tinyint unsigned DEFAULT '0' COMMENT 'Status (0: To be approved; 1: Agree; 2: Reject; 3: Invalid)',
  `failure_reason` tinyint unsigned DEFAULT NULL COMMENT 'Failure reason (0: mailbox invitation; 1: address book import; 2: invitation link)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Work Space - Space Apply Table';

--
-- Table structure for table `apitable_space_asset`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_asset` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Datasheet Node Id(link#xxxx_node#node_id)',
  `asset_id` bigint DEFAULT NULL COMMENT 'Resource ID(link#xxxx_asset#id)',
  `asset_checksum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '[Redundancy]md5 Abstract',
  `cite` int DEFAULT '1' COMMENT 'Number of references',
  `type` tinyint unsigned NOT NULL COMMENT 'Type (0: user profile 1: space logo2: data table Annex 3: thumbnail 4: node description)',
  `source_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Source file name, the file name of this upload',
  `file_size` int NOT NULL COMMENT '[Redundancy]File Size(Unit: byte)',
  `is_template` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '[Redundant] Whether it is a template attachment (0: No, 1: Yes)',
  `height` int DEFAULT NULL COMMENT 'Image Height',
  `width` int DEFAULT NULL COMMENT 'Image Width',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0:No,1:Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_node_asset_id` (`node_id`,`asset_id`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE,
  KEY `idx_digest` (`asset_checksum`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Attachment Table';

--
-- Table structure for table `apitable_space_invite_link`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_invite_link` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `team_id` bigint NOT NULL COMMENT 'Department ID(link#xxxx_unit_team#id)',
  `creator` bigint NOT NULL COMMENT 'Creator Member ID(link#xxxx_unit_member#id)',
  `invite_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Invitation token code',
  `invite_num` int unsigned DEFAULT '0' COMMENT 'Number of successful invitees',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0:No, 1:Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `invite_token` (`invite_token`) USING BTREE COMMENT 'Uniqueness Token',
  UNIQUE KEY `uk_team_creator_id` (`team_id`,`creator`) USING BTREE,
  KEY `idx_space_id` (`space_id`) USING BTREE,
  KEY `idx_creator` (`creator`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Invitation Link Table';

--
-- Table structure for table `apitable_space_invite_record`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_invite_record` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `invite_member_id` bigint DEFAULT NULL COMMENT 'Inviter Member ID',
  `invite_space_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Invitation Space ID',
  `invite_space_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Invite Space Name',
  `invite_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Invite Email',
  `invite_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique token ID of invitation link',
  `invite_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Invite Link',
  `send_status` tinyint unsigned DEFAULT '0' COMMENT 'Mail send status(0:Fail,1:Success)',
  `status_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Status Description',
  `is_expired` tinyint unsigned DEFAULT '0' COMMENT 'Is it invalid(0:No,1:Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `invite_token` (`invite_token`) COMMENT 'Uniqueness token',
  KEY `idx_space_id` (`invite_space_id`) USING BTREE,
  KEY `idx_email` (`invite_email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Invitation Record Table';

--
-- Table structure for table `apitable_space_member_role_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_member_role_rel` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID',
  `member_id` bigint unsigned NOT NULL COMMENT 'Member ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Role Code',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_member_id` (`member_id`) USING BTREE,
  KEY `k_role_code` (`role_code`) USING BTREE,
  KEY `k_space_id` (`space_id`) COMMENT 'Space ID Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Role Permission Association Table';

--
-- Table structure for table `apitable_space_menu`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_menu` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `parent_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Parent Code',
  `menu_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Menu Code',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Menu Name',
  `menu_url` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Menu Relative Path',
  `sequence` int unsigned DEFAULT '1' COMMENT 'Sort',
  `is_enabled` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Enable(0:No,1:Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_menu_code` (`menu_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Workspace - Menu Table';

--
-- Table structure for table `apitable_space_menu_resource_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_menu_resource_rel` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `menu_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Menu Code',
  `resource_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Code',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_menu_code` (`menu_code`) USING BTREE,
  KEY `k_resource_code` (`resource_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Menu Resource Association Table';

--
-- Table structure for table `apitable_space_resource`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_resource` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `group_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Group Code',
  `resource_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Code',
  `resource_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Name',
  `resource_url` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Resource URL',
  `resource_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Describe',
  `assignable` tinyint unsigned DEFAULT '1' COMMENT 'Is it assignable(0:No,1:Yes)',
  `is_enabled` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'State(0:Disable,1:Enable)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_resource_code` (`resource_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Permission Resource Table';

--
-- Table structure for table `apitable_space_resource_group`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_resource_group` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `group_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Group Code',
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Group Name',
  `group_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Group Description',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Permission Resource Group Table';

--
-- Table structure for table `apitable_space_role`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_role` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Code',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name',
  `role_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Description',
  `is_enabled` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'State(0:Disable,1:Enable)',
  `creator` bigint DEFAULT NULL COMMENT 'Creator ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_role_code` (`role_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Role Table';

--
-- Table structure for table `apitable_space_role_resource_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_role_resource_rel` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary key',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Role Code',
  `resource_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Resource Code',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_role_code` (`role_code`) USING BTREE,
  KEY `k_resource_code` (`resource_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Role Permission Resource Association Table';

--
-- Table structure for table `apitable_system_config`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_system_config` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Type (0: boot configuration; 1: popular recommendation of template center)',
  `i18n_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'i18n key',
  `config_map` json NOT NULL DEFAULT (_utf8mb4'{}') COMMENT 'Configuration value',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint NOT NULL COMMENT 'Creator',
  `updated_by` bigint NOT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='System Config Table';

--
-- Table structure for table `apitable_template`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_template` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `template_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Template ID',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The essence of a template is to map a static node and its data',
  `type` tinyint unsigned NOT NULL COMMENT 'Template Type(0:PreInstall Official pre installation,1:Space User Space,2:Marketplace release to the market, part of Sku)',
  `type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Correspond Type Identification(Official pre installation/Space Code/SKU)',
  `category_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Category Code',
  `category_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Category Name',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Template Name',
  `used_times` int unsigned NOT NULL DEFAULT '0' COMMENT 'Use Number',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_template_id` (`template_id`) USING BTREE COMMENT 'Template Unique Code',
  KEY `idx_type_id` (`type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Template Center - Template Table';

--
-- Table structure for table `apitable_template_album`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_template_album` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `album_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Template Album Custom ID',
  `i18n_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'zh_CN' COMMENT 'I18n Key Name',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Template Album Name',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Template Album Cover Token(The Relative Path of Asset)',
  `description` varchar(511) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Template Album Description',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Template Album Content',
  `author_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Author Name',
  `author_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Author Logo Token(The Relative Path of Asset)',
  `author_desc` varchar(511) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Author Description',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Marker(0: no, 1: yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator User ID',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Modified User ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modified Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_album_id` (`album_id`) USING BTREE,
  KEY `idx_album_name` (`name`(30)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Template Center - Template Album Table';

--
-- Table structure for table `apitable_template_album_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_template_album_rel` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `album_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Template Album Custom ID',
  `type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Relate Type(0: template category, 1: template, 2: template tag)',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Relate Object Custom ID(0: category_code, 1: template_id, 2: tag_code)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_album_id` (`album_id`) USING BTREE,
  KEY `idx_relate_id` (`relate_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Template Center - Template Album Relation Table';

--
-- Table structure for table `apitable_template_property`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_template_property` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `property_type` tinyint unsigned NOT NULL COMMENT 'Type (0: classification, 1: label)',
  `property_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Attribute Name',
  `property_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Properties Code',
  `i18n_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'zh_CN' COMMENT 'i18n key',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  KEY `idx_property_code` (`property_code`) USING BTREE,
  KEY `idx_property_name` (`property_name`(30)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Template Center - Template Property Table';

--
-- Table structure for table `apitable_template_property_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_template_property_rel` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `template_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Custom Template ID',
  `property_id` bigint DEFAULT NULL COMMENT 'Property ID(link#xxxx_template_property#id)',
  `property_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Property Code',
  `property_order` tinyint unsigned DEFAULT NULL COMMENT 'Attribute Order',
  PRIMARY KEY (`id`),
  KEY `idx_template_id` (`template_id`) USING BTREE,
  KEY `idx_property_code` (`property_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Template Center - Template Property Rel Table';

--
-- Table structure for table `apitable_unit`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `unit_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'unit show id',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `unit_type` tinyint unsigned NOT NULL COMMENT 'Type (1: Department, 2: Label, 3: Member)',
  `unit_ref_id` bigint NOT NULL COMMENT 'Organization Unit Association ID',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_unit_ref_id` (`unit_ref_id`) USING BTREE COMMENT 'Unique ID of organization unit association',
  KEY `k_space_id` (`space_id`) COMMENT 'Space ID Index',
  KEY `idx_unit_id` (`unit_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Organization Structure - Organization Unit Table';

--
-- Table structure for table `apitable_unit_member`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_member` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `user_id` bigint DEFAULT NULL COMMENT 'User ID(link#xxxx_user#id)',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `member_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Member Name',
  `job_number` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Job Number',
  `position` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Position',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Phone Number',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email',
  `open_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Third party platform user ID',
  `status` tinyint unsigned DEFAULT '0' COMMENT 'The user space status (0: inactive; 1: active; 2: pre delete; 3: logout cool down period pre delete)',
  `name_modified` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Tag indicate whether the member name has been modified (0: No, 1: Yes)',
  `is_social_name_modified` tinyint(1) DEFAULT '2' COMMENT 'Whether the nickname has been modified as a third-party IM user. 0: No; 1: Yes; 2: Not an IM third-party user',
  `is_point` tinyint unsigned DEFAULT '0' COMMENT 'Whether there are small red dots (0: No, 1: Yes)',
  `is_active` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Activate or not (0: No, 1: Yes)',
  `is_admin` tinyint unsigned DEFAULT '0' COMMENT 'Administrator or not (0: No, 1: Yes)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_space_id` (`space_id`) COMMENT 'Space ID Index',
  KEY `idx_user_id` (`user_id`) USING BTREE COMMENT 'User ID Index',
  KEY `k_open_id` (`open_id`) USING BTREE COMMENT 'Third party platform identification index',
  KEY `idx_mobile` (`mobile`) USING BTREE COMMENT 'Mobile number index',
  KEY `idx_email` (`email`) USING BTREE COMMENT 'Email index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Organizational Structure - Member Table';

--
-- Table structure for table `apitable_unit_role`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_role` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `role_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Role Name',
  `position` int unsigned NOT NULL DEFAULT '2000' COMMENT 'Role sorting position (the default is 2000. For new roles, this value is the maximum space position multiplied by 2)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `create_by` bigint NOT NULL COMMENT 'Creator',
  `update_by` bigint DEFAULT NULL COMMENT 'Updater',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_space_id` (`space_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Unit Role Table';

--
-- Table structure for table `apitable_unit_role_member`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_role_member` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `role_id` bigint NOT NULL COMMENT 'Role ID(link#xxxx_unit_role#id)',
  `unit_ref_id` bigint NOT NULL COMMENT 'Member/Department ID(link#xxxx_unit_team#id | #xxxx_unit_member#id)',
  `unit_type` tinyint unsigned NOT NULL COMMENT '1: Department；3: Member',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_role_id` (`role_id`) USING BTREE,
  KEY `k_unit_ref_id` (`unit_ref_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Unit Role Member Table';

--
-- Table structure for table `apitable_unit_tag`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_tag` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `group_id` bigint DEFAULT NULL COMMENT 'Tag Group ID(link#xxxx_org_tag_group#id)',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tag Name',
  `sequence` int unsigned DEFAULT '1' COMMENT 'Sort in space (default starts from 1)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Organization Structure - Tag Table';

--
-- Table structure for table `apitable_unit_tag_group`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_tag_group` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `group_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tag Group Name',
  `sequence` int unsigned DEFAULT '1' COMMENT 'Sort in space (default starts from 1)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Organization Structure - Tag Group Table';

--
-- Table structure for table `apitable_unit_tag_member_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_tag_member_rel` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `tag_id` bigint NOT NULL COMMENT 'Tag ID(link#xxxx_org_tag#id)',
  `member_id` bigint NOT NULL COMMENT 'Member ID(link#xxxx_org_member#id)',
  `creator` bigint DEFAULT NULL COMMENT 'Creator(link#xxxx_user#id)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tag_id` (`tag_id`) USING BTREE,
  KEY `member_id` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Organization Structure - Tag Member Association Table';

--
-- Table structure for table `apitable_unit_team`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_team` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `parent_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Parent ID, 0 if it is root department',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Department Name',
  `team_level` int unsigned DEFAULT '1' COMMENT 'Level, starting from 1 by default',
  `sequence` int unsigned DEFAULT '1' COMMENT 'Sort (sibling starts from 1 by default)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT 'Delete Tag (0: No, 1: Yes)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_space_id` (`space_id`) COMMENT 'Space ID Index',
  KEY `k_parent_id` (`parent_id`) COMMENT 'Parent ID Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Organizational Structure - Department Table';

--
-- Table structure for table `apitable_unit_team_member_rel`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_unit_team_member_rel` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `team_id` bigint NOT NULL COMMENT 'Department ID',
  `member_id` bigint NOT NULL COMMENT 'Member ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `team_id_key` (`team_id`) USING BTREE,
  KEY `member_id_key` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Organization Structure - Department Member Association Table';

--
-- Table structure for table `apitable_user`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_user` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'User ID',
  `nick_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nick Name',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'code',
  `mobile_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Phone Number',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Password',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Avatar',
  `color` int DEFAULT NULL COMMENT 'default avatar color number',
  `gender` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT 'Gender',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Remark',
  `locale` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Language',
  `time_zone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'user time zone',
  `ding_open_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique identification in open application of DingTalk',
  `ding_union_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique identifier in the DingTalk developer enterprise',
  `last_login_time` timestamp NULL DEFAULT NULL COMMENT 'Last Login Time',
  `is_social_name_modified` tinyint(1) DEFAULT '2' COMMENT 'Whether the nickname has been modified as a third-party IM user. 0: No; 1: Yes; 2: Not an IM third-party user',
  `is_paused` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Whether to cancel the cool off period (1: Yes, 0: No)',
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user' COMMENT 'Role: user=regular user, admin=system admin',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (1: Yes, 0: No)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_phone` (`mobile_phone`) COMMENT 'Unique index of mobile phone number',
  UNIQUE KEY `uk_uuid` (`uuid`) USING BTREE,
  KEY `k_email` (`email`) COMMENT 'Email index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User Table';

--
-- Table structure for table `apitable_user_bind`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_user_bind` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `user_id` bigint NOT NULL COMMENT 'User ID',
  `external_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'External ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_user_id` (`user_id`) USING BTREE,
  KEY `k_external_key` (`external_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User Bind Tabl';

--
-- Table structure for table `apitable_user_history`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_user_history` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `user_id` bigint unsigned NOT NULL COMMENT 'User ID',
  `uuid` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'User ID',
  `nick_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nick Name',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Area Code',
  `mobile_phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mobile Phone',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Avatar',
  `locale` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Language',
  `user_status` tinyint NOT NULL COMMENT 'User account status (1: Apply for account cancellation, 2: Cancel account cancellation, 3: Complete account cancellation)',
  `created_by` bigint unsigned NOT NULL COMMENT 'Creator',
  `updated_by` bigint unsigned NOT NULL COMMENT 'Updater',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User History Table';

--
-- Table structure for table `apitable_user_link`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_user_link` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `user_id` bigint DEFAULT NULL COMMENT 'User ID(link#xxxx_user#id)',
  `open_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique identification within open applications',
  `union_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique ID in the developer enterprise',
  `nick_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Third party Nick Name',
  `type` tinyint unsigned DEFAULT '1' COMMENT 'Third party type (0: DingTalk; 1: WeChat; 2: QQ; 3: flying book)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_id` (`user_id`) USING BTREE,
  KEY `idx_open_id` (`open_id`,`type`) USING BTREE COMMENT 'openId index',
  KEY `k_union_id` (`union_id`) COMMENT 'Unique ID Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Basic - User Third Party Platform Association Table';

--
-- Table structure for table `apitable_widget`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_widget` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID',
  `node_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Node ID',
  `package_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Widget ID(link#xxxx_widget_package#package_id)',
  `widget_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Customized Widget ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Name',
  `storage` json DEFAULT NULL COMMENT 'Storage configuration',
  `revision` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Version',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_widget_id` (`widget_id`) USING BTREE,
  KEY `k_space_id` (`space_id`) USING BTREE,
  KEY `k_node_id` (`node_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Widget Table';

--
-- Table structure for table `apitable_widget_package`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_widget_package` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `package_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Widget ID',
  `i18n_name` json DEFAULT NULL COMMENT 'Internationalized widget name',
  `i18n_description` json DEFAULT NULL COMMENT 'Internationalization Widget Description',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Icon',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Cover draw TOKEN',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Status (0: under development, 1: banned, 2: to be published, 3: published, 4: off the shelf - global temporarily closed) 3, 4',
  `installed_num` int unsigned NOT NULL DEFAULT '0' COMMENT 'Number of installations',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Name - 【Discard Delete】',
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'English name - 【Discard Delete】',
  `version` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Version - 【Discard Delete】',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Description - 【Discard Delete】',
  `author_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Author Name',
  `author_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Author email',
  `author_icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Author icon TOKEN',
  `author_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Author website address',
  `package_type` tinyint NOT NULL COMMENT 'Widget package type (0: third party, 1: official)',
  `release_type` tinyint NOT NULL COMMENT '0: Publish to the component store in the space station, 1: Publish to the global application store (only allowed if the package_type is 0)',
  `widget_body` json DEFAULT NULL COMMENT 'Widget package extension information',
  `sandbox` tinyint(1) DEFAULT NULL COMMENT 'Whether the sandbox runs (0: No, 1: Yes)',
  `release_id` bigint DEFAULT NULL COMMENT 'The release version ID, the currently active version, can be empty. When it is empty, it is only displayed to Creator in the build store',
  `is_template` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Is template (0: No, 1: Yes)',
  `is_enabled` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Enable or not, only for global widgets (0: not enabled, 1: enabled)',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `owner` bigint DEFAULT NULL COMMENT 'Owner Id(link#xxxx_user#id)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  `install_env_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Installation environment code',
  `runtime_env_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Operate environment code',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_package_id` (`package_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Widget Package Table';

--
-- Table structure for table `apitable_widget_package_auth_space`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_widget_package_auth_space` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `package_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Package ID',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID(link#xxxx_space#space_id)',
  `type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Widget package authorization type (0: binding space - cannot be deleted, the same widget package can be jointly managed by the "development permission" administrator of the space; global widgets can also be used for upgrading and other needs; 1: authorized space - only space station widgets can be used for authorizing other spaces)',
  `widget_sort` int unsigned DEFAULT '10000' COMMENT 'Sequence number, space station components start from 10000',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench - Widget Package Auth Space Table';

--
-- Table structure for table `apitable_widget_package_release`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_widget_package_release` (
  `id` bigint unsigned NOT NULL COMMENT 'Primary Key',
  `release_sha` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Version Summary Unique ID(id+package_id+version generate)',
  `version` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Version number, unique under package id',
  `package_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Widget Package ID',
  `release_user_id` bigint DEFAULT NULL COMMENT 'User ID(link#xxxx_user#id)',
  `release_code_bundle` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Release Code Bundle',
  `source_code_bundle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Source Code Bundle',
  `secret_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Source code encryption key',
  `status` tinyint DEFAULT NULL COMMENT 'Status (0: to be approved, 1: approved, 2: rejected)',
  `release_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Release Version Description',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag(0: No, 1: Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Creator',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update By',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  `install_env_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Installation environment code',
  `runtime_env_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Operate environment code',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Workbench-Widget Package Release Table';

--
-- Dumping events for database 'apitable'
--

--
-- Dumping routines for database 'apitable'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


--
-- Table structure for table `apitable_space_capacity`
--

/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `apitable_space_capacity` (
  `id` bigint NOT NULL COMMENT 'Primary Key',
  `space_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Space ID',
  `max_seats` bigint DEFAULT NULL COMMENT 'Max members (NULL=default)',
  `max_capacity_size_in_bytes` bigint DEFAULT NULL COMMENT 'Max attachment capacity(bytes, NULL=default)',
  `max_sheet_nums` bigint DEFAULT NULL COMMENT 'Max sheet count',
  `max_rows_per_sheet` bigint DEFAULT NULL COMMENT 'Max rows per sheet',
  `max_rows_in_space` bigint DEFAULT NULL COMMENT 'Max total rows in space',
  `max_admin_nums` bigint DEFAULT NULL COMMENT 'Max admin count',
  `api_call_nums_per_month` bigint DEFAULT NULL COMMENT 'Monthly API call limit',
  `max_gallery_views_in_space` bigint DEFAULT NULL COMMENT 'Max gallery views',
  `max_kanban_views_in_space` bigint DEFAULT NULL COMMENT 'Max kanban views',
  `max_gantt_views_in_space` bigint DEFAULT NULL COMMENT 'Max gantt views',
  `max_calendar_views_in_space` bigint DEFAULT NULL COMMENT 'Max calendar views',
  `max_form_views_in_space` bigint DEFAULT NULL COMMENT 'Max form views',
  `max_mirror_nums` bigint DEFAULT NULL COMMENT 'Max mirror count',
  `max_widget_nums` bigint DEFAULT NULL COMMENT 'Max widget count',
  `field_permission_nums` bigint DEFAULT NULL COMMENT 'Max field permissions',
  `node_permission_nums` bigint DEFAULT NULL COMMENT 'Max node permissions',
  `max_remain_trash_days` bigint DEFAULT NULL COMMENT 'Trash retention days',
  `max_remain_time_machine_days` bigint DEFAULT NULL COMMENT 'Time machine retention days',
  `max_remain_record_activity_days` bigint DEFAULT NULL COMMENT 'Record activity retention days',
  `max_ai_agent_nums` bigint DEFAULT NULL COMMENT 'Max AI agent count',
  `automation_run_nums_per_month` bigint DEFAULT NULL COMMENT 'Monthly automation run limit',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Delete Tag (0:No, 1:Yes)',
  `created_by` bigint DEFAULT NULL COMMENT 'Create User',
  `updated_by` bigint DEFAULT NULL COMMENT 'Last Update User',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_space_id` (`space_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Space Custom Capacity Limits Table';

-- ============================================
