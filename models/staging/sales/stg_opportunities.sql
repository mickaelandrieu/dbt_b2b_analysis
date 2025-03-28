SELECT
    id as opportunity_id,
    status,
    accountId as customer_id,
    ownerId as commercial_id,
    attributionDate as attributed_at,
FROM {{ source('sales_analytics', 'opportunities')}}