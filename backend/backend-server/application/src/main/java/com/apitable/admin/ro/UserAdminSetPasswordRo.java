/**
 * 管理员设置用户密码的请求对象。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.ro;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Admin Set Password Request")
public class UserAdminSetPasswordRo {

    @Schema(description = "New password")
    private String password;
}
