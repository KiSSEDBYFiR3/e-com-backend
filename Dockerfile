FROM dart:3.1.4

RUN mkdir /app

WORKDIR /app

RUN dart pub get --no-precompile
ADD . /app/

RUN dart pub get --offline --no-precompile

RUN dart pub global activate conduit

COPY . .

EXPOSE 80

ENTRYPOINT ["dart", "pub", "run", "conduit:conduit", "serve", "--port", "80"]