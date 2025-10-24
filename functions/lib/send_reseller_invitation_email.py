import os
import requests


class SendResellerInvitationEmail:
    def __init__(self, email: str, security_code: str, sender_email: str):
        self.receiver_email = email
        self.sender_email = sender_email
        self.postmark_server_token = os.getenv("POSTMARK_SERVER_TOKEN")
        self.postmark_account_token = os.getenv("POSTMARK_ACCOUNT_TOKEN")
        self.postmark_template_id = os.getenv("POSTMARK_TEMPLATE_INVITE_RESELLER")
        self.privacy_policy_url = os.getenv("PRIVACY_POLICY_URL")
        self.base_signup_url = os.getenv("SIGNUP_URL_RESELLER")
        self.support_email = os.getenv("SUPPORT_EMAIL")
        self.security_code = security_code
        if (
            self.postmark_template_id is None
            or self.postmark_account_token is None
            or self.postmark_server_token is None
            or self.privacy_policy_url is None
            or self.base_signup_url is None
            or self.support_email is None
        ):
            raise ValueError("Some of the env variables are None")

    def run(self):
        url = "https://api.postmarkapp.com/email/withTemplate"
        action_url = f"{self.base_signup_url}?email={self.receiver_email}&securityCode={self.security_code}"
        template_model = {
            "product_url": "https://mush-on.com",
            "product_name": "Mush on",
            "email": self.receiver_email,
            "invite_sender_email": self.sender_email,
            "action_url": action_url,
            "support_email": self.support_email,
            "privacy_policy_url": self.privacy_policy_url,
        }
        body = {
            "TemplateId": self.postmark_template_id,
            "TemplateModel": template_model,
            "From": "Mush On <newaccounts@mush-on.com>",
            "To": self.receiver_email,
            "ReplyTo": self.sender_email,
        }
        header = {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "X-Postmark-Server-Token": self.postmark_server_token,
        }
        try:
            response = requests.post(url, headers=header, json=body)
            response.raise_for_status()
        except requests.exceptions.HTTPError as e:
            if response.status_code == 422:
                print(f"Postmark API error (422): {response.json()}")
            else:
                print(f"HTTP error sending email via Postmark: {e}")
                print(f"Response body: {response.text}")
            raise e
        except Exception as e:
            print(f"Error sending email via Postmark: {e}")
            raise e
