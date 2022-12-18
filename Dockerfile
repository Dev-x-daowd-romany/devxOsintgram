FROM python:3.9.2-alpine3.13 as build
WORKDIR /wheels
RUN apk add --no-cache \
    ncurses-dev \
    build-base
COPY docker_reqs.txt /opt/devxOsintgram/requirements.txt
RUN pip3 wheel -r /opt/devxOsintgram/requirements.txt


FROM python:3.9.2-alpine3.13
WORKDIR /home/devxOsintgram
RUN adduser -D devxOsintgram

COPY --from=build /wheels /wheels
COPY --chown=devxOsintgram:devxOsintgram requirements.txt /home/devxOsintgram/
RUN pip3 install -r requirements.txt -f /wheels \
  && rm -rf /wheels \
  && rm -rf /root/.cache/pip/* \
  && rm requirements.txt

COPY --chown=devxOsintgram:devxOsintgram src/ /home/devxOsintgram/src
COPY --chown=devxOsintgram:devxOsintgram main.py /home/devxOsintgram/
COPY --chown=devxOsintgram:devxOsintgram config/ /home/devxOsintgram/config
USER devxOsintgram

ENTRYPOINT ["python", "main.py"]
