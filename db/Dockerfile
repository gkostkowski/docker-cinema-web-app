FROM openjdk:8-jre-slim

ENV NEO4J_SHA256=a33df85dbdd22297d5bc9962bd42f7e70c3703ba3067b1adeaf5c18240944f37 \
    NEO4J_TARBALL=neo4j-community-3.5.0-unix.tar.gz \
    NEO4J_HOME="/var/lib/neo4j" \
    NEO4J_EDITION=community \
    TINI_VERSION="v0.18.0" \
    TINI_SHA256="12d20136605531b09a2c2dac02ccee85e1b874eb322ef6baf7561cd93f93c855"
# ARG NEO4J_URI=%NEO4J_DIST_SITE%/%NEO4J_TARBALL%
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-community-3.5.0-unix.tar.gz

RUN addgroup --system neo4j && adduser --system --no-create-home --home "${NEO4J_HOME}" --ingroup neo4j neo4j

# COPY ./local-package/* /tmp/

RUN apt update \
    && apt install -y curl gosu jq \
    && curl -L --fail --silent --show-error "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" > /sbin/tini \
    && echo "${TINI_SHA256}  /sbin/tini" | sha256sum -c --strict --quiet \
    && chmod +x /sbin/tini \
    && curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum -c --strict --quiet \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* "${NEO4J_HOME}" \
    && rm ${NEO4J_TARBALL} \
    && mv "${NEO4J_HOME}"/data /data \
    && mv "${NEO4J_HOME}"/logs /logs \
    && chown -R neo4j:neo4j /data \
    && chmod -R 777 /data \
    && chown -R neo4j:neo4j /logs \
    && chmod -R 777 /logs \
    && chown -R neo4j:neo4j "${NEO4J_HOME}" \
    && chmod -R 777 "${NEO4J_HOME}" \
    && ln -s /data "${NEO4J_HOME}"/data \
    && ln -s /logs "${NEO4J_HOME}"/logs \
    # && mv /tmp/neo4jlabs-plugins.json /neo4jlabs-plugins.json \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

ENV PATH "${NEO4J_HOME}"/bin:$PATH

ADD https://raw.githubusercontent.com/neo4j/docker-neo4j/bb60e765ed91b1b78b1da30c9694d6d9089cf65d/docker-image-src/3.5/docker-entrypoint.sh /home/db/db-docker-entrypoint.sh

RUN ["chmod", "+x", "/home/db/db-docker-entrypoint.sh"]

RUN mkdir -p /home/db
WORKDIR mkdir /home/db
# RUN git clone https://github.com/gkostkowski/cinema-web-app.git \
	# && cd  cinema-web-app/neo4j-db \
ADD https://raw.githubusercontent.com/gkostkowski/cinema-web-app/master/neo4j-db/import_db_dump.sh ./import_db_dump.sh
ADD https://raw.githubusercontent.com/gkostkowski/cinema-web-app/master/neo4j-db/cinema.cql ./cinema.cql

ARG passwd

RUN chmod +x import_db_dump.sh
RUN neo4j start && sleep 10 \
	&& echo "CALL dbms.changePassword('"${passwd}"');" | /var/lib/neo4j/bin/cypher-shell -u neo4j -p neo4j \
	&& ./import_db_dump.sh cinema.cql neo4j ${passwd} \
	&& neo4j stop && sleep 60

# RUN ps aux | grep neo4j
# WORKDIR "${NEO4J_HOME}"

# VOLUME /data /logs

# COPY docker-entrypoint.sh /docker-entrypoint.sh

# EXPOSE 7474 7473 7687
RUN touch /logs/debug.log && chmod a+x /logs/debug.log && chown -R neo4j:neo4j /logs
RUN chown neo4j:neo4j /sbin/tini
RUN ls -l /logs
ENTRYPOINT ["/sbin/tini", "-g", "--", "/home/db/db-docker-entrypoint.sh", "neo4j"]
# ENTRYPOINT ["/sbin/tini", "-g", "--", "/home/db/db-docker-entrypoint.sh"]
# CMD ["neo4j"]
