package com.apitable.automation.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Create Robot RO.
 */
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Schema(description = "Create Robot RO")
public class CreateRobotRO {

    @Schema(description = "resource id", requiredMode = Schema.RequiredMode.REQUIRED, example = "dst****")
    @NotBlank(message = "Resource id cannot be empty")
    private String resourceId;

    @Schema(description = "robot name", requiredMode = Schema.RequiredMode.NOT_REQUIRED, example = "test")
    private String name;

    @Schema(description = "robot description", requiredMode = Schema.RequiredMode.NOT_REQUIRED, example = "test")
    private String description;
}
