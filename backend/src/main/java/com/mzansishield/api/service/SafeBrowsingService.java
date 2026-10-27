package com.mzansishield.api.service;

import com.mzansishield.api.dto.safebrowsing.SafeBrowsingRequest;
import com.mzansishield.api.dto.safebrowsing.SafeBrowsingResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SafeBrowsingService {

    @Value("${google.safebrowsing.api-key}")
    private String apiKey;

    private final RestTemplate restTemplate = new RestTemplate();

    private static final String SAFE_BROWSING_URL =
            "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=";

    public boolean isUrlSafe(String url) {
        try {
            SafeBrowsingRequest request = SafeBrowsingRequest.builder()
                    .client(SafeBrowsingRequest.ClientInfo.builder()
                            .clientId("mzansishield")
                            .clientVersion("1.0.0")
                            .build())
                    .threatInfo(SafeBrowsingRequest.ThreatInfo.builder()
                            .threatTypes(List.of("MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE"))
                            .platformTypes(List.of("ANY_PLATFORM"))
                            .threatEntryTypes(List.of("URL"))
                            .threatEntries(List.of(Map.of("url", url)))
                            .build())
                    .build();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<SafeBrowsingRequest> entity = new HttpEntity<>(request, headers);

            ResponseEntity<SafeBrowsingResponse> response = restTemplate.postForEntity(
                    SAFE_BROWSING_URL + apiKey,
                    entity,
                    SafeBrowsingResponse.class
            );

            SafeBrowsingResponse body = response.getBody();
            return body == null || body.getMatches() == null || body.getMatches().isEmpty();

        } catch (Exception e) {
            System.err.println("Safe Browsing API error: " + e.getMessage());
            return true;
        }
    }
}