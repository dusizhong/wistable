/**
 * 管理员创建/编辑通知的请求对象。
 *
 * @author  系统管理员
 * @created 2026-07-30
 */

package com.apitable.admin.ro;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Admin Notification Create/Update Request")
public class AdminNotificationRo {

    @Schema(description = "Notification title (required)", example = "System maintenance notice")
    private String title;

    @Schema(description = "Notification body content (required)", example = "Dear users, the system will be under maintenance...")
    private String content;

    @Schema(description = "Optional redirect URL", example = "/news/123")
    private String url;
}
