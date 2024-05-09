FROM ubuntu:18.04


RUN apt-get update \
  && apt-get -y install tesseract-ocr tesseract-ocr-eng tesseract-ocr-ara libtesseract-dev libleptonica-dev \
  && apt-get install -y python3 python3-distutils python3-pip \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 --no-cache-dir install --upgrade pip \
  && rm -rf /var/lib/apt/lists/*

RUN apt update \
  && apt-get install ffmpeg libsm6 libxext6 -y


COPY . /app
WORKDIR /app

RUN pip install -r requirements.txt
RUN pip3 install uvicorn python-multipart

EXPOSE 80

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
