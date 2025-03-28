with customers_orders as (
    select
        b.customer_id,
        b.booked_at as month,
        SUM(b.orders) as orders
    from
        {{ ref('stg_bookings')}} b
    group by b.customer_id, b.booked_at
)

select
    o.commercial_id,
    co.month,
    SUM(co.orders) as orders
from
    {{ ref('stg_opportunities') }} o
inner join
    customers_orders co on o.customer_id = co.customer_id
group by o.commercial_id, co.month
order by o.commercial_id, co.month
