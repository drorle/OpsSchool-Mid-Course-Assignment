FROM ubuntu:latest
MAINTAINER Dror Levin "drorle@gmail.com"

RUN apt-get update && \
    apt-get install -y python

ADD https://raw.githubusercontent.com/ops-school/session-monitoring/master/training_session/my_dummy_exporter.py /root
RUN chmod 755 /root/my_dummy_exporter.py
ENTRYPOINT ["/root/my_dummy_exporter.py"]

EXPOSE 65433

