/**
 * 自定义订阅特性实现。读取空间站级别的用量限额覆盖配置，未配置的字段回退到 DefaultSubscriptionFeature 默认值。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.interfaces.billing.model;

import com.apitable.admin.entity.SpaceCapacityEntity;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.AdminNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.AiAgentNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.ApiCallNumsPerMonth;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.AutomationRunNumsPerMonth;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.CalendarViewNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.CapacitySize;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.FieldPermissionNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.FileNodeNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.FormNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.GalleryViewNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.GanttViewNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.KanbanViewNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.MirrorNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.NodePermissionNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.RowsPerSheet;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.Seat;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.TotalRows;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.ConsumeFeatures.WidgetNums;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.SolidFeatures.RemainRecordActivityDays;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.SolidFeatures.RemainTimeMachineDays;
import com.apitable.interfaces.billing.model.SubscriptionFeatures.SolidFeatures.RemainTrashDays;

/**
 * Custom subscription feature that overrides default limits
 * with per-space capacity configuration.
 */
public class CustomSubscriptionFeature extends DefaultSubscriptionFeature {

    private final SpaceCapacityEntity override;

    public CustomSubscriptionFeature(SpaceCapacityEntity override) {
        this.override = override;
    }

    @Override
    public Seat getSeat() {
        if (override.getMaxSeats() != null) {
            return new Seat(override.getMaxSeats());
        }
        return super.getSeat();
    }

    @Override
    public CapacitySize getCapacitySize() {
        if (override.getMaxCapacitySizeInBytes() != null) {
            return new CapacitySize(override.getMaxCapacitySizeInBytes());
        }
        return super.getCapacitySize();
    }

    @Override
    public FileNodeNums getFileNodeNums() {
        if (override.getMaxSheetNums() != null) {
            return new FileNodeNums(override.getMaxSheetNums());
        }
        return super.getFileNodeNums();
    }

    @Override
    public RowsPerSheet getRowsPerSheet() {
        if (override.getMaxRowsPerSheet() != null) {
            return new RowsPerSheet(override.getMaxRowsPerSheet());
        }
        return super.getRowsPerSheet();
    }

    @Override
    public TotalRows getTotalRows() {
        if (override.getMaxRowsInSpace() != null) {
            return new TotalRows(override.getMaxRowsInSpace());
        }
        return super.getTotalRows();
    }

    @Override
    public AdminNums getAdminNums() {
        if (override.getMaxAdminNums() != null) {
            return new AdminNums(override.getMaxAdminNums());
        }
        return super.getAdminNums();
    }

    @Override
    public ApiCallNumsPerMonth getApiCallNumsPerMonth() {
        if (override.getApiCallNumsPerMonth() != null) {
            return new ApiCallNumsPerMonth(override.getApiCallNumsPerMonth());
        }
        return super.getApiCallNumsPerMonth();
    }

    @Override
    public GalleryViewNums getGalleryViewNums() {
        if (override.getMaxGalleryViewsInSpace() != null) {
            return new GalleryViewNums(override.getMaxGalleryViewsInSpace());
        }
        return super.getGalleryViewNums();
    }

    @Override
    public KanbanViewNums getKanbanViewNums() {
        if (override.getMaxKanbanViewsInSpace() != null) {
            return new KanbanViewNums(override.getMaxKanbanViewsInSpace());
        }
        return super.getKanbanViewNums();
    }

    @Override
    public GanttViewNums getGanttViewNums() {
        if (override.getMaxGanttViewsInSpace() != null) {
            return new GanttViewNums(override.getMaxGanttViewsInSpace());
        }
        return super.getGanttViewNums();
    }

    @Override
    public CalendarViewNums getCalendarViewNums() {
        if (override.getMaxCalendarViewsInSpace() != null) {
            return new CalendarViewNums(override.getMaxCalendarViewsInSpace());
        }
        return super.getCalendarViewNums();
    }

    @Override
    public FormNums getFormNums() {
        if (override.getMaxFormViewsInSpace() != null) {
            return new FormNums(override.getMaxFormViewsInSpace());
        }
        return super.getFormNums();
    }

    @Override
    public MirrorNums getMirrorNums() {
        if (override.getMaxMirrorNums() != null) {
            return new MirrorNums(override.getMaxMirrorNums());
        }
        return super.getMirrorNums();
    }

    @Override
    public WidgetNums getWidgetNums() {
        if (override.getMaxWidgetNums() != null) {
            return new WidgetNums(override.getMaxWidgetNums());
        }
        return super.getWidgetNums();
    }

    @Override
    public FieldPermissionNums getFieldPermissionNums() {
        if (override.getFieldPermissionNums() != null) {
            return new FieldPermissionNums(override.getFieldPermissionNums());
        }
        return super.getFieldPermissionNums();
    }

    @Override
    public NodePermissionNums getNodePermissionNums() {
        if (override.getNodePermissionNums() != null) {
            return new NodePermissionNums(override.getNodePermissionNums());
        }
        return super.getNodePermissionNums();
    }

    @Override
    public RemainTrashDays getRemainTrashDays() {
        if (override.getMaxRemainTrashDays() != null) {
            return new RemainTrashDays(override.getMaxRemainTrashDays());
        }
        return super.getRemainTrashDays();
    }

    @Override
    public RemainTimeMachineDays getRemainTimeMachineDays() {
        if (override.getMaxRemainTimeMachineDays() != null) {
            return new RemainTimeMachineDays(override.getMaxRemainTimeMachineDays());
        }
        return super.getRemainTimeMachineDays();
    }

    @Override
    public RemainRecordActivityDays getRemainRecordActivityDays() {
        if (override.getMaxRemainRecordActivityDays() != null) {
            return new RemainRecordActivityDays(override.getMaxRemainRecordActivityDays());
        }
        return super.getRemainRecordActivityDays();
    }

    @Override
    public AiAgentNums getAiAgentNums() {
        if (override.getMaxAiAgentNums() != null) {
            return new AiAgentNums(override.getMaxAiAgentNums());
        }
        return super.getAiAgentNums();
    }

    @Override
    public AutomationRunNumsPerMonth getAutomationRunNumsPerMonth() {
        if (override.getAutomationRunNumsPerMonth() != null) {
            return new AutomationRunNumsPerMonth(override.getAutomationRunNumsPerMonth());
        }
        return super.getAutomationRunNumsPerMonth();
    }
}
