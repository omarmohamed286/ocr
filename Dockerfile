FROM ubuntu:18.04

# Skip the configuration part
ENV DEBIAN_FRONTEND noninteractive

# Update and install depedencies
RUN apt-get update && \
    apt-get install -y wget unzip bc vim python3-pip libleptonica-dev git

# Packages to complie Tesseract
RUN apt-get install -y --reinstall make && \
    apt-get install -y g++ autoconf automake libtool pkg-config libpng-dev libjpeg8-dev libtiff5-dev libicu-dev \
        libpango1.0-dev autoconf-archive

# Set working directory
WORKDIR /app

# Copy requirements into the container at /app
COPY requirements.txt ./

RUN mkdir src && cd /app/src && \
    wget https://github.com/tesseract-ocr/tesseract/archive/4.1.0.zip && \
	unzip 4.1.0.zip && \
    cd /app/src/tesseract-4.1.0 && ./autogen.sh && ./configure && make && make install && ldconfig && \
    make training && make training-install && \
    cd /usr/local/share/tessdata && wget https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata

# Setting the data prefix
ENV TESSDATA_PREFIX=/usr/local/share/tessdata

# Install libraries using pip installer
RUN pip3 install -r requirements.txt
RUN pip install uvicorn
RUN pip install python-multipart

EXPOSE 80
# Set the locale
RUN apt-get install -y locales && locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
