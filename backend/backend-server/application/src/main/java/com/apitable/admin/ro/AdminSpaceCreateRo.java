/**
 * 管理员创建空间的请求对象。必填：空间名称；选填：所有者用户 ID。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.ro;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
@Schema(description = "Admin Create Space Request")
public class AdminSpaceCreateRo {

    @Schema(description = "Space name", example = "My Workspace")
    @NotBlank
    @Size(min = 2, max = 100)
    private String name;

    @Schema(description = "Owner user ID (optional, defaults to current user)")
    private Long ownerUserId;

    @Schema(description = "Owner email (optional, alternative to ownerUserId)")
    private String ownerEmail;
}
