package com.theovulpe.spendingtrackerbackend.transaction;

import com.theovulpe.spendingtrackerbackend.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TransactionRepository extends JpaRepository<Transaction, Integer> {
    List<Transaction> findByUser(User user);
}
