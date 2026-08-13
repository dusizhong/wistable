-- admin 账号 + 默认空间初始化

-- 管理员账号（密码: admin123）
INSERT IGNORE INTO `apitable_user` (`id`, `uuid`, `nick_name`, `code`, `mobile_phone`, `email`, `password`, `avatar`, `color`, `gender`, `remark`, `locale`, `time_zone`, `ding_open_id`, `ding_union_id`, `last_login_time`, `is_social_name_modified`, `is_paused`, `role`, `is_deleted`, `created_at`, `updated_at`) VALUES (2074750106454781953,'68c5beeb53574751a6f448d1fc798611','admin',NULL,NULL,'admin@qq.com','$2a$12$YaS0rqlm.YJjKqmwZJO1QOtVPyHX7Dzi9SaRWG3y1jdido5SmjO3S',NULL,1,'1',NULL,'zh-CN','Asia/Shanghai',NULL,NULL,'2026-07-09 02:06:02',2,0,'admin',0,'2026-07-08 06:59:07','2026-07-09 02:06:02');

-- 默认空间
INSERT IGNORE INTO `apitable_space` (`id`, `space_id`, `name`, `owner`, `creator`, `created_by`) VALUES (2080000000000000001, 'spcDefault01', '我的空间', 2080000000000000004, 2080000000000000004, 2074750106454781953);

-- 空间单元
INSERT IGNORE INTO `apitable_unit` (`id`, `unit_id`, `space_id`, `unit_type`, `unit_ref_id`) VALUES (2080000000000000003, 2080000000000000003, 'spcDefault01', 1, 2080000000000000001);

-- 成员单元
INSERT IGNORE INTO `apitable_unit` (`id`, `unit_id`, `space_id`, `unit_type`, `unit_ref_id`) VALUES (2080000000000000005, 2080000000000000005, 'spcDefault01', 3, 2080000000000000004);

-- 管理员加入空间
INSERT IGNORE INTO `apitable_unit_member` (`id`, `user_id`, `space_id`, `member_name`, `email`, `is_admin`) VALUES (2080000000000000004, 2074750106454781953, 'spcDefault01', 'admin', 'admin@qq.com', 1);

-- 空间根节点
INSERT IGNORE INTO `apitable_node` (`id`, `space_id`, `parent_id`, `node_id`, `node_name`, `type`, `creator`, `created_by`, `updated_by`) VALUES (2080000000000000002, 'spcDefault01', '0', 'fodAdminRoot', '我的空间', 0, 2074750106454781953, 2074750106454781953, 2074750106454781953);


