package com.ecsistem.ledger.controller;

import com.ecsistem.ledger.model.Transaction;
import com.ecsistem.ledger.model.TransactionType;
import com.ecsistem.ledger.service.TransactionService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionService service;

    @PostMapping("/transactions")
    @Operation(summary = "Cadastra uma nova transação")
    public ResponseEntity<Transaction> create(@RequestBody Transaction transaction) {
        return ResponseEntity.ok(service.create(transaction));
    }

    @GetMapping("/transactions")
    @Operation(summary = "Lista o histórico de transações")
    public ResponseEntity<List<Transaction>> list(
            @RequestParam(required = false) TransactionType type,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate
    ) {
        return ResponseEntity.ok(service.findFiltered(type, startDate, endDate));
    }

    @GetMapping("/balance")
    @Operation(summary = "Consulta o saldo atual")
    public ResponseEntity<Map<String, BigDecimal>> balance() {
        return ResponseEntity.ok(Map.of("saldo", service.getBalance()));
    }

    @GetMapping("/transactions/export")
    @Operation(summary = "Exporta o histórico filtrado em CSV ou JSON")
    public void export(
            @RequestParam(required = false) TransactionType type,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(defaultValue = "csv") String format,
            HttpServletResponse response
    ) throws IOException {
        List<Transaction> transactions = service.findFiltered(type, startDate, endDate);

        if ("json".equalsIgnoreCase(format)) {
            response.setContentType("application/json");
            response.setHeader("Content-Disposition", "attachment; filename=transactions.json");

            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.findAndRegisterModules(); // suporte para LocalDateTime
            objectMapper.writeValue(response.getOutputStream(), transactions);

        } else {
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=transactions.csv");

            PrintWriter writer = response.getWriter();
            writer.println("id,amount,description,date,type");
            for (Transaction t : transactions) {
                writer.printf("%d,%s,%s,%s,%s%n",
                        t.getId(),
                        t.getAmount(),
                        t.getDescription() != null ? t.getDescription().replace(",", " ") : "",
                        t.getDate(),
                        t.getType()
                );
            }
            writer.flush();
        }
    }
}
