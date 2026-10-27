package com.mzansishield.api.dto.safebrowsing;

import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class SafeBrowsingRequest {
    private ClientInfo client;
    private ThreatInfo threatInfo;

    @Data
    @Builder
    public static class ClientInfo {
        private String clientId;
        private String clientVersion;
    }

    @Data
    @Builder
    public static class ThreatInfo {
        private List<String> threatTypes;
        private List<String> platformTypes;
        private List<String> threatEntryTypes;
        private List<Map<String, String>> threatEntries;
    }
}