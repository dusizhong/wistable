/**
 * 管理员全局通知 Service 实现。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

package com.apitable.admin.service.impl;

import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.apitable.admin.entity.AdminNotificationEntity;
import com.apitable.admin.mapper.AdminNotificationMapper;
import com.apitable.admin.ro.AdminNotificationRo;
import com.apitable.admin.service.IAdminNotificationService;
import com.apitable.admin.vo.AdminNotificationVo;
import com.apitable.core.exception.BusinessException;
import com.apitable.player.ro.NotificationCreateRo;
import com.apitable.player.service.IPlayerNotificationService;
import com.apitable.shared.component.notification.NotificationTemplateId;
import com.apitable.shared.constants.NotificationConstants;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class AdminNotificationServiceImpl implements IAdminNotificationService {

    @Resource
    private AdminNotificationMapper adminNotificationMapper;

    @Resource
    private IPlayerNotificationService playerNotificationService;

    @Override
    public IPage<AdminNotificationVo> pageList(Page<AdminNotificationVo> page, String keyword) {
        Page<AdminNotificationEntity> entityPage = Page.of(page.getCurrent(), page.getSize());
        IPage<AdminNotificationEntity> entityResult =
            adminNotificationMapper.selectAdminNotificationPage(entityPage, keyword);
        return entityResult.convert(this::toVo);
    }

    @Override
    public AdminNotificationVo getDetail(Long id) {
        AdminNotificationEntity entity = adminNotificationMapper.selectById(id);
        if (entity == null) {
            throw new BusinessException("Notification not found");
        }
        return toVo(entity);
    }

    @Override
    public AdminNotificationVo create(Long fromUserId, AdminNotificationRo ro) {
        AdminNotificationEntity entity = AdminNotificationEntity.builder()
            .title(ro.getTitle())
            .content(ro.getContent())
            .url(ro.getUrl())
            .fromUser(fromUserId)
            .status(0)
            .build();
        adminNotificationMapper.insert(entity);
        return toVo(entity);
    }

    @Override
    public AdminNotificationVo update(Long id, AdminNotificationRo ro) {
        AdminNotificationEntity entity = adminNotificationMapper.selectById(id);
        if (entity == null) {
            throw new BusinessException("Notification not found");
        }
        if (entity.getStatus() != 0) {
            throw new BusinessException("Cannot edit a sent notification");
        }
        entity.setTitle(ro.getTitle());
        entity.setContent(ro.getContent());
        entity.setUrl(ro.getUrl());
        adminNotificationMapper.updateById(entity);
        return toVo(entity);
    }

    @Override
    public void softDelete(Long id) {
        AdminNotificationEntity entity = adminNotificationMapper.selectById(id);
        if (entity == null) {
            throw new BusinessException("Notification not found");
        }
        if (entity.getStatus() != 0) {
            throw new BusinessException("Cannot delete a sent notification");
        }
        adminNotificationMapper.deleteById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void send(Long id) {
        AdminNotificationEntity entity = adminNotificationMapper.selectById(id);
        if (entity == null) {
            throw new BusinessException("Notification not found");
        }
        if (entity.getStatus() != 0) {
            throw new BusinessException("Notification has already been sent");
        }

        JSONObject body = JSONUtil.createObj();
        JSONObject toast = JSONUtil.createObj();
        toast.putOnce("msg", entity.getContent());
        if (entity.getUrl() != null && !entity.getUrl().isEmpty()) {
            toast.putOnce("url", entity.getUrl());
        }
        body.putOnce(NotificationConstants.BODY_EXTRAS, JSONUtil.createObj().putOnce("toast", toast));

        NotificationCreateRo ro = new NotificationCreateRo();
        ro.setTemplateId(NotificationTemplateId.ADMIN_GLOBAL_NOTIFY.getValue());
        ro.setFromUserId("0");
        ro.setBody(body);

        playerNotificationService.batchCreateNotify(List.of(ro));

        entity.setStatus(1);
        adminNotificationMapper.updateById(entity);
        log.info("Admin notification sent successfully, id={}, title={}", id, entity.getTitle());
    }

    private AdminNotificationVo toVo(AdminNotificationEntity entity) {
        return AdminNotificationVo.builder()
            .id(entity.getId())
            .title(entity.getTitle())
            .content(entity.getContent())
            .url(entity.getUrl())
            .fromUser(entity.getFromUser())
            .status(entity.getStatus())
            .createdAt(entity.getCreatedAt())
            .updatedAt(entity.getUpdatedAt())
            .build();
    }
}
