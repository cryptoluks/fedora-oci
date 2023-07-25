ARG SRC

FROM "$SRC"

COPY build.sh /build.sh
COPY kernel-version-upstream.txt /kernel-version.txt

RUN chmod +x /build.sh && /build.sh
