FROM python:slim-bullseye

RUN pip install --upgrade pip \
    && pip install webdavclient3 influxdb

COPY app /app
CMD /app/gadgetbridge_to_influxdb.py
