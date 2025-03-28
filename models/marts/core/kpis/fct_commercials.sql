with commercials_signatures as (
    select * from {{ ref('fct_signatures') }}
),

commercials_orders as (
    select * from {{ ref('fct_orders') }}
),

commercials_first_orders as (
    select * from {{ ref('fct_first_orders') }}
)

select
    cs.*,
    co.orders,
    cfo.first_orders
from
    commercials_signatures cs
inner join
    commercials_orders co on cs.commercial_id = co.commercial_id and cs.month = co.month
inner join
    commercials_first_orders cfo on cs.commercial_id = cfo.commercial_id and cs.month = cfo.month
order by cs.commercial_id, cs.month
