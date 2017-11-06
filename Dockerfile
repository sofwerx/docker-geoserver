FROM java:8

ENV JAVA_OPTS -Xms128m -Xmx512m -XX:MaxPermSize=512m
ENV ADMIN_PASSWD geoserver

ENV GEOSERVER_VERSION 2.12.0
RUN apt-get update && \
    apt-get install -qqy unzip wget bash && \
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip \
         -O /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip -d /opt && \
    rm -f /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip && \
    cd /opt && \
    ln -s geoserver-${GEOSERVER_VERSION} geoserver

RUN set -ex && \
  for plugin in excel feature-pregeneralized gdal grib h2 imagemap imagemosaic-jdbc importer-bdb importer inspire jp2k monitor monitor-hibernate mysql netcdf-out netcdf ogr-wfs ogr-wps oracle printing pyramid querylayer sqlserver teradata vectortiles wcs2_0-eo wps-cluster-hazelcast wps xslt ysld app-schema arcsde cas charts control-flow css csw db2 dxf ; do \
    wget -c https://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-${plugin}-plugin.zip \
         -O /opt/geoserver-${GEOSERVER_VERSION}-${plugin}-plugin.zip && \
    unzip -o /opt/geoserver-${GEOSERVER_VERSION}-${plugin}-plugin.zip -d /opt/geoserver-${GEOSERVER_VERSION}/webapps/geoserver/WEB-INF/lib ; \
  done 

ADD run.sh /run.sh

VOLUME /opt/geoserver/data_dir

CMD /run.sh

EXPOSE 8080

