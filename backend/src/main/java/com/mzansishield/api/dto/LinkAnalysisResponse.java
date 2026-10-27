package com.mzansishield.api.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class LinkAnalysisResponse {
    private boolean isSafe;
    private int score;
    private List<String> reasons;
    private String advice;
}