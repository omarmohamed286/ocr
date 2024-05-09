FROM ubuntu:18.04

RUN apt-get --fix-missing update && apt-get --fix-broken install && apt-get install -y poppler-utils tesseract-ocr libtesseract-dev libleptonica-dev ldconfig python3.9 python3-pip ffmpeg libsm6 libxext6

# Get language data
RUN apt-get install tesseract-ocr-eng tesseract-ocr-ara

WORKDIR /app

# Install app dependencies
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt uvicorn python-multipart

# Bundle app source
COPY . /app

EXPOSE 80
# Set the locale to C.UTF-8 for Python 3
ENV LANG C.UTF-8

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]