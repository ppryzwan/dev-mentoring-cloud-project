from google.cloud import storage, secretmanager


def check_bucket(bucket_name, path):
    client = storage.Client()
    bucket = client.get_bucket(bucket_name)
    if not path.endswith("/"):
        path = path + "/"
    blob = bucket.blob(path)
    if not blob.exists():
        blob.upload_from_string("", content_type="application/json")
        print(f"Path {path} created in bucket {bucket_name}")
    else:
        print(f"Path {path} already exists in bucket {bucket_name}")


def get_secret(secret_id, project_id):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    return response.payload.data.decode("UTF-8")
