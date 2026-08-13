/**
 * 管理员修改用户信息的请求对象。可修改：昵称、邮箱、手机号、系统角色。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.ro;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Admin Update User Request")
public class UserAdminUpdateRo {

    @Schema(description = "Nickname")
    private String nickName;

    @Schema(description = "Email")
    private String email;

    @Schema(description = "Mobile phone")
    private String mobile;

    @Schema(description = "System role (user/admin)")
    private String role;
}
