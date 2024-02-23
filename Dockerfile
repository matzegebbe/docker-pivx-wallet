FROM debian:bullseye-slim

ENV PIVX_VERSION=5.6.1
ENV PIVX_USER=pivx
ENV PIVX_URL=https://github.com/PIVX-Project/PIVX/releases/download/v${PIVX_VERSION}/pivx-${PIVX_VERSION}-x86_64-linux-gnu.tar.gz
ENV PIVX_CONF=/home/$PIVX_USER/.pivx/pivx.conf

RUN apt-get -qq update && \
apt-get install -yq wget ca-certificates pwgen && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
wget $PIVX_URL -O /tmp/pivx.tar.gz && \
mkdir -p /opt && \
cd /opt && \
tar xvzf /tmp/pivx.tar.gz && \
rm /tmp/pivx.tar.gz && \
ln -sf pivx-$PIVX_VERSION pivx && \
ln -sf /opt/pivx/bin/pivxd /usr/local/bin/pivxd && \
ln -sf /opt/pivx/bin/pivx-cli /usr/local/bin/pivx-cli && \
ln -sf /opt/pivx/bin/pivx-tx /usr/local/bin/pivx-tx && \
adduser --uid 1000 --system ${PIVX_USER} && \
mkdir -p /home/${PIVX_USER}/.pivx/ && \
mkdir -p /home/${PIVX_USER}/.pivx-params/ && \
cp /opt/pivx/share/pivx/* /home/${PIVX_USER}/.pivx-params/ && \
chown -R ${PIVX_USER} /home/${PIVX_USER} && \
echo "success: $PIVX_CONF"

USER pivx

RUN echo "rpcuser=pivx" > ${PIVX_CONF} && \
        echo "rpcpassword=`pwgen 32 1`" >> ${PIVX_CONF} && \
        echo "Success"

EXPOSE 51472
VOLUME ["/home/pivx/.pivx"]
WORKDIR /home/pivx

ENTRYPOINT ["/usr/local/bin/pivxd"]
