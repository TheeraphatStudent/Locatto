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