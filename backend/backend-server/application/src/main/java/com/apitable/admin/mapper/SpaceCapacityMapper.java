/**
 * 空间自定义用量限额 MyBatis-Plus Mapper 接口。
 *
 * @author  系统管理员
 * @created 2026-07-27
 */

package com.apitable.admin.mapper;

import com.apitable.admin.entity.SpaceCapacityEntity;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

public interface SpaceCapacityMapper extends BaseMapper<SpaceCapacityEntity> {

    SpaceCapacityEntity selectBySpaceId(@Param("spaceId") String spaceId);
}
