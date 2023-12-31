FROM alpine/git as core-lib
WORKDIR /
RUN git clone https://github.com/unitn-sml/recourse-fare.git && \
	cd recourse-fare &&\
	git checkout feature/add-w-fare


FROM python:3.7-slim-bullseye as deploy
WORKDIR /usr/local/app
RUN apt-get clean && \
	apt-get -y update

RUN apt-get -y install nginx &&\
	apt-get -y install build-essential


COPY --from=core-lib /recourse-fare ./recourse-fare
COPY ./requirements.txt ./requirements.txt
RUN	pip3 install -r requirements.txt && \
	cd recourse-fare && \
	#pip3 install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cu116 -e .
	pip3 install --no-cache-dir -e .
COPY . . 
COPY nginx.conf /etc/nginx
RUN chmod +x ./start.sh
EXPOSE 5000
ENV PYTHONPATH=.
# ENV FLASK_APP="server.py"
# CMD ["flask",  "run", "--host=0.0.0.0"]
CMD ["./start.sh"]