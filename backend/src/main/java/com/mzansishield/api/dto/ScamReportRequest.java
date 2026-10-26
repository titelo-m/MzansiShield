package com.mzansishield.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ScamReportRequest {

    @NotBlank(message = "Target is required")
    @Size(max = 500)
    private String target;

    @NotBlank(message = "Scam type is required")
    @Size(max = 100)
    private String type;

    @Size(max = 2000)
    private String description;
}