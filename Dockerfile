# Use Google Cloud SDK base image (which has "gcloud" pre-installed)
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:latest

# Install Python 3 and pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Create a directory in the container for your code
WORKDIR /app

# Copy your requirements first
COPY requirements.txt .

# Install Apache Beam + GCP extras + any other deps
RUN pip3 install --no-cache-dir apache-beam[gcp] -r requirements.txt

# Copy the rest of your code into the container
COPY . /app

# (Optional) If you'd like to run "main.py" by default when this container starts
# ENTRYPOINT ["python3", "main.py"]
