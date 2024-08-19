FROM debian:bookworm

EXPOSE 22

WORKDIR /app

COPY ./user_provisioning.sh ./upload_users_to_vault.sh ./start.sh . 

RUN apt-get update && \
    apt-get install -y --no-install-recommends pwgen vim openssh-server curl jq && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /app/user_provisioning.sh && \
    chmod +x /app/upload_users_to_vault.sh && \
    chmod +x /app/start.sh && \
    /bin/bash /app/user_provisioning.sh

CMD ["/app/start.sh"]
