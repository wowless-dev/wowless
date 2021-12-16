FROM python:3.10-buster
WORKDIR /opt/wowless

COPY setup.sh ./
RUN bash setup.sh

COPY nginx.conf query.sh run.sh wowless.lua ./
CMD ["tini", "--", "bash", "run.sh"]
