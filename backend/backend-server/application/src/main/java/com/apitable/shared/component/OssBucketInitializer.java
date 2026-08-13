/*
 * APITable <https://github.com/apitable/apitable>
 * Copyright (C) 2022 APITable Ltd. <https://apitable.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.apitable.shared.component;

import com.apitable.shared.config.properties.ConstProperties;
import com.apitable.shared.config.properties.ConstProperties.OssBucketInfo;
import com.apitable.starter.oss.core.OssClientTemplate;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Ensures configured OSS buckets exist on application startup.
 * This prevents 404 errors on fresh deployments where MinIO data has been cleared.
 */
@Component
@ConditionalOnProperty(value = "starter.oss.enabled", havingValue = "true",
    matchIfMissing = true)
public class OssBucketInitializer {

    private static final Logger LOGGER = LoggerFactory.getLogger(OssBucketInitializer.class);

    @Resource
    private OssClientTemplate ossTemplate;

    @Resource
    private ConstProperties constProperties;

    @PostConstruct
    public void initBuckets() {
        OssBucketInfo bucketInfo = constProperties.getOssBucketByAsset();
        String bucketName = bucketInfo.getBucketName();
        if (bucketName == null || bucketName.isEmpty()) {
            LOGGER.warn("OSS bucket name is not configured, skipping bucket initialization");
            return;
        }
        try {
            LOGGER.info("Ensuring OSS bucket '{}' exists...", bucketName);
            ossTemplate.ensureBucket(bucketName);
            LOGGER.info("OSS bucket '{}' is ready", bucketName);
        } catch (Exception e) {
            LOGGER.error("Failed to initialize OSS bucket '{}': {}", bucketName, e.getMessage());
        }
    }
}
