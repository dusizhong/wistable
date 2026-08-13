package com.apitable.admin.service.impl;

import com.apitable.admin.entity.FeedbackEntity;
import com.apitable.admin.mapper.FeedbackMapper;
import com.apitable.admin.ro.FeedbackRo;
import com.apitable.admin.service.IFeedbackService;
import com.apitable.admin.vo.FeedbackVo;
import com.apitable.core.exception.BusinessException;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class FeedbackServiceImpl implements IFeedbackService {

    @Resource
    private FeedbackMapper feedbackMapper;

    @Override
    public FeedbackVo submit(Long userId, FeedbackRo ro) {
        FeedbackEntity entity = FeedbackEntity.builder()
            .nickName(ro.getNickName())
            .email(ro.getEmail())
            .content(ro.getContent())
            .status(0)
            .createdBy(userId)
            .build();
        feedbackMapper.insert(entity);
        return toVo(entity);
    }

    @Override
    public IPage<FeedbackVo> pageList(Page<FeedbackVo> page, String keyword) {
        Page<FeedbackEntity> entityPage = Page.of(page.getCurrent(), page.getSize());
        IPage<FeedbackEntity> entityResult =
            feedbackMapper.selectFeedbackPage(entityPage, keyword);
        return entityResult.convert(this::toVo);
    }

    @Override
    public FeedbackVo process(Long feedbackId, Long adminUserId) {
        FeedbackEntity entity = feedbackMapper.selectById(feedbackId);
        if (entity == null) {
            throw new BusinessException("Feedback not found");
        }
        if (entity.getStatus() != null && entity.getStatus() == 1) {
            throw new BusinessException("Feedback already processed");
        }
        entity.setStatus(1);
        entity.setProcessedBy(adminUserId);
        entity.setProcessedAt(LocalDateTime.now());
        feedbackMapper.updateById(entity);
        return toVo(entity);
    }

    private FeedbackVo toVo(FeedbackEntity entity) {
        return FeedbackVo.builder()
            .id(entity.getId())
            .nickName(entity.getNickName())
            .email(entity.getEmail())
            .content(entity.getContent())
            .status(entity.getStatus())
            .createdAt(entity.getCreatedAt())
            .processedAt(entity.getProcessedAt())
            .createdBy(entity.getCreatedBy())
            .build();
    }
}
