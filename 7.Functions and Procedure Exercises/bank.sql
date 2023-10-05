-- 7.
-- CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(
--     searched_balance numeric
-- ) as
-- $$
--     BEGIN
--         SELECT
--     end;
--
-- $$
-- language plpgsql;
-- SELECT
--     id,
--     sum(balance) as 'total_balance'
-- FROM accounts AS a
-- WHERE total_balance > 200000
-- GROUP BY a.id;






-- 8.
CREATE OR REPLACE PROCEDURE sp_deposit_money
    (account_id INT,
        money_amount numeric(4)
     ) AS
    $$
    BEGIN
        UPDATE accounts AS a
        SET balance = balance + money_amount
        WHERE account_id = a.id;
    end;
    $$
LANGUAGE plpgsql;

SELECT
     id,
    account_holder_id,
    balance
    FROM accounts
        JOIN account_holders
            using (id);
CALL sp_deposit_money(1,200);

-- 9.
CREATE OR REPLACE PROCEDURE sp_withdraw_money
    (account_id INT,
        money_amount numeric(4)
     ) AS
$$
    BEGIN
        IF (SELECT balance FROM accounts WHERE account_id =id) < money_amount THEN
            RAISE NOTICE 'Insufficient balance to withdraw' ;
        ELSE
            update accounts SET balance = balance - money_amount WHERE account_id =id;
        end if;

    end;
$$
LANGUAGE plpgsql;

call sp_withdraw_money(1,200);

-- 10. PROBLEM
CREATE OR REPLACE PROCEDURE sp_transfer_money(
        sender_id INT,
        receiver_id INT,
        amount numeric(4)
) as
$$
    BEGIN

        SELECT sp_withdraw_money(sender_id,amount);
        SELECT sp_deposit_money(receiver_id,amount);
        COMMIT;
        EXCEPTION
        WHEN others THEN
        RAISE NOTICE 'Could not transfer';
        ROLLBACK;
    end;
$$
LANGUAGE plpgsql;


call sp_transfer_money(1,2,1043.9000);
SELECT
     id,
    account_holder_id,
    balance
    FROM accounts
        JOIN account_holders
            using (id)
order by id;

-- 11.
DROP PROCEDURE IF EXISTS sp_retrieving_holders_with_balance_higher_than;

-- 12. dosnt work
CREATE TABLE logs(id int
                 ,account_id int
                 , old_sum float
                 ,new_sum float);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS
$$
BEGIN
    IF OLD.balance <> NEW.balance THEN
        INSERT INTO logs (account_id, old_sum, new_sum)
        VALUES (OLD.id, OLD.balance, NEW.balance);
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;
CREATE TRIGGER tr_account_balance_change
AFTER UPDATE ON accounts
FOR EACH ROW
EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs();

