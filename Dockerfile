FROM python:3.11-alpine3.24

LABEL org.opencontainers.image.description="Deltadore Tydom to MQTT Bridge"
LABEL org.opencontainers.image.source="https://github.com/skandass/tydom2mqtt"

# Don't buffer stdout/stderr and don't write .pyc files
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# App base dir
WORKDIR /app

# Install dependencies first to leverage Docker layer caching
COPY app/requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app/ .

# NOTE: Home Assistant add-ons must run as root. The Supervisor mounts /data
# and writes /data/options.json as root; a non-root USER causes a startup
# crash: PermissionError [Errno 13] Permission denied: /data/options.json

# Main command
CMD [ "python", "-u", "main.py" ]
