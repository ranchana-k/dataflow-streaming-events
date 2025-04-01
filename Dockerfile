# Use Google Cloud SDK base image (which has "gcloud" pre-installed)
FROM python:3.10-slim


# Create a directory in the container for your code
WORKDIR /app

# Copy your requirements first
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

# (Optional) If you'd like to run "main.py" by default when this container starts
# ENTRYPOINT ["python3", "main.py"]
