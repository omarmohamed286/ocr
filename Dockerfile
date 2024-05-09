FROM python:3.9




RUN apt-get update && apt-get install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-ara libtesseract-dev libleptonica-dev pip


WORKDIR /app
COPY . /app



COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install uvicorn
RUN pip install python-multipart




EXPOSE 80



# Set the locale to C.UTF-8 for Python 3
ENV LANG C.UTF-8



CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]