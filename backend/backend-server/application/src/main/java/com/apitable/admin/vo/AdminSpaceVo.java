/**
 * 管理员空间列表响应 VO。包含空间基本信息、所有者信息和成员数量。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.vo;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@Schema(description = "Admin Space View")
public class AdminSpaceVo {

    @Schema(description = "Space ID")
    private String spaceId;

    @Schema(description = "Space name")
    private String name;

    @Schema(description = "Space logo")
    private String logo;

    @Schema(description = "Owner user ID")
    @JsonSerialize(using = ToStringSerializer.class)
    private Long ownerUserId;

    @Schema(description = "Owner nickname")
    private String ownerName;

    @Schema(description = "Owner email")
    private String ownerEmail;

    @Schema(description = "Member count")
    private Long memberCount;

    @Schema(description = "Sheet count")
    private Long sheetCount;

    @Schema(description = "Record count")
    private Long recordCount;

    @Schema(description = "Used capacity (bytes)")
    private Long capacityUsed;

    @Schema(description = "Total capacity (bytes)")
    private Long capacityTotal;

    @Schema(description = "Created at")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    private LocalDateTime createdAt;

    @Schema(description = "Updated at")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    private LocalDateTime updatedAt;

    @Schema(description = "Pre-deletion time")
    private LocalDateTime preDeletionTime;
}
