FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# RUN useradd --disabled-password --uid ${UID} ${USER}
# RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# USER ${USER}

RUN apt-get install -y git curl vim build-essential
#  libz-dev
# RUN apt-get install -y pkg-config

# deps for crystal
# RUN apt-get install -y \
#   automake \
#   build-essential \
#   git \
#   libbsd-dev \
#   libedit-dev \
#   libevent-dev \
#   libgmp-dev \
#   libgmpxx4ldbl \
#   libpcre3-dev \
#   libssl-dev \
#   libtool \
#   libxml2-dev \
#   libyaml-dev \
#   lld \
#   llvm \
#   llvm-dev\
#   libz-dev

# deps for erlang
RUN sudo apt -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk

# RUN apt-get install -y \
#     build-essential \
#     autoconf \
#     m4 \
#     libncurses5-dev \
#     libwxgtk3.0-gtk3-dev \
#     libgl1-mesa-dev \
#     libglu1-mesa-dev \
#     libpng-dev \
#     libssh-dev \
#     unixodbc-dev \
#     xsltproc \
#     fop \
#     libxml2-utils \
#     libncurses-dev \
#     openjdk-11-jdk

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1

RUN echo ". \"\$HOME/.asdf/asdf.sh\"" >> ~/.bashrc
RUN echo ". \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bashrc

ENV PATH="/root/.asdf/shims:/root/.asdf/bin:${PATH}"

# Old 7 langs.


# New 7 langs.

# install rust v1.81.0
run asdf plugin add rust && \
    asdf install rust 1.81.0 && \
    asdf global rust 1.81.0

# install golang v1.23.1
RUN asdf plugin add golang && \
    asdf install golang 1.23.1 && \
    asdf global golang 1.23.1

# # install crystal v1.13.3
# RUN asdf plugin-add crystal && \
#     # asdf crystal install-deps && \
#     asdf install crystal 1.13.3 && \
#     asdf global crystal 1.13.3

# install nim v2.0.8
RUN asdf plugin-add nim && \
    asdf nim install-deps -y && \
    asdf install nim 2.0.8 && \
    asdf global nim 2.0.8

# install erlang v25.3.2.14
RUN asdf plugin add erlang && \
    asdf install erlang 25.3.2.14 && \
    asdf global erlang 25.3.2.14

# install gleam v1.5.1(erlang should be installed in advance)
RUN asdf plugin add gleam && \
    asdf install gleam 1.5.1 && \
    asdf global gleam 1.5.1

# install haskell v9.10.1
RUN asdf plugin add haskell && \
    asdf install haskell 9.10.1 && \
    asdf global haskell 9.10.1

# install koka v3.1.2(haskell should be installed in advance)
# NOTE: asdf installation didn't go well.
RUN curl -sSL https://github.com/koka-lang/koka/releases/download/v3.1.2/install.sh | sh

RUN asdf plugin-add nodejs && \
    asdf install nodejs 22.9.0 && \
    asdf global nodejs 22.9.0

WORKDIR /workspace