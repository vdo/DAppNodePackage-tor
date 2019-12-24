FROM alpine:3.11 as builder

RUN apk update && \
    apk add git build-base libressl3.0-libssl libressl-dev

# Shallot onion key generator
RUN git clone https://github.com/katmagic/Shallot && \
    cd Shallot && \
    ./configure && \
    make

FROM alpine:3.11

RUN apk add tor libressl3.0-libcrypto
COPY --from=builder /Shallot/shallot /usr/bin/shallot
COPY entrypoint.sh ./entrypoint.sh

CMD ["./entrypoint.sh"]

