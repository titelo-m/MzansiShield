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
            "click here", "act now", "limited time", "expire", "today only",
            "hurry", "last chance", "final notice"
    );

    private static final List<String> SA_SCAM_KEYWORDS = List.of(
            "sars", "refund", "fnb", "standard bank", "absa", "nedbank",
            "capitec", "lottery", "prize", "win", "won"
    );

    private static final List<String> JOB_SCAM_KEYWORDS = List.of(
            "shortlisted", "selected", "position", "job offer",
            "cv", "resume", "recruitment", "hiring", "interview",
            "work from home", "earn r", "earn up to", "monthly salary",
            "no experience needed", "data entry", "typing job",
            "your application", "your cv", "your resume"
    );

    private static final List<String> JOB_FEE_KEYWORDS = List.of(
            "registration fee", "processing fee", "activation fee",
            "deposit", "pay r", "send r", "payment required",
            "admin fee", "training fee", "to secure", "to activate"
    );

    private static final List<String> FAMILY_IMPERSONATION_KEYWORDS = List.of(
            "my phone broke", "new number", "this is my new", "lost my phone",
            "mom", "dad", "mum", "sister", "brother", "aunt", "uncle"
    );

    private static final List<String> MONEY_REQUEST_KEYWORDS = List.of(
            "send r", "send me", "need r", "please send", "transfer r",
            "owe you", "emergency", "help me with"
    );

    private static final List<String> PII_REQUEST_KEYWORDS = List.of(
            "id number", "banking details", "account number", "pin",
            "password", "otp", "one-time pin", "verification code",
            "id document", "bank details"
    );

    private static final Pattern URL_PATTERN =
            Pattern.compile("https?://[^\\s]+", Pattern.CASE_INSENSITIVE);

    public LinkAnalysisResponse analyzeMessage(String message) {
        List<String> reasons = new ArrayList<>();
        int score = 0;

        String lower = message.toLowerCase();

        // 1. South African scam keywords
        List<String> foundScamKeywords = new ArrayList<>();
        for (String keyword : SA_SCAM_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundScamKeywords.add(keyword);
            }
        }
        if (!foundScamKeywords.isEmpty()) {
            score += 30;
            reasons.add("Contains keywords commonly used in South African scams: " + foundScamKeywords);
        }

        // 2. Urgency tactics
        List<String> foundUrgency = new ArrayList<>();
        for (String keyword : URGENCY_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundUrgency.add(keyword);
            }
        }
        if (!foundUrgency.isEmpty()) {
            score += 20;
            reasons.add("Uses urgency tactics to pressure you: " + foundUrgency);
        }

        // 3. Suspicious URLs
        var matcher = URL_PATTERN.matcher(message);
        List<String> foundUrls = new ArrayList<>();
        while (matcher.find()) {
            foundUrls.add(matcher.group());
        }
        if (!foundUrls.isEmpty()) {
            score += 15;
            reasons.add("Contains link(s) that may lead to phishing sites: " + foundUrls);
        }

        // 4. Family impersonation scam
        List<String> foundFamily = new ArrayList<>();
        for (String keyword : FAMILY_IMPERSONATION_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundFamily.add(keyword);
            }
        }
        List<String> foundMoney = new ArrayList<>();
        for (String keyword : MONEY_REQUEST_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundMoney.add(keyword);
            }
        }
        if (!foundFamily.isEmpty() && !foundMoney.isEmpty()) {
            score += 40;
            reasons.add("Matches a known family impersonation pattern (asks you to send money from a 'new number').");
        }

        // 5. Job scam detection
        List<String> foundJobKeywords = new ArrayList<>();
        for (String keyword : JOB_SCAM_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundJobKeywords.add(keyword);
            }
        }
        List<String> foundJobFees = new ArrayList<>();
        for (String keyword : JOB_FEE_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundJobFees.add(keyword);
            }
        }
        if (!foundJobKeywords.isEmpty() && !foundJobFees.isEmpty()) {
            score += 50;
            reasons.add("Classic job scam pattern: mentions a job opportunity AND asks for payment upfront.");
            reasons.add("Job keywords detected: " + foundJobKeywords);
            reasons.add("Fee/deposit keywords detected: " + foundJobFees);
        } else if (!foundJobFees.isEmpty()) {
            score += 25;
            reasons.add("Asks for a fee, deposit, or payment: " + foundJobFees);
        } else if (!foundJobKeywords.isEmpty()) {
            score += 15;
            reasons.add("Mentions a job opportunity: " + foundJobKeywords);
        }

        // 6. PII request detection (increased score - this is a serious red flag)
        List<String> foundPII = new ArrayList<>();
        for (String keyword : PII_REQUEST_KEYWORDS) {
            if (lower.contains(keyword)) {
                foundPII.add(keyword);
            }
        }
        if (!foundPII.isEmpty()) {
            score += 40;
            reasons.add("Requests sensitive information (ID, banking details, PIN, OTP): " + foundPII);
        }

        boolean isSafe = score < 30;
        int finalScore = Math.min(score, 100);

        String advice;
        if (isSafe) {
            advice = "This message appears safe, but always stay cautious with unexpected messages.";
        } else if (finalScore >= 70) {
            advice = "This message is highly likely to be a scam. Do not click any links, send money, or provide personal information. Report it to the authorities.";
        } else {
            advice = "This message has suspicious elements. Do not click links or share personal details unless you can verify the sender through official channels.";
        }

        return LinkAnalysisResponse.builder()
                .isSafe(isSafe)
                .score(finalScore)
                .reasons(reasons)
                .advice(advice)
                .build();
    }
}