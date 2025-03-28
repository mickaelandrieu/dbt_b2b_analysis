
with customers_monthly_performance as (
    select * from {{ ref('customers_monthly_performance') }}
),
data_prep as (
    select
        commercial_id,
        cohort,
        category_label,
        {% for i in [1,2,3,4,5,6,7,8,9,10,11,12] %}
            sum(case when diff_months = {{ i - 1 }} then 1 else 0 end) as month_{{ i }}{% if not loop.last %},{% endif %}
        {% endfor %}
    from
        {{ ref('customers_monthly_performance') }}
    group by commercial_id, cohort, category_label
    order by commercial_id, cohort, category_label
),

customers_per_cohort as (
    select
        dp.*,
        dp.month_1 as total_customers,
        co.full_name,
        co.team
    from
        data_prep dp
    left join
        {{ ref('dim_commercials') }} co on dp.commercial_id = co.commercial_id
    order by commercial_id, cohort
),
customer_churn_pivot as (
    select 
        cpc.commercial_id,
        cpc.cohort,
        cpc.category_label,
        {% for i in [1,2,3,4,5,6,7,8,9,10,11,12] %}
            round((cpc.month_{{i}} / cpc.total_customers), 2) as churn_{{i}},
        {% endfor %}
        cpc.full_name,
        cpc.team
    from
        customers_per_cohort cpc
    order by commercial_id, cohort
)

select
    commercial_id,
    cohort,
    category_label,
    full_name,
    team,
    churn,
    replace(months, 'churn_', '') as months
from
    customer_churn_pivot
unpivot(churn for months in(
    {% for i in [1,2,3,4,5,6,7,8,9,10,11,12] %}
        churn_{{i}}{% if not loop.last %},{% endif %}
    {% endfor %}
))
