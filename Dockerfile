#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM registry.access.redhat.com/ubi9/python-311

USER 0

COPY requirements.txt .

RUN python -m venv .venv && \
	source .venv/bin/activate && \
	pip install --no-cache-dir -r requirements.txt

COPY . .

CMD
