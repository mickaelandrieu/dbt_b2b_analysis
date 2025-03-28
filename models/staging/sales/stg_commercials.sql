SELECT
    employeeId as commercial_id,
    firstName as first_name,
    lastName as last_name,
    startDate as started_at,
    localization,
    birthDate as birth_date,
FROM {{ source('sales_analytics', 'users')}}