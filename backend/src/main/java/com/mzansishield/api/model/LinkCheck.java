package com.mzansishield.api.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "link_checks")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LinkCheck {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 1000)
    private String input;

    @Column(nullable = false, length = 20)
    private String type; // URL or Message

    @Column(nullable = false)
    private int score;

    @Column(nullable = false)
    private boolean isSafe;

    @Column(length = 2000)
    private String reasons;

    @Column(length = 2000)
    private String advice;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
}