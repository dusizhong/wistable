/**
 * 管理员全局通知 MyBatis-Plus Mapper 接口。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

package com.apitable.admin.mapper;

import com.apitable.admin.entity.AdminNotificationEntity;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

public interface AdminNotificationMapper extends BaseMapper<AdminNotificationEntity> {

    IPage<AdminNotificationEntity> selectAdminNotificationPage(
        Page<AdminNotificationEntity> page, @Param("keyword") String keyword);
}
