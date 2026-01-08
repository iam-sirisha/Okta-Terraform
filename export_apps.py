import os
import json
import requests
from pathlib import Path

# -----------------------------
# Configuration
# -----------------------------
BASE_EXPORT_PATH = Path("C:/Users/Downloads/Okta Automation")  # root folder is 'apps'

OKTA_ORG_URL = os.getenv("OKTA_ORG_URL")
OKTA_API_TOKEN = os.getenv("OKTA_API_TOKEN")

if not OKTA_ORG_URL or not OKTA_API_TOKEN:
    raise RuntimeError("Set OKTA_ORG_URL and OKTA_API_TOKEN as environment variables")

HEADERS = {
    "Authorization": f"SSWS {OKTA_API_TOKEN}",
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# Oauth and SAML folders
OAUTH_WEB_DIR = BASE_EXPORT_PATH / "Oauth" / "web"
OAUTH_SERVICE_DIR = BASE_EXPORT_PATH / "Oauth" / "service"
SAML_DIR = BASE_EXPORT_PATH / "SAML"

# -----------------------------
# Helper functions
# -----------------------------
def safe_filename(name):
    """Make a safe filename from app label"""
    return "".join(c if c.isalnum() or c in ("-", "_") else "_" for c in name.strip())

def create_directories():
    """Create required folder structure"""
    OAUTH_WEB_DIR.mkdir(parents=True, exist_ok=True)
    OAUTH_SERVICE_DIR.mkdir(parents=True, exist_ok=True)
    SAML_DIR.mkdir(parents=True, exist_ok=True)

def get_all_active_apps():
    """Fetch all active apps using pagination"""
    apps = []
    url = f"{OKTA_ORG_URL}/api/v1/apps?limit=200"

    while url:
        resp = requests.get(url, headers=HEADERS)
        resp.raise_for_status()
        apps.extend(resp.json())
        # Pagination
        links = resp.headers.get("Link", "")
        next_link = None
        for link in links.split(","):
            if 'rel="next"' in link:
                next_link = link[link.find("<") + 1 : link.find(">")]
                break
        url = next_link

    # Filter active apps only
    active_apps = [app for app in apps if app.get("status") == "ACTIVE"]
    return active_apps

def classify_app_folder(app):
    """Return folder path based on app type"""
    sign_on_mode = app.get("signOnMode")
    if sign_on_mode == "OPENID_CONNECT":
        app_type = app.get("settings", {}).get("oauthClient", {}).get("application_type")
        if app_type == "web":
            return OAUTH_WEB_DIR
        elif app_type == "service":
            return OAUTH_SERVICE_DIR
    elif sign_on_mode == "SAML_2_0":
        return SAML_DIR
    return None  # skip other types

# -----------------------------
# Export applications
# -----------------------------
def export_active_apps():
    create_directories()
    apps = get_all_active_apps()
    print(f"Total active apps: {len(apps)}")

    for app in apps:
        folder = classify_app_folder(app)
        if not folder:
            continue  # skip unknown app types

        app_label = safe_filename(app["label"])
        file_path = folder / f"{app_label}_config.json"

        # Fetch full app details
        full_app = requests.get(f"{OKTA_ORG_URL}/api/v1/apps/{app['id']}", headers=HEADERS).json()

        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(full_app, f, indent=2)

        print(f"✔ Exported: {app['label']}")

# -----------------------------
# Main
# -----------------------------
if __name__ == "__main__":
    export_active_apps()
    print("✅ Okta active applications exported successfully!")
