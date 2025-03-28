# Analyse de la Performance d'une équipe Commerciale en B2B

## Plan/Stratégie

1 - Chargement dans Google BigQuery
2 - Connection dans dbt
3 - Creation de la structure
4 - Mise en place staging/marts
5 - Visualisation Google Data Studio




## Le réalisé sur le projet

- Créer un nouveau projet et ensemble de données dans BigQuery
- Dans Excel, changer le format de date
- Supprimer les ";" de trop dans users.csv
- bq load --source_format=CSV --field_delimiter=";" --replace=true --autodetect --skip_leading_rows=1 --project_id=b2b-case-study raw.users .\users.csv
- bq load --source_format=CSV --field_delimiter=";" --replace=true --autodetect --skip_leading_rows=1 --project_id=b2b-case-study raw.opportunities .\opportunities.csv
- bq load --source_format=CSV --field_delimiter=";" --replace=true --autodetect --skip_leading_rows=1 --project_id=b2b-case-study raw.accounts_with_bookings .\accounts_with_bookings.csv
- Créer un nouveau projet dbt
- Ajouter la connection BigQuery (clé de service JSON rôle Editeur)
- Repository Cloud de chez dbt (limiter les risques de leak)
- Mise en place architecture dbt (renommage projet, ajout dossiers marts/staging)
- Configurer le dataset "sales_analytics" pour ne pas poluer `raw` (ça aurait été mieux de mettre ça ailleurs)
- Dashboard sur Looker Studio qui consomme les données BigQuery
