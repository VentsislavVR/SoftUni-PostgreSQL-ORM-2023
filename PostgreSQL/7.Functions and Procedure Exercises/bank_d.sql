-- 7.

CREATE OR REPLACE PROCEDURE
    sp_retrieving_holders_with_balance_higher_than(
        searched_balance NUMERIC
) AS
$$
    DECLARE
        holder_info RECORD;
    BEGIN
        FOR holder_info IN
            SELECT
                first_name || ' ' || last_name as full_name,
                SUM(balance) as total_balance
        FROM account_holders AS ah
        JOIN accounts as a
        on ah.id = a.account_holder_id
        GROUP BY
            full_name
        HAVING
            SUM(balance) > searched_balance
        ORDER BY
            full_name
    LOOP
        RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
            END LOOP;
    end;
$$
LANGUAGE plpgsql;

CALL sp_retrieving_holders_with_balance_higher_than(200000);

-- 8.
CREATE OR REPLACE PROCEDURE sp_deposit_money
    (account_id INT,
        money_amount numeric(10,4)
     ) AS
$$
    BEGIN
        UPDATE accounts
        SET balance = balance + money_amount
        WHERE account_id = id;
    end;
$$
    LANGUAGE plpgsql;
CALL sp_deposit_money(1,200);
select
    * from
          accounts
WHERE  id = 1;


-- 9.
CREATE OR REPLACE PROCEDURE sp_withdraw_money
    (account_id INT,
        money_amount numeric(4)
     ) AS
$$
    DECLARE
        current_balance NUMERIC;
    begin
        current_balance := (SELECT balance FROM accounts WHERE id = account_id);

        IF (current_balance - money_amount) >= 0 THEN
            UPDATE accounts
            SET balance = current_balance - money_amount
            where id = account_id;
        ELSE
            RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
        END IF;
    END;

$$
LANGUAGE plpgsql;
CALL sp_withdraw_money(3,4437);

-- 10

CREATE OR REPLACE PROCEDURE sp_transfer_money(
        sender_id INT,
        receiver_id INT,
        amount NUMERIC(4)
) AS
$$
    DECLARE
        current_balance NUMERIC;

    BEGIN
        CALL sp_withdraw_money(sender_id,amount);
        CALL sp_deposit_money(receiver_id,amount);

        SELECT balance INTO current_balance FROM accounts WHERE id = sender_id;
--         instead into its possible to set the balance to the current balance
--         balance := current_balance
        if current_balance < 0 THEN
            ROLLBACK;
        end if;
    END;
$$
LANGUAGE plpgsql;

-- 11.
DROP PROCEDURE IF EXISTS sp_retrieving_holders_with_balance_higher_than;

-- 12.

CREATE TABLE logs(
    id SERIAL PRIMARY KEY,
    account_id INT,
    old_sum NUMERIC (20,4),
    new_sum NUMERIC (20,4)
);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS

$$
    BEGIN
        INSERT INTO
            logs(account_id, old_sum, new_sum)
        VALUES
            (OLD.id, OLD.balance, NEW.balance);

        RETURN NEW;
    end;
$$
language plpgsql;
CREATE TRIGGER
    tr_account_balance_change
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
WHEN
    (NEW.balance <> OLD.balance)
EXECUTE FUNCTION
    trigger_fn_insert_new_entry_into_logs();

-- 13.

CREATE TABLE notification_emails(
    id SERIAL PRIMARY KEY,
    recipient_id INT ,
    subject VARCHAR(255),
    body TEXT
);
CREATE OR REPLACE FUNCTION
    trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER AS
$$
    BEGIN
        INSERT INTO notification_emails(recipient_id, subject, body)
        VALUES (
                NEW.account_id,
                'Balance change for account: ' || NEW.account_id,
                'On' || DATE(now()) ||'your balance was changed from ' || new.old_sum ||' to '|| new.new_sum || '.'
                );
        return NEW;
    end;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_send_email_on_balance_change
AFTER update ON logs
FOR EACH ROW
WHEN (OLD.new_sum <> NEW.new_sum)
EXECUTE function trigger_fn_send_email_on_balance_change();


UPDATE logs
SET new_sum = new_sum + 100
WHERE account_id = 1;
SELECT * FROM notification_emails











