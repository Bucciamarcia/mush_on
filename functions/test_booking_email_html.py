import pathlib
import sys
import unittest


root = pathlib.Path(__file__).resolve().parent
if str(root) not in sys.path:
    sys.path.insert(0, str(root))

from lib.booking_email_html import (  # noqa: E402
    build_booking_other_info_html,
    build_customers_other_info_html,
)


class BookingEmailHtmlTests(unittest.TestCase):
    def test_booking_other_info_uses_configured_order_and_escapes_html(self):
        html = build_booking_other_info_html(
            {
                "otherBookingData": {
                    "Arrival": "<script>alert(1)</script>",
                    "Pickup": "Hotel",
                }
            },
            [{"name": "Pickup"}, {"name": "Arrival"}],
        )

        self.assertLess(html.index("Pickup"), html.index("Arrival"))
        self.assertIn("Hotel", html)
        self.assertIn("&lt;script&gt;alert(1)&lt;/script&gt;", html)
        self.assertNotIn("<script>", html)

    def test_customers_other_info_skips_customers_without_other_info(self):
        html = build_customers_other_info_html(
            [
                {"customerOtherInfo": {}},
                {"customerOtherInfo": {"Diet": "Vegetarian"}},
            ],
            [{"name": "Diet"}],
        )

        self.assertNotIn("Customer 1", html)
        self.assertIn("Customer 2", html)
        self.assertIn("Vegetarian", html)


if __name__ == "__main__":
    unittest.main()
