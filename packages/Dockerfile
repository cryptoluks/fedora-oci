ARG SRC

FROM "${SRC}" as builder

ARG RPMDIR=/var/cache/rpms
ARG AKMODSDIR=/var/cache/akmods
ARG BUILDDIR=/build

COPY build "${BUILDDIR}"
RUN chmod +x "${BUILDDIR}"/build.sh && cd "${BUILDDIR}" && ./build.sh && \
    mkdir -p "${RPMDIR}" && find "${AKMODSDIR}" "${BUILDDIR}" -type f -name '*.x86_64.rpm' -exec cp {} "${RPMDIR}" \; && \
    find "${RPMDIR}"

FROM scratch

ARG RPMDIR=/var/cache/rpms
ARG RPMDIR_TARGET=/rpms

COPY --from=builder "${RPMDIR}" "${RPMDIR_TARGET}"
