{{ config(materialized='table') }}

with customers as (
    select * from {{ ref('dim_customers') }}
),

commercials as (
    select * from {{ ref('dim_commercials') }}
),

customers_cohorts as (
    select
        cs.*,
        case
            when cs.cohort = 1 then 'Small'
            when cs.cohort = 2 then 'Medium' 
            else 'Large' end as cohort_label
    from
        customers cs
),

customers_loyalty as (
    select
        coc.*,
        1 as `first_trimester`,
        case when orders > 3 then 1 else 0 end as `second_trimester`,
        case when orders > 6 then 1 else 0 end as `third_trimester`,
        case when orders > 9 then 1 else 0 end as `fourth_trimester`,
        case when orders > 12 then 1 else 0 end as `fifth_trimester`,
        case when orders > 15 then 1 else 0 end as `sixth_trimester`,
        case when orders > 24 then 1 else 0 end as `two_years`
    from
        customers_cohorts coc
)

select
    cl.customer_id,
    cl.first_seen,
    cl.orders,
    cl.cohort_label as cohort,
    co.commercial_id,
    co.full_name,
    co.team,
    co.seniority,
    co.age_class,
    cl.first_trimester,
    cl.second_trimester,
    cl.third_trimester,
    cl.fourth_trimester,
    cl.fifth_trimester,
    cl.sixth_trimester,
    cl.two_years
from
    customers_loyalty cl
inner join
    commercials co on co.commercial_id = cl.commercial_id
