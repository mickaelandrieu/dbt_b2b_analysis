SELECT
    month as booked_at,
    accountId as customer_id,
    grossBookings as orders
FROM {{ source('sales_analytics', 'accounts_with_bookings')}}
