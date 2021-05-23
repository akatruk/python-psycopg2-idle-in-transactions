# python_postgres
FIXME:
TODO:
# What need to add:

#### 0 step::
#### Audit configuration

- Get information about Postgres server

#### 1st step::
#### Server performance analyse

- idle_in_transaction:
    When CPU load more that 80% you need check qieries status 

- pg_settings 

collect::
(
    shared_buffer 25%,
    effective_cash_size 75%,
    work_mem,
    autovacuum settings)

analise settings::
CPU utilisation,
RAM utilisation::
(
    buffer_analise,
    hit ration
)
CPU utilisation

- Connections analise (
all connections grouped by and their count)

analise connections::
TODO:idle in transaction
collect::
(
    getting time of execution,
    CPU utilisation,
    query,
    source_ip)

- WEB server (
Flask,
pip install flusk)
TODO:html basic
TODO:css basic

#### 2nd step::
#### Database analyse
- database size
- database analise
- transactions analise

#### 4st step::
#### Macro analyse
- pg_stat_statements, pg_stat_analyse (wait type)
- retrieve longest query

#### 5st step::
#### Table analyse

- vacuum (critical bloat tables)
- top size tables
- top used tables
- tables toast (alalise datatype inside table)

#### 6th step::
#### Query analyse

