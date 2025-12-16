-- Ensure SQLCMD mode is enabled in SSMS (Query -> SQLCMD Mode)

:r .\99_drop_all.sql
:r .\01_create_database.sql
:r .\02_tables.sql
:r .\03_constraints.sql
:r .\04_seed_data.sql
:r .\05_procedures.sql
:r .\06_triggers.sql
