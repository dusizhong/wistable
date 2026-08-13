package com.apitable.admin.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Feedback VO")
public class FeedbackVo {

    @Schema(description = "Feedback ID", example = "1")
    private Long id;

    @Schema(description = "Nickname", example = "Zhang San")
    private String nickName;

    @Schema(description = "Email", example = "zhangsan@example.com")
    private String email;

    @Schema(description = "Feedback content", example = "The search feature could be improved...")
    private String content;

    @Schema(description = "Status: 0=Pending, 1=Processed", example = "0")
    private Integer status;

    @Schema(description = "Feedback time")
    private LocalDateTime createdAt;

    @Schema(description = "Processed time")
    private LocalDateTime processedAt;

    @Schema(description = "Submitter user ID")
    private Long createdBy;
}
