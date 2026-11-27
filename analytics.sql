USE foodfleet_hybrid;
SELECT HOUR(ordered_at) hour,area,COUNT(*) orders FROM vw_restaurant_analytics GROUP BY hour,area ORDER BY orders DESC;
SELECT cuisine,COUNT(*) orders FROM vw_restaurant_analytics GROUP BY cuisine ORDER BY orders DESC;
SELECT restaurant,SUM(total_amount) revenue FROM vw_restaurant_analytics WHERE status='COMPLETED' GROUP BY restaurant ORDER BY revenue DESC;
SELECT restaurant,AVG(delivery_minutes) average_minutes FROM vw_restaurant_analytics WHERE delivery_minutes IS NOT NULL GROUP BY restaurant;
SELECT payment_method,COUNT(*) count FROM orders GROUP BY payment_method;
