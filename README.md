Utility helps to define highweght locks in database PostgreSQL
# System requirements:

- docker 
- python3.9

# Run in docker:
```bash
docker build -f container.dockerfile -t idle_in_transaction .
docker run -d -p 80:80 idle_in_transaction --name idle --network="host"
```

# Run on localhost:
```bash
python3.9 idle_in.py
```


# What it can do:
All sessions with status

Hightweght locks details

  - return hightweght details

  - return kill pid list for copy-paste

  - pg_wait query details should be appears if locks exists

Idle_in_transaction:

  - return indle_in_transaction details

  - return kill pid list for copy-paste