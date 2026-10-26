package com.mzansishield.api.service;

import com.mzansishield.api.dto.ScamReportRequest;
import com.mzansishield.api.dto.ScamReportResponse;
import com.mzansishield.api.model.ReportStatus;
import com.mzansishield.api.model.ScamReport;
import com.mzansishield.api.repository.ScamReportRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ScamReportService {

    private final ScamReportRepository repository;

    public ScamReportResponse submitReport(ScamReportRequest request) {
        ScamReport report = ScamReport.builder()
                .target(request.getTarget())
                .type(request.getType())
                .description(request.getDescription())
                .confidenceScore(10)
                .status(ReportStatus.PENDING)
                .build();

        ScamReport saved = repository.save(report);
        return ScamReportResponse.from(saved);
    }

    public List<ScamReportResponse> getAllReports() {
        return repository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(ScamReportResponse::from)
                .collect(Collectors.toList());
    }

    public ScamReportResponse verifyReport(Long id) {
        ScamReport report = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Report not found"));
        report.setStatus(ReportStatus.VERIFIED);
        report.setConfidenceScore(Math.min(100, report.getConfidenceScore() + 20));
        return ScamReportResponse.from(repository.save(report));
    }

    public ScamReportResponse markFalseReport(Long id) {
        ScamReport report = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Report not found"));
        report.setStatus(ReportStatus.FALSE);
        return ScamReportResponse.from(repository.save(report));
    }

    public long countVerified() {
        return repository.countByStatus(ReportStatus.VERIFIED);
    }

    public long countTotal() {
        return repository.count();
    }
}