ARG SRC

FROM "$SRC" as builder

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG RPMDIR=/var/cache/rpms
ARG AKMODSDIR=/var/cache/akmods
ARG BUILDDIR=/build

COPY build "$BUILDDIR"

RUN <<-EOF
    chmod +x "$BUILDDIR"/build.sh && cd "$BUILDDIR" && ./build.sh
    mkdir -p "$RPMDIR" && find "$AKMODSDIR" "$BUILDDIR" -type f -name '*.x86_64.rpm' -exec cp {} "$RPMDIR" \;
    find "$RPMDIR"
EOF

FROM scratch

ARG RPMDIR=/var/cache/rpms
ARG RPMDIR_TARGET=/rpms

COPY --from=builder "$RPMDIR" "$RPMDIR_TARGET"