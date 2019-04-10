FROM ubuntu:bionic

MAINTAINER Naftuli Kay <me@naftuli.wtf>

# bash functions
COPY usr/lib/bash/functions.sh /usr/lib/bash/functions.sh

# build scripts
COPY etc/build.d /etc/build.d/

# coredns
COPY etc/coredns/Corefile /etc/coredns/Corefile

# ssh
COPY etc/ssh/sshd_config /etc/ssh/sshd_config

# sudoers
COPY etc/sudoers.d/naftuli /etc/sudoers.d/naftuli

# wireguard
COPY etc/sysctl.d/wireguard.conf /etc/sysctl.d/wireguard.conf

# runit
COPY etc/service/coredns/run /etc/service/coredns/run
COPY etc/service/boringtun/run /etc/service/boringtun/run
COPY etc/service/sshd/run /etc/service/sshd/run
RUN find /etc/service -type f -name run -exec chmod 0700 {} \;

# entrypoint
COPY usr/bin/entrypoint /usr/bin/entrypoint

# call build scripts
RUN set -e ; echo "Executing build scripts..." >&2 ; \
  find /etc/build.d -type f -executable | sort -u | while read build_script ; do \
    if ! ${build_script} ; then \
      echo "${build_script} encountered a failure." ; \
      exit 1 ; \
    fi ; \
  done

# user configs
RUN mkdir -p /home/naftuli/.config/nvim
COPY home/naftuli/.config/nvim/init.vim /home/naftuli/.config/nvim/init.vim
COPY home/naftuli/.tmux.conf /home/naftuli/.tmux.conf
RUN chown -R naftuli:naftuli /home/naftuli

# boot scripts
COPY etc/boot.d etc/boot.d/

ENTRYPOINT ["/usr/bin/entrypoint"]
