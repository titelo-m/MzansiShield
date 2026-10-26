package com.mzansishield.api.dto;

import com.mzansishield.api.model.ReportStatus;
import com.mzansishield.api.model.ScamReport;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ScamReportResponse {

    private Long id;
    private String target;
    private String type;
    private String description;
    private Integer confidenceScore;
    private ReportStatus status;
    private LocalDateTime createdAt;

    public static ScamReportResponse from(ScamReport report) {
        return ScamReportResponse.builder()
                .id(report.getId())
                .target(report.getTarget())
                .type(report.getType())
                .description(report.getDescription())
                .confidenceScore(report.getConfidenceScore())
                .status(report.getStatus())
                .createdAt(report.getCreatedAt())
                .build();
    }
}