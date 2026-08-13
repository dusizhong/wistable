package com.apitable.space.assembler;

import com.apitable.space.dto.SpaceDTO;
import com.apitable.space.vo.SpaceSocialConfig;
import com.apitable.space.vo.SpaceVO;

/**
 * space assembler.
 */
public class SpaceAssembler {

    /**
     * transform space dto to space vo.
     *
     * @param spaceDTO space dto
     * @return space vo
     */
    public static SpaceVO toVO(SpaceDTO spaceDTO) {
        SpaceVO spaceVO = new SpaceVO();
        spaceVO.setSpaceId(spaceDTO.getSpaceId());
        spaceVO.setName(spaceDTO.getName());
        spaceVO.setLogo(spaceDTO.getLogo());
        spaceVO.setPoint(spaceDTO.getPoint());
        spaceVO.setAdmin(spaceDTO.getAdmin());
        spaceVO.setPreDeleted(spaceDTO.getPreDeleted());
        return spaceVO;
    }

    /**
     * build default social config.
     *
     * @return social config
     */
    public static SpaceSocialConfig toSocialConfig() {
        return new SpaceSocialConfig();
    }
}
