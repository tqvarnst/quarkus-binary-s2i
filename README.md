# [Quarkus.io](http://quarkus.io) Native Binary S2I

## OpenShift

### Minishift 8 GB Set-Up recommendation

    minishift profile delete quarkus
    minishift profile set quarkus
    minishift config set memory 8192
    minishift start

### OpenShift Build

    oc new-project quarkus-binary-build
    oc new-build quay.io/redhat/ubi-quarkus-native-binary-s2i --binary --name=myapp
    git clone https://github.com/quarkusio/quarkus-quickstarts.git
    cd quarkus-quickstarts/getting-started
    # On Linux
    mvn package -Pnative
    # On Mac OS X (requires Docker 4 Mac)
    mvn package -Pnative -Dnative-image.docker-build=true -DskipTests
    oc start-build myapp --from-file=target/quarkus-quickstart-1.0-SNAPSHOT-runner
    oc logs -f bc/myapp

### OpenShift Use

    oc new-app quarkus-native-s2i~https://github.com/quarkusio/quarkus-quickstarts --context-dir=getting-started --name=getting-started-native
    oc logs -f bc/getting-started-native
    oc expose svc/getting-started-native

Note that GraalVM-based native build are more memory & CPU intensive than regular pure Java builds.
[By default, builds are completed by pods using unbound resources, such as memory and CPU](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/advanced_build_operations.html),
but note that [your OpenShift Project may have limit ranges defined](https://docs.openshift.com/container-platform/3.11/admin_guide/limits.html#admin-guide-limits).

Testing indicates that the "hello, world" getting-started demo application builds in around 2 minutes on typical hardware when the build is given 4 GB of RAM and 4 (virtual) CPUs for concurrency. You therefore may need to increase the respective limits for OpenShift's S2I build containers like so:

    apiVersion: "v1"
    kind: "BuildConfig"
    metadata:
      name: "getting-started-native"
    spec:
      resources:
        limits:
          cpu: '4'
          memory: 4Gi

The following `oc patch` command does this:

    oc patch bc/getting-started-native -p '{"spec":{"resources":{"limits":{"cpu":"4", "memory":"4Gi"}}}}'

## Locally (only for testing)

### Local Build

    docker build . -t quarkus-native-s2i

### Local use

    sudo dnf install source-to-image

    s2i build --copy ../../../quarkus-quickstarts/getting-started quarkus-native-s2i getting-started-native

    docker run --rm -it -p 8080:8080 getting-started-native

    curl http://localhost:8080/hello/greeting/quarkus
# quarkus-binary-s2i
