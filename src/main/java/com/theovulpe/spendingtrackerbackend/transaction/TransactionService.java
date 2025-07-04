package com.theovulpe.spendingtrackerbackend.transaction;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionService {
    private final TransactionRepository transactionRepository;

    public TransactionService(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    public List<Transaction> getTransactions() {
        return transactionRepository.findAll();
    }

    public void insertTransaction(Transaction transaction) {
        transactionRepository.save(transaction);
    }

    public void deleteTransactionById(Integer id) {
        transactionRepository.deleteById(id);
    }
}
