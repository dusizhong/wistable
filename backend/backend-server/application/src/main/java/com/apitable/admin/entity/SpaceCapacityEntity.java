/**
 * 空间自定义用量限额实体，映射 apitable_space_capacity 表。存储每个空间独立的用量限额覆盖配置。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

@Data
@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode
@TableName(keepGlobalPrefix = true, value = "space_capacity")
public class SpaceCapacityEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;

    private String spaceId;

    private Long maxSeats;

    private Long maxCapacitySizeInBytes;

    private Long maxSheetNums;

    private Long maxRowsPerSheet;

    private Long maxRowsInSpace;

    private Long maxAdminNums;

    private Long apiCallNumsPerMonth;

    private Long maxGalleryViewsInSpace;

    private Long maxKanbanViewsInSpace;

    private Long maxGanttViewsInSpace;

    private Long maxCalendarViewsInSpace;

    private Long maxFormViewsInSpace;

    private Long maxMirrorNums;

    private Long maxWidgetNums;

    private Long fieldPermissionNums;

    private Long nodePermissionNums;

    private Long maxRemainTrashDays;

    private Long maxRemainTimeMachineDays;

    private Long maxRemainRecordActivityDays;

    private Long maxAiAgentNums;

    private Long automationRunNumsPerMonth;

    @TableLogic
    private Boolean isDeleted;

    private Long createdBy;

    private Long updatedBy;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
