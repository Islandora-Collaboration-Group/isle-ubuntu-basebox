## Used for local building and testing during development.

DATE_RFC3339=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
VERSION_DATE=`date -u +"%Y%m%dT%H%M%SZ"`
S6_OVERLAY_VERSION=1.21.4.0
JAVA_VERSION=8u181
JAVA_BUILD=b13
JAVA_SECURITY_BUILD=1.8.0_181
VERSION ?= RC-$(DATE_RFC3339)
TAG ?= RC-$(VERSION_DATE)

docker_build:
	@docker build \
	--build-arg BUILD_DATE=$(DATE_RFC3339) \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg VERSION=$(VERSION) \
	--build-arg S6_OVERLAY_VERSION=$(S6_OVERLAY_VERSION) \
	--build-arg JAVA_VERSION=$(JAVA_VERSION) \
	--build-arg JAVA_BUILD=$(JAVA_BUILD) \
	--build-arg JAVA_SECURITY_BUILD=$(JAVA_SECURITY_BUILD) \
	--tag isle-ubuntu-basebox:$(TAG) .

default: docker_build