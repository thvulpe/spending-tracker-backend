package com.theovulpe.spendingtrackerbackend.transaction;

import com.theovulpe.spendingtrackerbackend.auth.AuthenticationService;
import com.theovulpe.spendingtrackerbackend.user.User;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionService {
    private final TransactionRepository transactionRepository;
    private final AuthenticationService authService;

    public TransactionService(TransactionRepository transactionRepository, AuthenticationService authService) {
        this.transactionRepository = transactionRepository;
        this.authService = authService;
    }

    public void deleteTransactionById(Integer id) {
        transactionRepository.deleteById(id);
    }

    public List<Transaction> getTransactionsForCurrentUser() {
        User user = authService.getCurrentUser();
        return transactionRepository.findByUser(user);
    }

    public Transaction addTransactionForCurrentUser(Transaction t) {
        User user = authService.getCurrentUser();
        t.setUser(user);
        return transactionRepository.save(t);
    }

}
