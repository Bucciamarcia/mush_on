import os


class SendInvitationEmail:
    def __init__(self, sender_email: str, receiver_email: str, account: str):
        self.sender_email = sender_email
        self.receiver_email = receiver_email
        self.account = account
        self.postmark_server_token = (os.getenv("POSTMARK_SERVER_TOKEN"),)
        self.postmark_account_token = (os.getenv("POSTMARK_ACCOUNT_TOKEN"),)
        self.postmark_template_id = (os.getenv("POSTMARK_TEMPLATE_INVITE_USER"),)
        self.privacy_policy_url = os.getenv("PRIVACY_POLICY_URL")
        self.signup_url = os.getenv("SIGNUP_URL")
        self.support_email = os.getenv("SUPPORT_EMAIL")
        if (
            self.postmark_template_id is None
            or self.postmark_account_token is None
            or self.postmark_server_token is None
            or self.privacy_policy_url is None
            or self.signup_url is None
            or self.support_email is None
        ):
            raise ValueError(
                "Postmark configuration is missing in environment variables."
            )

    def run(self) -> None:
        url = "https://api.postmarkapp.com/email/withTemplate"
        template_model = {
            "product_url": self.signup_url,
            "product_name": "Mush on",
            "email": self.receiver_email,
            "invite_sender_email": self.sender_email,
            "action_url": self.signup_url,
            "support_email": self,
            "privacy_policy_url": self.privacy_policy_url,
        }
