FROM centos:7
ENV ES_HOME="/var/lib/elasticsearch"
RUN export ES_HOME="/var/lib/elasticsearch" && \
    curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.0-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-8.0.0-linux-x86_64.tar.gz && \
    rm -rf elasticsearch-8.0.0-linux-x86_64.tar.gz && \
    mv /elasticsearch-8.0.0 ${ES_HOME} && \
    echo -e "-Xms4g\n-Xmx4g">${ES_HOME}/config/jvm.options.d/default.options && \ 
    echo "node.name: netology_test">>${ES_HOME}/config/elasticsearch.yml && \
    adduser --system --shell=/bin/false --no-create-home elasticsearch && \
    chown -R elasticsearch:elasticsearch ${ES_HOME}

WORKDIR ${ES_HOME}
USER elasticsearch
EXPOSE 9200 9300

CMD [ "sh", "-c", "${ES_HOME}/bin/elasticsearch" ]
