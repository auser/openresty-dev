build:
	docker build -t resty-dev .


VOLUMES:=-v ${CURDIR}/src:/usr/local/openresty/nginx/lualib -v ${CURDIR}/priv/conf:/usr/local/openresty/nginx/conf -v ${CURDIR}/priv/sites-enabled:/usr/local/openresty/nginx/sites-enabled

dev:
	docker run --rm -it ${VOLUMES} -p 8080:80 resty-dev

sh:
	docker run --rm -it -v ${CURDIR}/src:/usr/local/openresty/nginx/lualib -v ${CURDIR}/priv/conf:/usr/local/openresty/nginx/conf -v ${CURDIR}/priv/sites-enabled:/usr/local/openresty/nginx/sites-enabled -p 8080:80 --entrypoint /bin/sh resty-dev

run:
	docker run --rm -it -v ${CURDIR}/lualib:/usr/local/openresty/nginx/lualib -p 8080:80 resty-dev

test_build:
	docker build -t resty-test --rm --file Dockerfile.test .

test:
	docker run --rm -it ${VOLUMES} -v ${CURDIR}/tests/:/root/ resty-test