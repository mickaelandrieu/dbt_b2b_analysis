with accounts_bookings as (
    select
        *,
        row_number() over (partition by customer_id order by booked_at) as nth_order
    from {{ ref('stg_bookings') }}
),

commercials as (
    select
        commercial_id,
        full_name,
        team
    from {{ ref('dim_commercials') }}
),

opportunities as (
    select * from {{ ref('stg_opportunities') }}
),

accounts_with_commercial as (
    select
        DISTINCT(o.customer_id),
        o.commercial_id
    from
        accounts_bookings ab
    inner join opportunities o on ab.customer_id = o.customer_id
),

-- Cohort using bookings and number of customers
bookings_per_month as (
    select
        avg(orders) as monthly_orders,
        customer_id
    from
        accounts_bookings
    group by customer_id
),

customers_ranking as (
    select
        customer_id,
        monthly_orders,
        ntile(3) over (order by monthly_orders) AS category
    from
        bookings_per_month
),

customers_category as (
    select
        cr.customer_id,
        case
            when cr.category = 1 then 'Small'
            when cr.category = 2 then 'Medium' 
            else 'Large' end as category_label
    from
        customers_ranking cr
),

customers_statistics as (
    select
        ab.customer_id,
        min(ab.booked_at) as first_seen,
        extract(month from min(ab.booked_at)) as cohort,
        count(ab.customer_id) as orders,
        sum(orders) as lifetime_value,
        round(avg(orders),0) as mean_value
    from
        accounts_bookings ab
    group by ab.customer_id
)

select
    ab.customer_id,
    ab.booked_at as month,
    co.full_name,
    co.team,
    ab.nth_order,
    ab.orders,
    ac.commercial_id,
    cs.first_seen,
    cs.cohort,
    timestamp_diff(ab.booked_at, cs.first_seen, MONTH) as diff_months,
    cs.orders as repeated_orders,
    cs.lifetime_value,
    cs.mean_value,
    cc.category_label
from
    accounts_bookings ab    
inner join customers_category as cc on cc.customer_id = ab.customer_id
inner join accounts_with_commercial ac on ac.customer_id = ab.customer_id
inner join customers_statistics cs on cs.customer_id = ab.customer_id
inner join commercials as co on co.commercial_id = ac.commercial_id
order by customer_id