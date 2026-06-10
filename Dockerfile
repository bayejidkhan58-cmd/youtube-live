FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ffmpeg
WORKDIR /app
COPY stream.sh .
RUN chmod +x stream.sh
CMD ["./stream.sh"]
