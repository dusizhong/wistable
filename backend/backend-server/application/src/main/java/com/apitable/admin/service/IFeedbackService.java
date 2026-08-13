package com.apitable.admin.service;

import com.apitable.admin.ro.FeedbackRo;
import com.apitable.admin.vo.FeedbackVo;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

public interface IFeedbackService {

    FeedbackVo submit(Long userId, FeedbackRo ro);

    IPage<FeedbackVo> pageList(Page<FeedbackVo> page, String keyword);

    FeedbackVo process(Long feedbackId, Long adminUserId);
}
