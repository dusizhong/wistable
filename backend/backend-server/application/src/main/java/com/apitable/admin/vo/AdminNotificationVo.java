/**
 * 管理员通知列表/详情响应 VO。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

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
@Schema(description = "Admin Notification VO")
public class AdminNotificationVo {

    @Schema(description = "Notification ID", example = "1")
    private Long id;

    @Schema(description = "Notification title", example = "System maintenance notice")
    private String title;

    @Schema(description = "Notification body content", example = "Dear users...")
    private String content;

    @Schema(description = "Optional redirect URL", example = "/news/123")
    private String url;

    @Schema(description = "Sender admin user ID", example = "123456")
    private Long fromUser;

    @Schema(description = "Status: 0=Draft, 1=Sent", example = "0")
    private Integer status;

    @Schema(description = "Created time")
    private LocalDateTime createdAt;

    @Schema(description = "Updated time")
    private LocalDateTime updatedAt;
}
