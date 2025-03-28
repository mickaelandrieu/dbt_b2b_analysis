with commercials_statistics as (
    select * from {{ ref('fct_commercials') }}
),

commercials as (
    select * from {{ ref('dim_commercials') }}
)

select
    cs.*,
    co.full_name,
    co.team,
    co.seniority,
    co.age_class
from
    commercials_statistics cs
inner join commercials co on co.commercial_id = cs.commercial_id
