package com.mzansishield.api.repository;

import com.mzansishield.api.model.LinkCheck;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LinkCheckRepository extends JpaRepository<LinkCheck, Long> {

    List<LinkCheck> findTop20ByOrderByCreatedAtDesc();
}