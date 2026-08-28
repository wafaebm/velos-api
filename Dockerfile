FROM python:3.12-slim AS builder

WORKDIR /install

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim AS test

WORKDIR /app

COPY --from=builder /install /usr/local
RUN pip install --no-cache-dir pytest

COPY app.py .
COPY tests/ tests/

RUN python -m pytest -q

FROM python:3.12-slim AS runtime

WORKDIR /app

RUN useradd --create-home --uid 1001 appli

COPY --from=builder /install /usr/local
COPY app.py .

ENV PORT=8000

EXPOSE 8000

USER 1001

CMD ["python", "app.py"]
