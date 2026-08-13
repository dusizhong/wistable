package com.apitable.admin.ro;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Submit Feedback Request")
public class FeedbackRo {

    @Schema(description = "Feedback user nickname", example = "Zhang San")
    private String nickName;

    @Schema(description = "Feedback user email", example = "zhangsan@example.com")
    private String email;

    @Schema(description = "Feedback content (required)", example = "The search feature could be improved...")
    private String content;
}
