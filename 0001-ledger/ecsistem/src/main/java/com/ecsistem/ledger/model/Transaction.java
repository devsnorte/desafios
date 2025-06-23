

package com.ecsistem.ledger.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Transação financeira")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Schema(description = "ID da transação", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;

    @Schema(description = "Valor da transação", example = "100.00")
    private BigDecimal amount;

    @Schema(description = "Descrição opcional", example = "Salário")
    private String description;

    @Schema(description = "Data da transação (gerada automaticamente)", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime date;

    @Enumerated(EnumType.STRING)
    @Schema(description = "Tipo da transação (ENTRADA ou SAIDA)", example = "ENTRADA")
    private TransactionType type;
}
