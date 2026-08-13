package com.apitable.admin.controller;

import com.apitable.admin.ro.FeedbackRo;
import com.apitable.admin.service.IFeedbackService;
import com.apitable.admin.vo.FeedbackVo;
import com.apitable.core.support.ResponseData;
import com.apitable.shared.component.scanner.annotation.ApiResource;
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
@Tag(name = "User Feedback")
@ApiResource
public class FeedbackController {

    @Resource
    private IFeedbackService feedbackService;

    @PostResource(path = "/feedback", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Submit user feedback")
    public ResponseData<FeedbackVo> submit(@RequestBody FeedbackRo ro) {
        Long userId = SessionContext.getUserId();
        return ResponseData.success(feedbackService.submit(userId, ro));
    }

    @GetResource(path = "/admin/feedbacks", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Admin: list feedbacks (paginated)")
    public ResponseData<IPage<FeedbackVo>> list(
        @RequestParam(defaultValue = "1") Integer pageNo,
        @RequestParam(defaultValue = "20") Integer pageSize,
        @RequestParam(required = false) String keyword) {
        Page<FeedbackVo> page = Page.of(pageNo, pageSize);
        IPage<FeedbackVo> result = feedbackService.pageList(page, keyword);
        return ResponseData.success(result);
    }

    @PostResource(path = "/admin/feedbacks/{id}/process", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Admin: mark feedback as processed")
    public ResponseData<FeedbackVo> process(@PathVariable Long id) {
        Long userId = SessionContext.getUserId();
        return ResponseData.success(feedbackService.process(id, userId));
    }
}
