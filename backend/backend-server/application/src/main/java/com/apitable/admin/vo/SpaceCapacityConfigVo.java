/**
 * 空间用量配置响应 VO。包含所有可配置的空间使用限额字段。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Space Capacity Config View")
public class SpaceCapacityConfigVo {

    @Schema(description = "Max members (NULL=unlimited)")
    private Long maxSeats;

    @Schema(description = "Max attachment capacity in bytes")
    private Long maxCapacitySizeInBytes;

    @Schema(description = "Max sheet count")
    private Long maxSheetNums;

    @Schema(description = "Max rows per sheet")
    private Long maxRowsPerSheet;

    @Schema(description = "Max total rows in space")
    private Long maxRowsInSpace;

    @Schema(description = "Max admin count")
    private Long maxAdminNums;

    @Schema(description = "Monthly API call limit")
    private Long apiCallNumsPerMonth;

    @Schema(description = "Max gallery views")
    private Long maxGalleryViewsInSpace;

    @Schema(description = "Max kanban views")
    private Long maxKanbanViewsInSpace;

    @Schema(description = "Max gantt views")
    private Long maxGanttViewsInSpace;

    @Schema(description = "Max calendar views")
    private Long maxCalendarViewsInSpace;

    @Schema(description = "Max form views")
    private Long maxFormViewsInSpace;

    @Schema(description = "Max mirror count")
    private Long maxMirrorNums;

    @Schema(description = "Max widget count")
    private Long maxWidgetNums;

    @Schema(description = "Max field permissions")
    private Long fieldPermissionNums;

    @Schema(description = "Max node permissions")
    private Long nodePermissionNums;

    @Schema(description = "Trash retention days")
    private Long maxRemainTrashDays;

    @Schema(description = "Time machine retention days")
    private Long maxRemainTimeMachineDays;

    @Schema(description = "Record activity retention days")
    private Long maxRemainRecordActivityDays;

    @Schema(description = "Max AI agent count")
    private Long maxAiAgentNums;

    @Schema(description = "Monthly automation run limit")
    private Long automationRunNumsPerMonth;
}
