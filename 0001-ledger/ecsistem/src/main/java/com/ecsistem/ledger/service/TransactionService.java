package com.ecsistem.ledger.service;

import com.ecsistem.ledger.model.Transaction;
import com.ecsistem.ledger.model.TransactionType;
import com.ecsistem.ledger.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository repository;

    public Transaction create(Transaction transaction) {
        transaction.setDate(LocalDateTime.now());
        return repository.save(transaction);
    }

    public List<Transaction> getAll() {
        return repository.findAllByOrderByDateDesc();
    }

    public BigDecimal getBalance() {
        return repository.findAll().stream()
                .map(t -> t.getType() == TransactionType.ENTRADA ? t.getAmount() : t.getAmount().negate())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public List<Transaction> findFiltered(TransactionType type, LocalDateTime startDate, LocalDateTime endDate) {
        return repository.findAll().stream()
                .filter(t -> type == null || t.getType() == type)
                .filter(t -> startDate == null || !t.getDate().isBefore(startDate))
                .filter(t -> endDate == null || !t.getDate().isAfter(endDate))
                .toList();
    }
}
