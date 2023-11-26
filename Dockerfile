FROM dart:3.1.4

RUN mkdir /app

WORKDIR /app

COPY . .

RUN dart pub get

RUN dart pub global activate conduit



EXPOSE 80

ENTRYPOINT ["dart", "pub", "run", "conduit:conduit", "serve", "--port", "80"]