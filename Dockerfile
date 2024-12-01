FROM debian:bookworm

ARG MAINTAINER="Jake Fortune"
ARG VERSION="0.1.0"
ARG DESCRIPTION="Sierra-Axe - RTMP Server, with HLS and DASH HTTP Streaming"
LABEL MAINTAINER=${MAINTAINER}
LABEL VERSION=${VERSION}
LABEL DESCRIPTION=${DESCRIPTION}

# Set default ports and tuning parameters
ENV HTTP_PORT="80"
# For RTMP streaming, this is the rtmp://hostname/<STREAM_APP_NAME>/<streamkey>
ENV STREAM_APP_NAME="stream"
ENV RTMP_PORT="1935"
# These tuning paramters work with the latency of the HTTP stream compared to the RTMP input
# See https://github.com/dreamsxin/nginx-rtmp-wiki/blob/master/Directives.md
ENV RTMP_FRAG_SIZE="2s"
ENV RTMP_PLAYLIST_LENGTH="10s"

# Installation of the RTMP, NGINX, and FFMPEG
RUN apt update && \
  apt install libnginx-mod-rtmp ffmpeg gettext -y && \
  rm -rf /var/lib/apt/lists/* && \
  adduser nginx

# Add NGINX path, config and static files.
ENV PATH="${PATH}:/usr/local/nginx/sbin"
ADD nginx.conf /etc/nginx/nginx.conf.template
ADD static /www/static
ADD dockerrun.sh /dockerrun.sh
RUN mkdir -p /opt/data/d && \
  mkdir /opt/data/h && \
  chmod 755 /dockerrun.sh

EXPOSE $HTTP_PORT
EXPOSE $RTMP_PORT

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:$HTTP_PORT/stat || exit 1

# USER nginx
ENTRYPOINT [ "/dockerrun.sh" ]
