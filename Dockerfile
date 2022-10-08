FROM alpine:3.16 AS build
ARG ZT_VERSION

RUN apk add git linux-headers musl-dev musl-utils gcc g++ make tar

# Clone repo
RUN git clone -c 'advice.detachedHead=false' --depth=1 --branch ${ZT_VERSION} https://github.com/zerotier/ZeroTierOne.git zt

# Build
WORKDIR /zt
RUN make ZT_STATIC=1 ZT_SSO_SUPPORTED=0 one
RUN strip ./zerotier-cli

# Package
WORKDIR /zt/bin
RUN mv ../zerotier-one .
RUN ln -sf zerotier-one zerotier-idtool && ln -sf zerotier-one zerotier-cli

WORKDIR /zt/target
RUN tar -czf zerotier-one-$(uname -m).tar.gz -C /zt bin

# Finish
FROM scratch
COPY --from=build /zt/target/* /.