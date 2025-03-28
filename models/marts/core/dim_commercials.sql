select
    c.commercial_id,
    concat(c.first_name, ' ', c.last_name) as full_name,
    c.localization as team,
    case
        when date_diff(current_date(), c.started_at, year) <= 2 then 'Junior'
        when date_diff(current_date(), c.started_at, year) > 2 and date_diff(current_date(), c.started_at, year) <= 4 then 'Developping'
        else 'Senior' end as seniority,
    case
        when date_diff(current_date(), c.birth_date, year) >= 18 and date_diff(current_date(), c.birth_date, year) < 24 then '18-24'
        when date_diff(current_date(), c.birth_date, year) >= 25 and date_diff(current_date(), c.birth_date, year) < 34 then '25-34'
        when date_diff(current_date(), c.birth_date, year) >= 35 and date_diff(current_date(), c.birth_date, year) < 44 then '35-44'
        when date_diff(current_date(), c.birth_date, year) >= 45 and date_diff(current_date(), c.birth_date, year) < 54 then '45-54'
        else '55+' end as age_class
from
    {{ ref('stg_commercials') }} c
