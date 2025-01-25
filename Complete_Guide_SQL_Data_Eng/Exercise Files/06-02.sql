select order_id, customer_id, 
rank() over (partition by customer_id order by total_amount desc) as od
from orders