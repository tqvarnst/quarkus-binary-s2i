# [Quarkus.io](http://quarkus.io) *native* S2I builder
# Original Author: Thomas Qvarnstrom

# This shoud be update to a stable version of UBI when available
FROM registry.access.redhat.com/ubi8/ubi 

EXPOSE 8080

LABEL io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.s2i.destination="/opt/quarkus" \
      io.k8s.description="Quarkus.io S2I binary image for building UBI minimal images with native application using binary mode" \
      io.k8s.display-name="Quarkus.io S2I (UBI + Native image)" \
      io.openshift.tags="builder,java,quarkus,native"

# S2I scripts + README
COPY s2i /usr/local/s2i

ENV PATH=$PATH:"/usr/local/s2i"

RUN chmod 755 /usr/local/s2i/* && mkdir /opt/quarkus && chown -R 1001:0 /opt/quarkus \
    && chown -R 1001:0 $HOME && chmod -R ug+rwX /opt/quarkus

USER 1001

CMD $STI_SCRIPTS_PATH/usage
