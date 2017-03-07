FROM ubuntu:16.04

RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get -y install --force-yes \
        curl make git expect libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
        python-dev python-pip stunnel \
        g++-multilib openjdk-9-jre psmisc unzip cmake

# Install buildbot and prep it to run
RUN pip install buildbot-slave
RUN groupadd -r rustbuild && useradd -r -g rustbuild rustbuild
RUN mkdir /buildslave && chown rustbuild:rustbuild /buildslave

RUN mkdir /android && chown rustbuild:rustbuild /android
RUN mkdir /home/rustbuild && chown rustbuild:rustbuild /home/rustbuild

WORKDIR /android
USER rustbuild

COPY android/*.sh /android/

# Setup PATH to allow running android tools.
ENV PATH=$PATH:/android/ndk-arm/bin:/android/ndk-aarch64/bin:/android/ndk-x86/bin:/android/sdk/tools:/android/sdk/platform-tools

RUN sh install-ndk.sh
RUN sh install-sdk.sh
RUN rm *.sh

# Setup SHELL so android can detect a 64bits system, see
# http://stackoverflow.com/a/41789144
# https://issues.jenkins-ci.org/browse/JENKINS-26930?focusedCommentId=230791&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-230791
ENV SHELL /bin/dash

# When running this container, startup buildbot
WORKDIR /buildslave
COPY start-docker-slave.sh start-docker-slave.sh
ENTRYPOINT ["sh", "start-docker-slave.sh"]
