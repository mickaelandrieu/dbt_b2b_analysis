with customers_orders_list as (
    select
        b.customer_id,
        b.booked_at as month,
        b.orders,
        row_number() over (partition by b.customer_id order by b.booked_at) as nth_order
    from
        {{ ref('stg_bookings')}} b
),

customers_first_orders as (
    select
        col.customer_id,
        col.month,
        col.orders as first_orders
    from
        customers_orders_list col
    where col.nth_order = 1
)

select
    o.commercial_id,
    cfo.month,
    SUM(cfo.first_orders) as first_orders
from
    {{ ref('stg_opportunities') }} o
inner join
    customers_first_orders cfo on o.customer_id = cfo.customer_id
group by o.commercial_id, cfo.month
order by o.commercial_id, cfo.month
