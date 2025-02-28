ARG BASE_VERSION=staging
ARG ROBOT_PLATFORM=hunter_platform

ARG BASE_IMAGE=lcas.lincoln.ac.uk/lcas/aoc_strawberry_scenario:${ROBOT_PLATFORM}-${BASE_VERSION}

FROM ${BASE_IMAGE} AS base
ARG BASE_IMAGE

# make sure again that it's writeable
LABEL org.opencontainers.image.base_image=${BASE_IMAGE}
LABEL org.opencontainers.image.source="devcontainer.dockerfile"

# set to domain id 1 as a default
ENV ROS_DOMAIN_ID=1

CMD ["/bin/sh", "-c", "while sleep 1000; do :; done"]
