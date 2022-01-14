FROM google/cloud-sdk:slim
WORKDIR /opt/wowless

COPY setup.sh ./
RUN bash setup.sh

COPY nginx.conf query.sh run.sh wowless.lua ./
ENTRYPOINT ["bash", "run.sh"]
