# Multistage build - stage 1, builder
FROM python:3.10 AS builder
COPY requirements.txt .

RUN pip install --user -r requirements.txt

# Multistage build - stage 2, runner
FROM python:3.10-slim
WORKDIR /app

# Copying installation dependencies
COPY --from=builder /root/.local /root/.local

COPY ./src/*.py ./

# Adding /root/.local to PATH
ENV PATH=/root/.local:$PATH
ENV FLASK_APP=main.py
CMD [ "python", "-m", "flask", "run" ]