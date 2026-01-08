import os
import json
import requests
from pathlib import Path
import urllib3

# -----------------------------
# SSL / Certificate handling
# -----------------------------
VERIFY_SSL = False  # Set True if you have valid certificates
if not VERIFY_SSL:
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def safe_post(url, **kwargs):
    return requests.post(url, verify=VERIFY_SSL, **kwargs)

# -----------------------------
# Okta Configuration
# -----------------------------
OKTA_ORG_URL = os.getenv("OKTA_ORG_URL")
OKTA_API_TOKEN = os.getenv("OKTA_API_TOKEN")

if not OKTA_ORG_URL or not OKTA_API_TOKEN:
    raise RuntimeError("Set OKTA_ORG_URL and OKTA_API_TOKEN as environment variables")

HEADERS = {
    "Authorization": f"SSWS {OKTA_API_TOKEN}",
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# -----------------------------
# Local App JSON folders
# -----------------------------
BASE_APPS_DIR = Path("okta-apps")
OIDC_WEB_DIR = BASE_APPS_DIR / "oidc_web"
OIDC_SERVICE_DIR = BASE_APPS_DIR / "oidc_service"
SAML_DIR = BASE_APPS_DIR / "saml"

# -----------------------------
# Helpers
# -----------------------------
def clean_json_for_creation(obj_json):
    """Remove read-only fields from exported JSON to create in Okta"""
    for key in ["id", "href", "created", "lastUpdated", "_links"]:
        obj_json.pop(key, None)
    return obj_json

def create_app_from_json(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            app_json = json.load(f)
    except Exception as e:
        print(f"❌ Failed to read {file_path.name}: {e}")
        return

    app_json = clean_json_for_creation(app_json)

    resp = safe_post(f"{OKTA_ORG_URL}/api/v1/apps", headers=HEADERS, data=json.dumps(app_json))
    if resp.status_code in (200, 201):
        print(f"✔ Created app: {app_json.get('label')}")
    else:
        print(f"❌ Failed to create app {app_json.get('label')}: {resp.status_code} {resp.text}")

def create_apps_in_folder(folder_path):
    if not folder_path.exists():
        print(f"⚠ Folder does not exist: {folder_path}")
        return
    for file_path in folder_path.glob("*.json"):
        create_app_from_json(file_path)

# -----------------------------
# Main
# -----------------------------
def main():
    print("=== Creating OIDC Web Apps ===")
    create_apps_in_folder(OIDC_WEB_DIR)

    print("\n=== Creating OIDC Service Apps ===")
    create_apps_in_folder(OIDC_SERVICE_DIR)

    print("\n=== Creating SAML Apps ===")
    create_apps_in_folder(SAML_DIR)

    print("\n✅ Done creating apps in Okta.")

if __name__ == "__main__":
    main()
