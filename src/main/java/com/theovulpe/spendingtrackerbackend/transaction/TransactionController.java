package com.theovulpe.spendingtrackerbackend.transaction;

import com.theovulpe.spendingtrackerbackend.auth.AuthenticationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/v1/transactions")
public class TransactionController {

    private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    @GetMapping
    public List<Transaction> getUserTransactions() {
        return transactionService.getTransactionsForCurrentUser();
    }

    @PostMapping
    public ResponseEntity<Transaction> createTransaction(@RequestBody Transaction t) {
        Transaction saved = transactionService.addTransactionForCurrentUser(t);
        return ResponseEntity.ok(saved);
    }

    @DeleteMapping("/{id}")
    public void deleteTransaction(@PathVariable Integer id) {
        transactionService.deleteTransactionById(id);
    }
}
