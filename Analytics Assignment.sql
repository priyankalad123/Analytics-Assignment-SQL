USE transactions_db;

SHOW TABLES;

# Monthly transactions
SELECT
  DATE_FORMAT(FROM_UNIXTIME(transaction_timestamp), '%Y-%m') AS month,
  SUM(transaction_amount) AS cumulative_amount
FROM transactions
GROUP BY month
ORDER BY month;

# Most Popular Products/Services
SELECT
  merchant_name,
  COUNT(*) AS transaction_count
FROM transactions
GROUP BY merchant_name
ORDER BY transaction_count DESC
LIMIT 5;

# Daily Revenue Trend
SELECT
  DATE_FORMAT(FROM_UNIXTIME(transaction_timestamp), '%Y-%m-%d') AS day,
  SUM(transaction_amount) AS daily_revenue
FROM transactions
GROUP BY day
ORDER BY day;

# Average Transaction Amount by Product Category
SELECT
  merchant_type,
  AVG(transaction_amount) AS average_transaction_amount
FROM transactions
GROUP BY merchant_type
ORDER BY average_transaction_amount DESC;

# Transaction Funnel Analysis
SELECT
  transaction_status,
  COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_status
ORDER BY transaction_count DESC;

# Monthly Retention Rate
SELECT
  cohort_month,
  COUNT(DISTINCT t.user_id) AS cohort_size,
  COUNT(DISTINCT CASE WHEN DATE_FORMAT(FROM_UNIXTIME(t.transaction_timestamp), '%Y-%m') = cohort_month THEN t.user_id END) AS retained_users,
  COUNT(DISTINCT CASE WHEN DATE_FORMAT(FROM_UNIXTIME(t.transaction_timestamp), '%Y-%m') > cohort_month THEN t.user_id END) AS subsequent_users,
  COUNT(DISTINCT CASE WHEN DATE_FORMAT(FROM_UNIXTIME(t.transaction_timestamp), '%Y-%m') = cohort_month THEN t.user_id END) / COUNT(DISTINCT c.user_id) AS retention_rate
FROM (
  SELECT
    user_id,
    DATE_FORMAT(FROM_UNIXTIME(MIN(transaction_timestamp)), '%Y-%m') AS cohort_month
  FROM transactions
  GROUP BY user_id
) c
JOIN transactions t ON c.user_id = t.user_id
GROUP BY cohort_month
ORDER BY cohort_month;









