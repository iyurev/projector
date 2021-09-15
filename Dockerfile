FROM  registry.jetbrains.team/p/prj/containers/projector-goland@sha256:6d57dfaa322b1bdd9daf5d67e93805cb914dec2218de12c80c58ac0df0104143

ENV GO_DIST_MIRROR=https://dl.google.com/go/
ENV GO_DIST_NAME=go1.17.1.linux-amd64.tar.gz

USER 0

RUN apt update && \
    apt -y  install curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt

RUN cd /tmp && curl -L -O $GO_DIST_MIRROR/$GO_DIST_NAME && rm -rf /usr/local/go && tar -C /usr/local -xzf $GO_DIST_NAME && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && rm -f $GO_DIST_NAME

RUN cd /tmp && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

RUN  cd /tmp && curl -O https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz  && tar -xzf oc.tar.gz && chmod +x ./oc && mv ./oc /usr/local/bin


USER 1000
