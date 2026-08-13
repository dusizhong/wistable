/**
 * 管理员用户列表响应 VO。包含用户基本信息、系统角色、账号状态和所属空间数量。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.vo;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@Schema(description = "Admin User View")
public class UserAdminVo {

    @Schema(description = "User ID")
    @JsonSerialize(using = ToStringSerializer.class)
    private Long userId;

    @Schema(description = "UUID")
    private String uuid;

    @Schema(description = "Nickname")
    private String nickName;

    @Schema(description = "Email")
    private String email;

    @Schema(description = "Mobile phone")
    private String mobile;

    @Schema(description = "Avatar")
    private String avatar;

    @Schema(description = "Avatar color")
    private Integer avatarColor;

    @Schema(description = "System role (user/admin)")
    private String role;

    @Schema(description = "Account paused status")
    private Boolean isPaused;

    @Schema(description = "Last login time")
    private LocalDateTime lastLoginTime;

    @Schema(description = "Registration time")
    private LocalDateTime signUpTime;

    @Schema(description = "Number of spaces joined")
    private Integer spaceCount;

    @Schema(description = "Update time")
    private LocalDateTime updatedAt;
}
