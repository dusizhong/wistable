/**
 * 系统管理员用户管理接口。提供所有用户的增删改查、角色分配、密码重置、账号启停等操作。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.controller;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.apitable.admin.ro.UserAdminCreateRo;
import com.apitable.admin.ro.UserAdminSetPasswordRo;
import com.apitable.admin.ro.UserAdminUpdateRo;
import com.apitable.admin.vo.UserAdminVo;
import com.apitable.shared.security.PasswordService;
import com.apitable.core.support.ResponseData;
import com.apitable.core.util.ExceptionUtil;
import com.apitable.organization.mapper.MemberMapper;
import com.apitable.shared.cache.service.LoginUserCacheService;
import com.apitable.shared.cache.service.UserSpaceCacheService;
import com.apitable.shared.cache.service.UserActiveSpaceCacheService;
import com.apitable.shared.component.scanner.annotation.ApiResource;
import com.apitable.shared.component.scanner.annotation.GetResource;
import com.apitable.shared.component.scanner.annotation.PostResource;
import com.apitable.shared.component.scanner.annotation.DeleteResource;
import com.apitable.shared.context.SessionContext;
import com.apitable.space.service.ISpaceService;
import com.apitable.user.entity.UserEntity;
import com.apitable.user.enums.UserException;
import com.apitable.user.mapper.UserMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "System Admin - User Management")
@ApiResource(path = "/admin")
public class AdminUserController {

    @Resource
    private UserMapper userMapper;

    @Resource
    private MemberMapper memberMapper;

    @Resource
    private LoginUserCacheService loginUserCacheService;

    @Resource
    private UserSpaceCacheService userSpaceCacheService;

    @Resource
    private UserActiveSpaceCacheService userActiveSpaceCacheService;

    @Resource
    private PasswordService passwordService;

    @Resource
    private ISpaceService iSpaceService;

    @GetResource(path = "/users", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "List users", description = "Paginated user list with keyword search")
    public ResponseData<IPage<UserAdminVo>> listUsers(
        @RequestParam(defaultValue = "1") Integer pageNo,
        @RequestParam(defaultValue = "20") Integer pageSize,
        @RequestParam(required = false) String keyword) {
        Page<UserAdminVo> page = Page.of(pageNo, pageSize);
        IPage<UserAdminVo> result = userMapper.selectUserPage(page, keyword);
        return ResponseData.success(result);
    }

    @PostResource(path = "/users/create", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Create user")
    public ResponseData<Void> createUser(@RequestBody UserAdminCreateRo ro) {
        if (StrUtil.isBlank(ro.getEmail()) || StrUtil.isBlank(ro.getPassword())) {
            throw new RuntimeException("Email and password are required");
        }
        UserEntity existing = userMapper.selectByEmail(ro.getEmail());
        if (existing != null) {
            throw new RuntimeException("Email already exists");
        }
        UserEntity user = UserEntity.builder()
            .uuid(IdUtil.fastSimpleUUID())
            .email(ro.getEmail())
            .password(passwordService.encode(ro.getPassword()))
            .nickName(StrUtil.isNotBlank(ro.getNickName()) ? ro.getNickName() : ro.getEmail())
            .mobilePhone(ro.getMobile())
            .role(StrUtil.isNotBlank(ro.getRole()) ? ro.getRole() : "user")
            .build();
        userMapper.insert(user);
        iSpaceService.createSpace(user, "我的空间");
        return ResponseData.success();
    }

    @PostResource(path = "/users/{userId}", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Update user")
    public ResponseData<Void> updateUser(
        @PathVariable Long userId,
        @RequestBody UserAdminUpdateRo ro) {
        UserEntity user = userMapper.selectById(userId);
        ExceptionUtil.isNotNull(user, UserException.USER_NOT_EXIST);
        if (ro.getRole() != null) {
            user.setRole(ro.getRole());
        }
        if (ro.getNickName() != null) {
            user.setNickName(ro.getNickName());
        }
        if (ro.getEmail() != null) {
            user.setEmail(ro.getEmail());
        }
        if (ro.getMobile() != null) {
            user.setMobilePhone(ro.getMobile());
        }
        userMapper.updateById(user);
        loginUserCacheService.delete(userId);
        return ResponseData.success();
    }

    @PostResource(path = "/users/{userId}/password", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Set user password")
    public ResponseData<Void> setUserPassword(
        @PathVariable Long userId,
        @RequestBody UserAdminSetPasswordRo ro) {
        if (StrUtil.isBlank(ro.getPassword())) {
            throw new RuntimeException("Password is required");
        }
        UserEntity user = userMapper.selectById(userId);
        ExceptionUtil.isNotNull(user, UserException.USER_NOT_EXIST);
        user.setPassword(passwordService.encode(ro.getPassword()));
        userMapper.updateById(user);
        return ResponseData.success();
    }

    @PostResource(path = "/users/{userId}/toggle", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Toggle user pause status")
    public ResponseData<Void> toggleUser(@PathVariable Long userId) {
        UserEntity user = userMapper.selectById(userId);
        ExceptionUtil.isNotNull(user, UserException.USER_NOT_EXIST);
        user.setIsPaused(!Boolean.TRUE.equals(user.getIsPaused()));
        userMapper.updateById(user);
        loginUserCacheService.delete(userId);
        return ResponseData.success();
    }

    @DeleteResource(path = "/users/{userId}", requiredLogin = true, requiredPermission = false)
    @Operation(summary = "Delete user (soft delete)")
    public ResponseData<Void> deleteUser(@PathVariable Long userId) {
        UserEntity user = userMapper.selectById(userId);
        ExceptionUtil.isNotNull(user, UserException.USER_NOT_EXIST);
        user.setIsDeleted(true);
        userMapper.updateById(user);
        loginUserCacheService.delete(userId);
        return ResponseData.success();
    }
}
