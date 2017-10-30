FROM node:alpine
MAINTAINER Keiji Kobayashi <keiji.kobayashi.web@gmail.com>


ENV PATH /usr/local/texlive/2017/bin/x86_64-linux:$PATH


RUN    ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
    && ALPINE_GLIBC_PACKAGE_VERSION="2.26-r0" \
    && ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
    && ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
    && ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
    \
    && apk add --no-cache --virtual=.build-dependencies \
        wget ca-certificates \
    \
    && wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" \
    && wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \
    \
    && apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \
    \
    && rm "/etc/apk/keys/sgerrand.rsa.pub" \
    \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true \
    \
    && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh \
    \
    && apk del --no-cache \
        glibc-i18n \
        .build-dependencies \
    \
    && rm \
        "/root/.wget-hsts" \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \
    \
    \
    \
    \
    \
    && apk add --update --no-cache \
        perl \
    \
    && apk add --update --no-cache --virtual=.latex-dependencies \
        fontconfig-dev wget xz tar \
    \
    && mkdir /tmp/install-tl-unx \
    \
    && wget -qO- \
        http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C /tmp/install-tl-unx --strip-components=1 \
    \
    && printf "%s\n" \
        "selected_scheme scheme-basic" \
        "option_doc 0" \
        "option_src 0" \
        > /tmp/install-tl-unx/texlive.profile \
    \
    && /tmp/install-tl-unx/install-tl \
        --profile=/tmp/install-tl-unx/texlive.profile \
    \
    && tlmgr install \
        collection-basic collection-latex \
        collection-latexrecommended collection-latexextra \
        collection-fontsrecommended collection-langjapanese latexmk \
        epstopdf noto mweights \
    \
    && ( tlmgr install xetex || exit 0 ) \
    \
    && rm -fr /tmp/install-tl-unx \
    \
    && apk del --no-cache \
        .latex-dependencies \
    \
    \
    \
    \
    \
    && PLANTUML_DIR="/Library/Java/Extensions" \
    \
    && apk add --update --no-cache \
        make \
        python py-setuptools \
        openjdk8-jre graphviz ghostscript \
        zlib-dev jpeg-dev ttf-dejavu freetype-dev \
    \
    && apk add --update --no-cache --virtual=.sphinx-dependencies \
        bash git build-base fontconfig curl wget xz tar python-dev py-pip \
    \
    && mkdir -p $PLANTUML_DIR \
    \
    && wget \
        "https://sourceforge.net/projects/plantuml/files/plantuml.jar" \
        --no-check-certificate \
    \
    && mv plantuml.jar $PLANTUML_DIR \
    \
    && pip install --upgrade \
        sphinx \
        sphinx_rtd_theme \
        sphinxcontrib-plantuml \
        sphinxcontrib-blockdiag \
        commonmark==0.5.5 \
        recommonmark \
        reportlab \
    \
    && easy_install \
        blockdiag \
    \
    && apk del --no-cache \
        .sphinx-dependencies \
    \
    \
    \
    \
    \
    && apk add --update --no-cache \
        bash git grep jq make \
    \
    && apk add --update --no-cache --virtual=.node-dependencies \
        zlib-dev \
    \
    && npm cache verify \
    \
    && npm install --unsafe-perm --no-optional -g \
        pm2 bower \
        'github:gulpjs/gulp.git#4.0' gulp-shell gulp-cli \
        license-checker \
    \
    && apk del --no-cache \
        .node-dependencies \
    \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    \
    && mkdir -p /usr/local/lib/node_modules \
    \
    && ln -s /usr/lib/node_modules/gulp-shell /usr/local/lib/node_modules/gulp-shell \
    \
    \
    \
    \
    \
    && mkdir /app

CMD ["pm2", "--no-daemon"]
