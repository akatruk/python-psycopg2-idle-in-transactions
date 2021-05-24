FROM python:latest
RUN mkdir -p /app/
WORKDIR /app
RUN git clone https://github.com/akatruk/flask.git /app
RUN pip3 install flask psycopg2
COPY . .
ENTRYPOINT [ "python3", "/app/idle_in.py"]
