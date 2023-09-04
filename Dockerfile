# start by pulling the python image
FROM --platform=$TARGETPLATFORM python:3.8-alpine as buildenv

COPY requirements.txt requirements.txt ./
RUN --mount=type=cache,target=/root/.cache \
	apk update && \
	apk add --upgrade \
		build-base \
		ca-certificates \
		curl \
		freetype-dev \
		g++ \
		jpeg-dev \
		lapack-dev \
		less \
		libgcc \
		libgfortran \
		libgomp \
		libpng-dev \
		make \
		musl \
		openblas-dev \
		openssl \
		rsync \
		wget \
		zlib-dev && \
	pip install --upgrade pip wheel && \
	pip install -r requirements.txt && \
	cp -r /root/.cache /cache

# Build the final image.
FROM --platform=$TARGETPLATFORM python:3.8-alpine3.13 as image

COPY --from=buildenv /cache /root/.cache

COPY requirements.txt requirements.txt ./



# install the dependencies and packages in the requirements file
RUN apk update && \
	apk add --upgrade \
		lapack \
		libgomp \
		libjpeg \
		libstdc++ \
		openblas && \
	pip install --upgrade pip wheel && \
	pip install -r requirements.txt && \
	rm -f requirements.txt && \
	rm -rf /root/.cache && \
	rm -rf /var/cache
# switch working directory
WORKDIR /app
# copy every content from the local file to the image
COPY . /app

# configure the container to run in an executed manner
ENTRYPOINT [ "python" ]

CMD ["main.py" ]