FROM openjdk:8-jre-slim

ENV NEO4J_SHA256=a33df85dbdd22297d5bc9962bd42f7e70c3703ba3067b1adeaf5c18240944f37 \
    NEO4J_TARBALL=neo4j-community-3.5.0-unix.tar.gz \
    NEO4J_HOME="/var/lib/neo4j" \
    NEO4J_EDITION=community \
    TINI_VERSION="v0.18.0" \
    TINI_SHA256="12d20136605531b09a2c2dac02ccee85e1b874eb322ef6baf7561cd93f93c855"
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-community-3.5.0-unix.tar.gz

RUN addgroup --system neo4j && adduser --system --no-create-home --home "${NEO4J_HOME}" --ingroup neo4j neo4j

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
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

ENV PATH "${NEO4J_HOME}"/bin:$PATH

RUN mkdir -p /home/db

## in openjdk docker image we cannot use git to clone repo
# get official docker entrypoint for neo4j
ADD https://raw.githubusercontent.com/neo4j/docker-neo4j/bb60e765ed91b1b78b1da30c9694d6d9089cf65d/docker-image-src/3.5/docker-entrypoint.sh \
    /home/db/db-docker-entrypoint.sh
RUN ["chmod", "+x", "/home/db/db-docker-entrypoint.sh"]

# get script to import database dump
ADD https://raw.githubusercontent.com/gkostkowski/cinema-web-app/master/neo4j-db/import_db_dump.sh \
    /home/db/import_db_dump.sh
RUN ["chmod", "+x", "/home/db/import_db_dump.sh"]
ADD https://raw.githubusercontent.com/gkostkowski/cinema-web-app/master/neo4j-db/cinema.cql \
    /home/db/cinema.cql

RUN touch /logs/debug.log && chmod a+x /logs/debug.log && chown -R neo4j:neo4j /logs
RUN chown neo4j:neo4j /sbin/tini

ENTRYPOINT ["/sbin/tini", "-g", "--", "/home/db/db-docker-entrypoint.sh"]
CMD ["neo4j", "start"]
