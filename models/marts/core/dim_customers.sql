select
    distinct(o.customer_id),
    o.commercial_id,
    min(b.booked_at) as first_seen,
    count(b.customer_id) as orders,
    ntile(3) over (order by avg(b.orders)) AS cohort
from
    {{ ref('stg_bookings') }} b
inner join {{ ref('stg_opportunities') }} o on b.customer_id = o.customer_id
group by 1, 2
order by first_seen
