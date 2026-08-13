/**
 * 系统管理员通知管理接口。提供全局通知的增删改查与发送功能。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

package com.apitable.admin.controller;

import com.apitable.admin.ro.AdminNotificationRo;
import com.apitable.admin.service.IAdminNotificationService;
import com.apitable.admin.vo.AdminNotificationVo;
import com.apitable.core.support.ResponseData;
import com.apitable.shared.component.scanner.annotation.ApiResource;
import com.apitable.shared.component.scanner.annotation.DeleteResource;
import com.apitable.shared.component.scanner.annotation.GetResource;
import com.apitable.shared.component.scanner.annotation.PostResource;
import com.apitable.shared.context.SessionContext;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "System Admin - Notification Management")
@ApiResource(path = "/admin")
public class AdminNotificationController {

    @Resource
    private IAdminNotificationService adminNotificationService;

    @GetResource(path = "/notifications", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "List notification drafts and sent records")
    public ResponseData<IPage<AdminNotificationVo>> list(
        @RequestParam(defaultValue = "1") Integer pageNo,
        @RequestParam(defaultValue = "20") Integer pageSize,
        @RequestParam(required = false) String keyword) {
        Page<AdminNotificationVo> page = Page.of(pageNo, pageSize);
        IPage<AdminNotificationVo> result = adminNotificationService.pageList(page, keyword);
        return ResponseData.success(result);
    }

    @GetResource(path = "/notifications/{id}", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Get notification detail")
    public ResponseData<AdminNotificationVo> detail(@PathVariable Long id) {
        return ResponseData.success(adminNotificationService.getDetail(id));
    }

    @PostResource(path = "/notifications", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Create a notification draft")
    public ResponseData<AdminNotificationVo> create(@RequestBody AdminNotificationRo ro) {
        Long userId = SessionContext.getUserId();
        return ResponseData.success(adminNotificationService.create(userId, ro));
    }

    @PostResource(path = "/notifications/{id}", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Update a notification draft")
    public ResponseData<AdminNotificationVo> update(
        @PathVariable Long id,
        @RequestBody AdminNotificationRo ro) {
        return ResponseData.success(adminNotificationService.update(id, ro));
    }

    @DeleteResource(path = "/notifications/{id}", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Delete a notification draft")
    public ResponseData<Void> delete(@PathVariable Long id) {
        adminNotificationService.softDelete(id);
        return ResponseData.success();
    }

    @PostResource(path = "/notifications/{id}/send", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Send notification to all users")
    public ResponseData<Void> send(@PathVariable Long id) {
        adminNotificationService.send(id);
        return ResponseData.success();
    }
}
