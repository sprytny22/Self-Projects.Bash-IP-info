FROM ubuntu

COPY ipinfo.sh /ipinfo.sh

RUN apt-get update
RUN apt-get install -y curl

CMD ["/ipinfo.sh", "185.33.37.131"]


