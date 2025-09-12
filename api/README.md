## Gcloud deploy api 

- [Source](/cloudbuild.yaml)

### 1. Login gcloud

```bash
gcloud auth login
```

### 2. Deploy api

**Project nmae in cloud: lottocat**

```bash
gcloud run deploy --source .
```

### List project secret

```bash
gcloud secrets list
```

## Gcloud secret setup

### 1. Create Secrets for Database

```bash
echo -n "db_host" | gcloud secrets create db-host --data-file=-
echo -n "db_username" | gcloud secrets create db-username --data-file=-
echo -n "db_password" | gcloud secrets create db-password --data-file=-
echo -n "db_name" | gcloud secrets create db-name --data-file=-
```

### 2. Create JWT Secrets

```bash
echo -n "your_jwt_secret_key" | gcloud secrets create JWT_SECRET --data-file=-
echo -n "7d" | gcloud secrets create JWT_EXPIRE_IN --data-file=-
echo -n "false" | gcloud secrets create IS_SIGN --data-file=-
```

### 3. Grant Access to Cloud Build Service Account

```bash
PROJECT_NUMBER=$(gcloud projects describe lottocat --format="value(projectNumber)")

SERVICE_ACCOUNT="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

gcloud secrets add-iam-policy-binding db-host \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding db-username \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding db-password \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding db-name \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding JWT_SECRET \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding JWT_EXPIRE_IN \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding IS_SIGN \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor"
```

### 4. List All Secrets

```bash
gcloud secrets list
```

## Google Cloud Storage setup

### 1. Create Storage Bucket

```bash
BUCKET_NAME="lottocat_bucket"
gcloud storage buckets create gs://${BUCKET_NAME} \
  --location=asia-southeast1 \
  --uniform-bucket-level-access
```

### 2. Grant Access to Cloud Build Service Account

```bash
PROJECT_NUMBER=$(gcloud projects describe lottocat --format="value(projectNumber)")

SERVICE_ACCOUNT="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

gcloud storage buckets add-iam-policy-binding gs://${BUCKET_NAME} \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/storage.objectAdmin"
```

### 3. Enable Public Access (Optional - for serving uploaded images)

```bash
gcloud storage buckets add-iam-policy-binding gs://${BUCKET_NAME} \
  --member="allUsers" \
  --role="roles/storage.objectViewer"
```

### 4. Configure CORS (for web applications)

Create a CORS configuration file `cors-config.json`:

```json
[
  {
    "origin": ["*"],
    "method": ["GET", "POST", "PUT", "DELETE"],
    "responseHeader": ["Content-Type"],
    "maxAgeSeconds": 3600
  }
]
```

Apply CORS configuration:

```bash
gcloud storage buckets update gs://${BUCKET_NAME} --cors-file=cors-config.json
```

### 5. Verify Bucket Setup

```bash
gcloud storage buckets list
echo "test" | gcloud storage cp - gs://${BUCKET_NAME}/test.txt
gcloud storage ls gs://${BUCKET_NAME}
```

## Environment Configuration

### Development Environment

For local development, use `.env` file:

```env
DB_HOST=db_host
DB_USERNAME=db_username
DB_PASSWORD=db_password
DB_NAME=db_name
JWT_SECRET=JWT_SECRET
JWT_EXPIRE_IN=JWT_EXPIRE_IN
IS_SIGN=IS_SIGN
UPLOAD_TO_GCS=false
```

### Production Environment

Production uses Google Cloud Secrets Manager:

- `UPLOAD_TO_GCS=true` enables GCS upload
- Database and JWT secrets are managed via Google Cloud Secrets Manager
- Files are uploaded to both local storage and GCS

### Running in Different Environments

**Development (Local):** 
```bash
npm run start
# or
docker-compose -f docker-compose.dev.yml up
```

**Production:**
```bash
docker-compose up
```

## Troubleshooting

```bash
gcloud iam service-accounts get-iam-policy ${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com

gcloud secrets versions list SECRET_NAME

gcloud storage buckets get-iam-policy gs://lottocat_bucket
```


