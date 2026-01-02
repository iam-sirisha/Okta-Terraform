import json
import os
import re

INPUT_DIR = "input_json"

OAUTH_TFVARS = "tfvars/oauth_apps.tfvars"
SAML_TFVARS = "tfvars/saml_apps.tfvars"


def load_existing_tfvars(tfvars_file):
    if not os.path.exists(tfvars_file):
        return {}

    with open(tfvars_file, "r") as f:
        content = f.read()

    apps = {}
    blocks = re.findall(r'(\w+)\s*=\s*{([^}]*)}', content, re.DOTALL)
    for name, body in blocks:
        apps[name] = body.strip()
    return apps


def sanitize_name(label):
    return label.lower().replace(" ", "_").replace("-", "_")


# ---------- OAUTH ----------
def parse_oauth_json(data):
    oauth = data["settings"]["oauthClient"]

    return {
        "label": data["label"],
        "application_type": oauth["application_type"],
        "grant_types": oauth["grant_types"],
        "response_types": oauth["response_types"],
        "redirect_uris_prod": oauth["redirect_uris"],
        "post_logout_redirect_uris": oauth.get("post_logout_redirect_uris", []),
        "consent_method": oauth["consent_method"],
        "issuer_mode": oauth["issuer_mode"],
        "refresh_token_rotation": oauth["refresh_token"]["rotation_type"]
    }


# ---------- SAML ----------
def parse_saml_json(data):
    saml = data["settings"]["signOn"]

    return {
        "label": data["label"],
        "sso_acs_url": saml["ssoAcsUrl"],
        "audience": saml["audience"],
        "recipient": saml["recipient"],
        "destination": saml["destination"],
        "nameid_format": saml["subjectNameIdFormat"],
        "response_signed": saml["responseSigned"],
        "assertion_signed": saml["assertionSigned"],
        "signature_algorithm": saml["signatureAlgorithm"],
        "digest_algorithm": saml["digestAlgorithm"],
        "attribute_statements": saml.get("attributeStatements", [])
    }


def format_tfvars_block(app_name, values):
    lines = [f"  {app_name} = {{"]

    for k, v in values.items():
        if isinstance(v, list):
            lines.append(f"    {k} = {json.dumps(v)}")
        elif isinstance(v, bool):
            lines.append(f"    {k} = {str(v).lower()}")
        else:
            lines.append(f'    {k} = "{v}"')

    lines.append("  }")
    return "\n".join(lines)


def main():
    oauth_existing = load_existing_tfvars(OAUTH_TFVARS)
    saml_existing = load_existing_tfvars(SAML_TFVARS)

    oauth_blocks = []
    saml_blocks = []

    for file in os.listdir(INPUT_DIR):
        if not file.endswith(".json"):
            continue

        json_path = os.path.join(INPUT_DIR, file)
        with open(json_path, "r") as f:
            data = json.load(f)

        label = data["label"]
        app_key = sanitize_name(label)

        # ---------- OAUTH ----------
        if "oauthClient" in data.get("settings", {}):
            if app_key in oauth_existing:
                print(f"Skipping existing OAuth app: {app_key}")
                continue

            values = parse_oauth_json(data)
            oauth_blocks.append(format_tfvars_block(app_key, values))
            print(f"Added OAuth app: {app_key}")

        # ---------- SAML ----------
        elif data.get("signOnMode") == "SAML_2_0":
            if app_key in saml_existing:
                print(f"Skipping existing SAML app: {app_key}")
                continue

            values = parse_saml_json(data)
            saml_blocks.append(format_tfvars_block(app_key, values))
            print(f"Added SAML app: {app_key}")

        else:
            print(f"Unknown app type: {file}")

    if oauth_blocks:
        with open(OAUTH_TFVARS, "a") as f:
            f.write("\n\n" + "\n".join(oauth_blocks))

    if saml_blocks:
        with open(SAML_TFVARS, "a") as f:
            f.write("\n\n" + "\n".join(saml_blocks))


if __name__ == "__main__":
    main()
