## Gcloud deploy api 

### 1. Login gcloud

```bash
gcloud auth login
```

### 2. Deploy api

**Project nmae in cloud: lottocat**

```bash
gcloud run deploy --source .
```

```bash
 gcloud run deploy lottocat --source . --platform managed --region us-central1 --allow-unauthenticated
```

```bash
gcloud run deploy lottocat --source . --platform managed --region asia-southeast1 --allow-unauthenticated --quiet
```