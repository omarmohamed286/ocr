FROM ubuntu:latest




RUN apt-get update && apt-get install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-ara
RUN apt-get install libtesseract-dev libleptonica-dev && apt-get install -y python3.11 && apt-get install -y python3-pip


WORKDIR /app
COPY . /app



COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN pip install uvicorn
RUN pip install python-multipart




EXPOSE 80



# Set the locale to C.UTF-8 for Python 3
ENV LANG C.UTF-8



CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]