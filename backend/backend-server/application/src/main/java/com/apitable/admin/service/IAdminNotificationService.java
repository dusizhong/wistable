/**
 * 管理员全局通知 Service 接口。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

package com.apitable.admin.service;

import com.apitable.admin.ro.AdminNotificationRo;
import com.apitable.admin.vo.AdminNotificationVo;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

public interface IAdminNotificationService {

    IPage<AdminNotificationVo> pageList(Page<AdminNotificationVo> page, String keyword);

    AdminNotificationVo getDetail(Long id);

    AdminNotificationVo create(Long fromUserId, AdminNotificationRo ro);

    AdminNotificationVo update(Long id, AdminNotificationRo ro);

    void softDelete(Long id);

    void send(Long id);
}
