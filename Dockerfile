FROM dart:3.1.4

RUN mkdir /app

WORKDIR /app

COPY . .

RUN dart pub get

RUN dart pub global activate conduit


EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --retries=5 CMD pg_isready -U soc_user -d soc_db


CMD ["sh", "-c", "conduit serve --port 80"]



