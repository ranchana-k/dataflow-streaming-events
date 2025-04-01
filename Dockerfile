# Use Beam’s official Python 3.10 SDK image
FROM apache/beam_python3.10_sdk:2.64.0

# Make a directory for your code
WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .

# Install your Python dependencies (including apache-beam[gcp], if not already in the image)
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your pipeline code
COPY . .

# Set environment variables required by the Flex Template launcher
ENV FLEX_TEMPLATE_PYTHON_PY_FILE="/app/main.py"
ENV FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE="/app/requirements.txt"

# This is the standard entrypoint that the Dataflow runner uses for Python Flex Templates
ENTRYPOINT [ "/opt/apache/beam/boot" ]
