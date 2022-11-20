FROM fedora

RUN dnf -y install pip && \
    pip install hvac && \
    mkdir /app && \
    useradd vault-client

ADD client.py /app
WORKDIR /app

ENV VAULT_URI http://vault:8200

USER vault-client
CMD python3 client.py