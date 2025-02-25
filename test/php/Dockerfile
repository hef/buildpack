ARG IMAGE=containerbase/buildpack
FROM ${IMAGE} as base

RUN touch /.dummy

WORKDIR /tmp

COPY --chown=1000:0 test test

#--------------------------------------
# test: php 7.4
#--------------------------------------
FROM base as testa

# old php version, not for renovating
RUN install-tool php 7.4.14

# old composer version, not for renovating
RUN install-tool composer 1.10.20

USER 1000

RUN set -ex; \
  [ ! -z "$(command -v php)" ] && echo "php installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("mbstring") ? 0 : 1);') && echo "php-mbstring installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("curl") ? 0 : 1);') && echo "php-curl installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("xml") ? 0 : 1);') && echo "php-xml installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("json") ? 0 : 1);') && echo "php-json installed" || exit 1;

RUN php --version
RUN composer --version


RUN set -ex; \
  cd test/a; \
  composer install --no-ansi --no-interaction

#--------------------------------------
# test: php 5.6
#--------------------------------------
FROM base as testb

# old php version, not for renovating
RUN install-tool php 5.6.40

# old composer version, not for renovating
RUN install-tool composer 1.10.20

USER 1000

RUN set -ex; \
  [ ! -z "$(command -v php)" ] && echo "php installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("mbstring") ? 0 : 1);') && echo "php-mbstring installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("curl") ? 0 : 1);') && echo "php-curl installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("xml") ? 0 : 1);') && echo "php-xml installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("json") ? 0 : 1);') && echo "php-json installed" || exit 1;

RUN php --version
RUN composer --version

#--------------------------------------
# test: php 8.0
#--------------------------------------
FROM base as testc

# no auto env for testing
SHELL [ "/bin/sh", "-c" ]

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 8.0.6

USER 1000

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.0.13

RUN install-tool composer latest

RUN set -ex; \
  [ ! -z "$(command -v php)" ] && echo "php installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("mbstring") ? 0 : 1);') && echo "php-mbstring installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("curl") ? 0 : 1);') && echo "php-curl installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("xml") ? 0 : 1);') && echo "php-xml installed" || exit 1;

RUN set -ex; \
  $(php -r 'exit(extension_loaded("json") ? 0 : 1);') && echo "php-json installed" || exit 1;

RUN php --version
RUN composer --version

#--------------------------------------
# final
#--------------------------------------
FROM base

COPY --from=testa /.dummy /.dummy
COPY --from=testb /.dummy /.dummy
COPY --from=testc /.dummy /.dummy
