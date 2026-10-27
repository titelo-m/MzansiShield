package com.mzansishield.api.controller;

import com.mzansishield.api.dto.LinkAnalysisResponse;
import com.mzansishield.api.service.MessageAnalysisService;
import com.mzansishield.api.service.SafeBrowsingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/api/check")
@RequiredArgsConstructor
public class LinkCheckerController {

    private final SafeBrowsingService safeBrowsingService;
    private final MessageAnalysisService messageAnalysisService;

    private static final Pattern URL_PATTERN =
            Pattern.compile("^(https?://)?[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}.*$");

    @PostMapping
    public ResponseEntity<LinkAnalysisResponse> check(@RequestBody Map<String, String> body) {
        String input = body.get("input");
        if (input == null || input.trim().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        input = input.trim();

        if (URL_PATTERN.matcher(input).matches() || (input.contains(".") && !input.contains(" "))) {
            boolean isSafe = safeBrowsingService.isUrlSafe(input);

            if (isSafe) {
                return ResponseEntity.ok(LinkAnalysisResponse.builder()
                        .isSafe(true)
                        .score(5)
                        .reasons(List.of("This URL is not on Google's known threat lists."))
                        .advice("This link appears safe, but always verify the sender before clicking.")
                        .build());
            } else {
                return ResponseEntity.ok(LinkAnalysisResponse.builder()
                        .isSafe(false)
                        .score(95)
                        .reasons(List.of(
                                "This URL is flagged by Google Safe Browsing as a known threat.",
                                "It may be a phishing site, malware host, or unwanted software distributor."
                        ))
                        .advice("Do not visit this link. If it claims to be from a bank or SARS, contact them directly using their official numbers.")
                        .build());
            }
        }

        return ResponseEntity.ok(messageAnalysisService.analyzeMessage(input));
    }
}