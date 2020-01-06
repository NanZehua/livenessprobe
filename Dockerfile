# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.12.4 as builder

ARG DIR=$GOPATH/src/github.com/kubernetes-csi/livenessprobe

WORKDIR $DIR

COPY / $DIR

ENV GO111MODULE=on

ENV GOPROXY=https://goproxy.io

# multi-stage build cache, if go.mod go.sum change build again
RUN go mod download

RUN CGO_ENABLED=0 go build -o csi-livenessprobe -ldflags '-s -w' -v $DIR/cmd/livenessprobe

FROM alpine:3.9

# RUN apk add --no-cache bash

WORKDIR /bin/

ENTRYPOINT ["/bin/csi-livenessprobe"]

COPY --from=builder /go/src/github.com/kubernetes-csi/livenessprobe/csi-livenessprobe /bin/csi-livenessprobe
