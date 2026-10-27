package com.mzansishield.api.service;

import com.mzansishield.api.dto.LinkAnalysisResponse;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@Service
public class MessageAnalysisService {

    private static final List<String> URGENCY_KEYWORDS = List.of(
            "urgent", "immediate", "verify now", "suspended", "frozen",
            "click here", "act now", "limited time", "expire"
    );

    private static final List<String> SA_SCAM_KEYWORDS = List.of(
            "sars", "refund", "fnb", "standard bank", "absa", "nedbank",
            "capitec", "whatsapp job", "registration fee", "lottery", "prize"
    );

    private static final Pattern URL_PATTERN =
            Pattern.compile("https?://[^\\s]+", Pattern.CASE_INSENSITIVE);

    public LinkAnalysisResponse analyzeMessage(String message) {
        List<String> reasons = new ArrayList<>();
        int score = 0;

        String lower = message.toLowerCase();

        List<String> foundScamKeywords = new ArrayList<>();
        for (String keyword : SA_SCAM_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundScamKeywords.add(keyword);
            }
        }
        if (!foundScamKeywords.isEmpty()) {
            score += 40;
            reasons.add("Contains keywords commonly used in South African scams: " + foundScamKeywords);
        }

        List<String> foundUrgency = new ArrayList<>();
        for (String keyword : URGENCY_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundUrgency.add(keyword);
            }
        }
        if (!foundUrgency.isEmpty()) {
            score += 30;
            reasons.add("Uses urgency tactics to pressure you: " + foundUrgency);
        }

        var matcher = URL_PATTERN.matcher(message);
        List<String> foundUrls = new ArrayList<>();
        while (matcher.find()) {
            foundUrls.add(matcher.group());
        }
        if (!foundUrls.isEmpty()) {
            score += 20;
            reasons.add("Contains link(s) that may lead to phishing sites: " + foundUrls);
        }

        boolean isSafe = score < 30;

        String advice;
        if (isSafe) {
            advice = "This message appears safe, but always stay cautious with unexpected messages.";
        } else if (score >= 70) {
            advice = "This message is highly likely to be a scam. Do not click any links or provide personal information. Report it to the authorities.";
        } else {
            advice = "This message has suspicious elements. Do not click links or share personal details unless you can verify the sender through official channels.";
        }

        return LinkAnalysisResponse.builder()
                .isSafe(isSafe)
                .score(Math.min(score, 100))
                .reasons(reasons)
                .advice(advice)
                .build();
    }
}