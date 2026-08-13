/**
 * 系统管理员空间管理接口。提供所有空间的增删改查，以及每个空间的自定义用量限额配置。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.controller;

import cn.hutool.core.util.StrUtil;
import com.apitable.admin.entity.SpaceCapacityEntity;
import com.apitable.admin.mapper.SpaceCapacityMapper;
import com.apitable.admin.ro.AdminSpaceCreateRo;
import com.apitable.admin.ro.SpaceCapacityConfigRo;
import com.apitable.admin.vo.AdminSpaceVo;
import com.apitable.admin.vo.SpaceCapacityConfigVo;
import com.apitable.core.support.ResponseData;
import com.apitable.core.util.ExceptionUtil;
import com.apitable.organization.mapper.MemberMapper;
import com.apitable.shared.cache.service.UserActiveSpaceCacheService;
import com.apitable.shared.cache.service.UserSpaceCacheService;
import com.apitable.shared.component.scanner.annotation.ApiResource;
import com.apitable.shared.component.scanner.annotation.DeleteResource;
import com.apitable.shared.component.scanner.annotation.GetResource;
import com.apitable.shared.component.scanner.annotation.PostResource;
import com.apitable.shared.context.SessionContext;
import com.apitable.shared.holder.UserHolder;
import com.apitable.space.mapper.SpaceMapper;
import com.apitable.space.ro.SpaceUpdateOpRo;
import com.apitable.space.service.ISpaceService;
import com.apitable.space.vo.CreateSpaceResultVo;
import com.apitable.user.entity.UserEntity;
import com.apitable.user.enums.UserException;
import com.apitable.user.service.IUserService;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "System Admin - Space Management")
@ApiResource(path = "/admin")
public class AdminSpaceController {

    @Resource
    private SpaceMapper spaceMapper;

    @Resource
    private SpaceCapacityMapper spaceCapacityMapper;

    @Resource
    private ISpaceService iSpaceService;

    @Resource
    private IUserService iUserService;

    @Resource
    private MemberMapper memberMapper;

    @Resource
    private UserSpaceCacheService userSpaceCacheService;

    @Resource
    private UserActiveSpaceCacheService userActiveSpaceCacheService;

    @GetResource(path = "/spaces", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "List all spaces", description = "Paginated space list with keyword search")
    public ResponseData<IPage<AdminSpaceVo>> listSpaces(
        @RequestParam(defaultValue = "1") Integer pageNo,
        @RequestParam(defaultValue = "20") Integer pageSize,
        @RequestParam(required = false) String keyword) {
        Page<AdminSpaceVo> page = Page.of(pageNo, pageSize);
        IPage<AdminSpaceVo> result = spaceMapper.selectAdminSpacePage(page, keyword);
        return ResponseData.success(result);
    }

    @PostResource(path = "/spaces", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Create space")
    public ResponseData<CreateSpaceResultVo> createSpace(@RequestBody AdminSpaceCreateRo ro) {
        Long userId = SessionContext.getUserId();
        UserEntity creator = iUserService.getById(userId);
        if (StrUtil.isNotBlank(ro.getOwnerEmail())) {
            creator = iUserService.getByEmail(ro.getOwnerEmail());
            ExceptionUtil.isNotNull(creator, UserException.USER_NOT_EXIST);
        } else if (ro.getOwnerUserId() != null && !ro.getOwnerUserId().equals(userId)) {
            creator = iUserService.getById(ro.getOwnerUserId());
            ExceptionUtil.isNotNull(creator, UserException.USER_NOT_EXIST);
        }
        com.apitable.space.model.Space space = iSpaceService.createSpace(creator, ro.getName());
        return ResponseData.success(CreateSpaceResultVo.builder().spaceId(space.getId()).build());
    }

    @PostResource(path = "/spaces/{spaceId}", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Update space")
    public ResponseData<Void> updateSpace(
        @PathVariable String spaceId,
        @RequestBody SpaceUpdateOpRo ro) {
        Long userId = UserHolder.get();
        iSpaceService.updateSpace(userId, spaceId, ro);
        return ResponseData.success();
    }

    @DeleteResource(path = "/spaces/{spaceId}", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Pre-delete space (admin)")
    public ResponseData<Void> deleteSpace(@PathVariable String spaceId) {
        Long userId = UserHolder.get();
        iSpaceService.preDeleteById(userId, spaceId);
        return ResponseData.success();
    }

    @GetResource(path = "/spaces/{spaceId}/capacity", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Get space capacity config")
    public ResponseData<SpaceCapacityConfigVo> getSpaceCapacity(@PathVariable String spaceId) {
        SpaceCapacityEntity entity = spaceCapacityMapper.selectBySpaceId(spaceId);
        if (entity == null) {
            return ResponseData.success(new SpaceCapacityConfigVo());
        }
        SpaceCapacityConfigVo vo = new SpaceCapacityConfigVo();
        BeanUtils.copyProperties(entity, vo);
        return ResponseData.success(vo);
    }

    @PostResource(path = "/spaces/{spaceId}/capacity", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Update space capacity config")
    public ResponseData<Void> updateSpaceCapacity(
        @PathVariable String spaceId,
        @RequestBody SpaceCapacityConfigRo ro) {
        Long userId = UserHolder.get();
        SpaceCapacityEntity entity = spaceCapacityMapper.selectBySpaceId(spaceId);
        boolean isNew = (entity == null);
        if (isNew) {
            entity = SpaceCapacityEntity.builder()
                .spaceId(spaceId)
                .createdBy(userId)
                .build();
        }
        entity.setUpdatedBy(userId);
        copyCapacityFields(ro, entity);
        if (isNew) {
            spaceCapacityMapper.insert(entity);
        } else {
            spaceCapacityMapper.updateById(entity);
        }
        return ResponseData.success();
    }

    private void copyCapacityFields(SpaceCapacityConfigRo ro, SpaceCapacityEntity entity) {
        entity.setMaxSeats(ro.getMaxSeats());
        entity.setMaxCapacitySizeInBytes(ro.getMaxCapacitySizeInBytes());
        entity.setMaxSheetNums(ro.getMaxSheetNums());
        entity.setMaxRowsPerSheet(ro.getMaxRowsPerSheet());
        entity.setMaxRowsInSpace(ro.getMaxRowsInSpace());
        entity.setMaxAdminNums(ro.getMaxAdminNums());
        entity.setApiCallNumsPerMonth(ro.getApiCallNumsPerMonth());
        entity.setMaxGalleryViewsInSpace(ro.getMaxGalleryViewsInSpace());
        entity.setMaxKanbanViewsInSpace(ro.getMaxKanbanViewsInSpace());
        entity.setMaxGanttViewsInSpace(ro.getMaxGanttViewsInSpace());
        entity.setMaxCalendarViewsInSpace(ro.getMaxCalendarViewsInSpace());
        entity.setMaxFormViewsInSpace(ro.getMaxFormViewsInSpace());
        entity.setMaxMirrorNums(ro.getMaxMirrorNums());
        entity.setMaxWidgetNums(ro.getMaxWidgetNums());
        entity.setFieldPermissionNums(ro.getFieldPermissionNums());
        entity.setNodePermissionNums(ro.getNodePermissionNums());
        entity.setMaxRemainTrashDays(ro.getMaxRemainTrashDays());
        entity.setMaxRemainTimeMachineDays(ro.getMaxRemainTimeMachineDays());
        entity.setMaxRemainRecordActivityDays(ro.getMaxRemainRecordActivityDays());
        entity.setMaxAiAgentNums(ro.getMaxAiAgentNums());
        entity.setAutomationRunNumsPerMonth(ro.getAutomationRunNumsPerMonth());
    }
}
