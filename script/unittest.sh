#!/bin/sh

PACKAGES=`go list ./pkg/polardb-fc/... | grep -v /mocks | grep -v /fakes`

echo "" > coverage.out
echo "mode: set" > coverage-all.out

for pkg in ${PACKAGES}; do
  go test -coverpkg=./pkg/polardb-fc/... -coverprofile=coverage.out -covermode=set ${pkg} || TEST_FAILED=1;
  tail -n +2 coverage.out | grep -v /mocks | grep -v /fakes >> coverage-all.out;
done;

if [ "$TEST_FAILED" -eq "0" ]; then
  go tool cover -func=coverage-all.out | grep total
else
  exit 1
fi
