package com.mzansishield.api.repository;

import com.mzansishield.api.model.ScamReport;
import com.mzansishield.api.model.ReportStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScamReportRepository extends JpaRepository<ScamReport, Long> {

    List<ScamReport> findAllByOrderByCreatedAtDesc();

    List<ScamReport> findByStatusOrderByCreatedAtDesc(ReportStatus status);

    long countByStatus(ReportStatus status);
}