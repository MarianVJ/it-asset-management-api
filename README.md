## Prerequisites

- Node.js v18.12.1 (ruleaza `nvm use` in radacina proiectului)
- MS SQL Server (Developer Edition)
- SQL Server Management Studio (SSMS)

## Database Setup

1. Deschide SSMS și conectează-te la instanța locală
2. Creează un database nou numit `it_asset_management`
3. Rulează `sql/schema.sql` — creează toate tabelele
4. Rulează `sql/seed.sql` — populează cu date de test

## Environment

Creează fișierul `api/.env` cu următorul conținut și completează cu datele tale:

```env
DB_SERVER=        # ex: localhost sau NUMECALCULATOR\\SQLEXPRESS
DB_NAME=it_asset_management
DB_USER=          # gol daca folosesti Windows Authentication
DB_PASSWORD=      # gol daca folosesti Windows Authentication
DB_PORT=1433
```
