.PHONY: install run

VENV := .venv
PYTHON := python3
PORT := 8081
HOST := 0.0.0.0

$(VENV)/bin/python:
	$(PYTHON) -m venv $(VENV)
	$(VENV)/bin/pip install --upgrade pip
	$(VENV)/bin/pip install -r requirements.txt

install: $(VENV)/bin/python

run: install
	$(VENV)/bin/uvicorn app.main:app --reload --host $(HOST) --port $(PORT)
