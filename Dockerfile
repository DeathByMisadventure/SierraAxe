FROM debian:latest

LABEL maintainer="Jake Fortune" \
      version="0.1.0" \
      description="Sierra-Axe - RTMP Server, with HLS and DASH HTTP Streaming"


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
  rm -rf /var/lib/apt/lists/*

# Add NGINX path, config and static files.
ENV PATH="${PATH}:/usr/local/nginx/sbin"
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY static /www/static
COPY *.sh /
RUN mkdir -p /opt/data/d && \
  mkdir /opt/data/h && \
  chmod -R 755 /*.sh /www

EXPOSE $HTTP_PORT
EXPOSE $RTMP_PORT
SHELL ["/bin/bash", "-c"]

HEALTHCHECK --interval=1m --timeout=3s CMD ["/healthcheck.sh"]

ENTRYPOINT [ "/dockerrun.sh" ]
