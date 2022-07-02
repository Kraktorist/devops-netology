ARG  DOCKER_REGISTRY_ID
FROM cr.yandex/${DOCKER_REGISTRY_ID}/python37
WORKDIR /python_api
COPY ./source/* ./
RUN pip3 install -r requirements.txt && rm -rf requirements.txt
ENTRYPOINT ["python3.7", "/python_api/python-api.py"]
