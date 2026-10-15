# MLOps Student Result Predictor

A demonstration Flask + scikit-learn app for the MLOps practical assessment.

## Run locally

```bash
python -m pip install -r requirements.txt
python train.py
python app.py
```

Open http://127.0.0.1:5000.

## Run with Docker

```bash
docker build -t student-app .
docker run -d --name student-app -p 5000:5000 student-app
```

Open http://127.0.0.1:5000.

## Automatic deployment

1. Push this repository to a public GitHub repository on the `main` branch.
2. Launch an Ubuntu EC2 instance with Docker installed, an attached EC2 CodeDeploy IAM role, and inbound TCP ports 22 (restricted to your IP) and 80.
3. Install and start the CodeDeploy agent on the instance.
4. Create a CodeDeploy EC2/On-Premises application and deployment group targeting the instance.
5. Create a CodePipeline with GitHub as Source and CodeDeploy as Deploy; skip Build.
6. Ensure the CodePipeline service role can access the GitHub connection and invoke CodeDeploy.
7. Commit a change to `MODEL_VERSION = "2.0"` in `app.py`. The pipeline should deploy it automatically.

## Important

- `appspec.yml` and deployment scripts are included.
- The deploy script builds the Docker image on EC2 and maps port 80 to Flask port 5000.
- This uses synthetic demonstration data only. Do not use it for real student grading.
- AWS resources may incur charges. Remove resources after evaluation.
