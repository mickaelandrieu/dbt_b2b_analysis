-- First orders per month can't be bigger than orders for a customer

select
    orders,
    first_orders
from
    {{ ref('fct_commercials') }}
where first_orders >= orders
