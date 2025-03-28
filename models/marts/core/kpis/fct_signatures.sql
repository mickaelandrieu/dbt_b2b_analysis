{% set opportunity_statuses = ['signed', 'lost', 'never touched', 'under negociation'] -%}

with opportunities_per_status as (
    select
        attributed_at as month,
        commercial_id,
        COUNT(opportunity_id) as opportunities,
        status
    from {{ ref('stg_opportunities')}}
    group by commercial_id, month, status
)

select
    ops.commercial_id,
    ops.month,
    {% for status_value in opportunity_statuses -%}
        sum(case when ops.status = '{{ status_value }}' then ops.opportunities else 0 end) as {{ status_value|replace(' ', '_') }}{% if not loop.last %},{% endif %} 
    {% endfor %}
from
    opportunities_per_status ops
group by ops.commercial_id, ops.month
