package com.mzansishield.api.controller;

import com.mzansishield.api.dto.LinkAnalysisResponse;
import com.mzansishield.api.model.LinkCheck;
import com.mzansishield.api.repository.LinkCheckRepository;
import com.mzansishield.api.service.MessageAnalysisService;
import com.mzansishield.api.service.SafeBrowsingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/check")
@RequiredArgsConstructor
public class LinkCheckerController {

    private final SafeBrowsingService safeBrowsingService;
    private final MessageAnalysisService messageAnalysisService;
    private final LinkCheckRepository linkCheckRepository;

    private static final Pattern URL_PATTERN =
            Pattern.compile("^(https?://)?[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}.*$");

    @PostMapping
    public ResponseEntity<LinkAnalysisResponse> check(@RequestBody Map<String, String> body) {
        String input = body.get("input");
        if (input == null || input.trim().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        input = input.trim();
        LinkAnalysisResponse response;

        if (URL_PATTERN.matcher(input).matches() || (input.contains(".") && !input.contains(" "))) {
            boolean isSafe = safeBrowsingService.isUrlSafe(input);
            if (isSafe) {
                response = LinkAnalysisResponse.builder()
                        .isSafe(true).score(5)
                        .reasons(List.of("This URL is not on Google's known threat lists."))
                        .advice("This link appears safe, but always verify the sender before clicking.")
                        .build();
            } else {
                response = LinkAnalysisResponse.builder()
                        .isSafe(false).score(95)
                        .reasons(List.of(
                                "This URL is flagged by Google Safe Browsing as a known threat.",
                                "It may be a phishing site, malware host, or unwanted software distributor."
                        ))
                        .advice("Do not visit this link. If it claims to be from a bank or SARS, contact them directly using their official numbers.")
                        .build();
            }
        } else {
            response = messageAnalysisService.analyzeMessage(input);
        }

        // Save to DB
        LinkCheck check = LinkCheck.builder()
                .input(input)
                .type(URL_PATTERN.matcher(input).matches() ? "URL" : "Message")
                .score(response.getScore())
                .isSafe(response.isSafe())
                .reasons(String.join(" | ", response.getReasons()))
                .advice(response.getAdvice())
                .build();
        linkCheckRepository.save(check);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/recent")
    public ResponseEntity<List<Map<String, Object>>> getRecentChecks() {
        List<Map<String, Object>> result = linkCheckRepository.findTop20ByOrderByCreatedAtDesc()
                .stream()
                .map(c -> Map.<String, Object>of(
                        "id", c.getId(),
                        "input", c.getInput(),
                        "type", c.getType(),
                        "score", c.getScore(),
                        "isSafe", c.isSafe(),
                        "reasons", c.getReasons() == null ? List.of() : List.of(c.getReasons().split(" \\| ")),
                        "advice", c.getAdvice() == null ? "" : c.getAdvice(),
                        "createdAt", c.getCreatedAt().toString()
                ))
                .collect(Collectors.toList());
        return ResponseEntity.ok(result);
    }
}