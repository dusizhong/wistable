/**
 * 管理员创建用户的请求对象。必填：邮箱、密码；选填：昵称、手机号、角色。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.ro;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Admin Create User Request")
public class UserAdminCreateRo {

    @Schema(description = "Email (required)")
    private String email;

    @Schema(description = "Password (required)")
    private String password;

    @Schema(description = "Nickname (optional)")
    private String nickName;

    @Schema(description = "Mobile phone (optional)")
    private String mobile;

    @Schema(description = "System role: user/admin")
    private String role;
}
