# Streaming Dataflow Pipeline with Alerting
This project is a real-time streaming data pipeline built using Apache Beam on Google Cloud Dataflow. It ingests user events from a Pub/Sub topic, filters for "purchase" events, aggregates counts by region and device within fixed windows, stores the results in BigQuery, and publishes alerts to a separate Pub/Sub topic if certain thresholds are met.

## Folder Structures
```
├── event_generation/
│   └── locustfile.py         # Simulates streaming events for testing
├── main.py                   # Main Beam pipeline script
├── run_pipeline.sh           # Shell script to trigger the pipeline
├── cloudbuild.yaml           # Cloud Build config for CI/CD
└── pipeline_config.json      # Optional config file for local development
```

## 🧪 Event Simulation
This project includes a simple Locust script (`event_generation/locustfile.py`) to simulate event traffic
### How to use
1. Install Locust if you haven't: `pip install locust`
2. Run Locust: `locust -f event_generation/locustfile.py`
3. Open the web UI at http://localhost:8089
4. Configure:
- Number of users to simulate
- Spawn rate
- Target host (e.g., your HTTP endpoint or your cloud run functions URL)
5. Start the test to simulate user event

## How to Run the Pipeline
1. Create 2 Pub/Sub Topics

    1.1 `streaming-events` for ingesting streaming events 

    1.2 `high-volume-alerts` for alerting when threshold breached

2. Create 2 Cloud Run Function

    2.1 Event receiver function: receives events from Locust (or any HTTP client) and publishes them to streaming-events.
    2.2 (Optional) Alert consumer function: subscribes to high-volume-alerts to handle or display alert messages to confirm that messages reach the high-volume-alerts topic. This is optional if you only want to verify message publication in Pub/Sub.

3. Create a dataset in BigQuery for storing aggregated purchase data 
4. Running Options:
    
    2.1 Run locally
      ```
      python main.py --runner=DirectRunner
      ```
   
    2.2 Deploy CI/CD Pipeline Using Cloud Build Trigger  
    Set up a Cloud Build Trigger to automatically deploy on new commits to your GitHub repo.
    🔧 **Steps to set it up:**
    
    1. Enable necessary API by going to the console or run a command 
        ```
        gcloud services enable dataflow.googleapis.com \
        artifactregistry.googleapis.com \
        cloudbuild.googleapis.com \
        pubsub.googleapis.com
        ```
    2. Create a Cloudbuild trigger
        
        1) Go to the GCP Console → **Cloud Build > Triggers**
        2) Click **"Create Trigger"**
        3) Under **Source**, connect your GitHub repo (you’ll need to authorize GitHub if it’s your first time)
        4) Choose your **branch** (e.g. `main`) or use a regex like `.*` to match all
        5) Set the **trigger type** to: `Build configuration file`  → use `cloudbuild.yaml` from the root of your repo
        6) Save the trigger.
 

## IAM Roles Required
Ensure your Dataflow service account (e.g., `<project-number>-compute@developer.gserviceaccount.com`) has these roles:
- `roles/dataflow.worker`: to run Dataflow jobs
- `roles/dataflow.admin`: to run Dataflow jobs
- `roles/pubsub.editor`: to enable dataflow to create subscription, publish and consume from Pub/Sub
- `roles/logs.writer`: to write logs in cloud
- `roles/dataflow.worker`: to run Dataflow jobs
- `roles/bigquery.dataEditor`: to write aggregated results to BigQuery
- `roles/storage.objectAdmin`: to create objects in temp-location and staging location
- `roles/artifactregistry.admin`: to create repo in Artifact Registry for storing dataflow template


## Alert Format (Pub/Sub Message)
```json
{
  "region": "th",
  "device": "mobile",
  "event_count": 112
}
```

### Notes:
- The event schema matches the one expected by the Dataflow pipeline
- You can modify the fields or event rate for different simulation scenarios
- This file is not used by the Dataflow pipeline itself and is safe to include in the same Git repo

