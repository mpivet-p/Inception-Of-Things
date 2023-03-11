FROM python:3.10

RUN pip install flask waitress

WORKDIR /service/

COPY app.py .
COPY templates ./templates

EXPOSE 5000

CMD ["python", "app.py"]
