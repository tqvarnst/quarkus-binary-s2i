# [Quarkus.io](http://quarkus.io) Native Binary S2I

### OpenShift Build

    oc new-project quarkus-binary-build
    oc new-build quay.io/redhat/quarkus-binary-s2i:latest --binary --name=myapp
    git clone https://github.com/quarkusio/quarkus-quickstarts.git
    cd quarkus-quickstarts/getting-started
    # On Linux RHEL
    mvn package -Pnative
    # On Mac OS X (requires Docker 4 Mac) or Fedora 30
    mvn package -Pnative -Dnative-image.docker-build=true -DskipTests
    oc start-build myapp --from-file=target/quarkus-quickstart-1.0-SNAPSHOT-runner
    oc logs -f bc/myapp

## Locally (only for testing)

### Local Build

    docker build . -t quarkus-native-s2i

### Local use

    sudo dnf install source-to-image

    s2i build --copy ../../../quarkus-quickstarts/getting-started quarkus-native-s2i getting-started-native

    docker run --rm -it -p 8080:8080 getting-started-native

    curl http://localhost:8080/hello/greeting/quarkus

