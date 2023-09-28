ZT_VERSION ?= 1.12.2

BUILDX_BUILDER ?= zerotier-builder
PLATFORM ?= linux/amd64
BUILDX_OPTS ?= --builder=$(BUILDX_BUILDER) --platform=$(PLATFORM) --build-arg ZT_VERSION=$(ZT_VERSION) --output=out 

one: create-builder
	docker buildx build $(BUILDX_OPTS) .

create-builder:
	docker buildx inspect $(BUILDX_BUILDER) >/dev/null 2<&1 || docker buildx create --name=$(BUILDX_BUILDER) >/dev/null

install:
	cd out && tar -xzf zerotier-one-$(shell uname -m).tar.gz
	install out/bin/* /bin

clean:
	rm -rf out
