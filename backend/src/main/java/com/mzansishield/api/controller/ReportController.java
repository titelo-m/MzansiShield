package com.mzansishield.api.controller;

import com.mzansishield.api.dto.ScamReportRequest;
import com.mzansishield.api.dto.ScamReportResponse;
import com.mzansishield.api.service.ScamReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ScamReportService service;

    @PostMapping
    public ResponseEntity<ScamReportResponse> submit(@Valid @RequestBody ScamReportRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.submitReport(request));
    }

    @GetMapping
    public ResponseEntity<List<ScamReportResponse>> getAll() {
        return ResponseEntity.ok(service.getAllReports());
    }

    @PostMapping("/{id}/verify")
    public ResponseEntity<ScamReportResponse> verify(@PathVariable Long id) {
        return ResponseEntity.ok(service.verifyReport(id));
    }

    @PostMapping("/{id}/false")
    public ResponseEntity<ScamReportResponse> markFalse(@PathVariable Long id) {
        return ResponseEntity.ok(service.markFalseReport(id));
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Long>> stats() {
        return ResponseEntity.ok(Map.of(
                "totalReports", service.countTotal(),
                "verifiedReports", service.countVerified()
        ));
    }
}