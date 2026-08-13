FROM alpine:3.19

RUN apk add --no-cache mysql-client

COPY *.sql /sql/

CMD for f in /sql/0*.sql; do echo "Running $f..."; mysql -h${DB_HOST} -u${DB_USERNAME} -p${DB_PASSWORD} --default-character-set=utf8mb4 ${DB_NAME} < "$f" && echo "  done"; done
