package com.mzansishield.api.dto.safebrowsing;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class SafeBrowsingResponse {
    private List<Match> matches;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Match {
        private String threatType;
        private String platformType;
        private String threatEntryType;
    }
}