from html import escape
from typing import Any


def build_booking_other_info_html(
    booking_data: dict[str, Any],
    booking_custom_fields: list[dict[str, Any]] | None = None,
) -> str:
    other_data = _string_map(booking_data.get("otherBookingData"))
    rows = _ordered_rows(other_data, booking_custom_fields or [])
    if not rows:
        return ""
    return _details_table(rows)


def build_customers_other_info_html(
    customers: list[dict[str, Any]],
    customer_custom_fields: list[dict[str, Any]] | None = None,
) -> str:
    customer_blocks: list[str] = []
    for index, customer in enumerate(customers, start=1):
        other_data = _string_map(customer.get("customerOtherInfo"))
        rows = _ordered_rows(other_data, customer_custom_fields or [])
        if not rows:
            continue
        customer_blocks.append(
            f"""
            <div style="margin: 0 0 18px 0;">
              <h3 style="margin: 0 0 10px 0; font-size: 16px; color: #111827;">Customer {index}</h3>
              {_details_table(rows)}
            </div>
            """
        )
    if not customer_blocks:
        return ""
    return "".join(customer_blocks)


def _string_map(value: Any) -> dict[str, str]:
    if not isinstance(value, dict):
        return {}
    return {
        str(key): str(item)
        for key, item in value.items()
        if str(key).strip() and str(item).strip()
    }


def _ordered_rows(
    data: dict[str, str],
    configured_fields: list[dict[str, Any]],
) -> list[tuple[str, str]]:
    rows: list[tuple[str, str]] = []
    seen: set[str] = set()
    for field in configured_fields:
        name = str(field.get("name", "")).strip()
        if not name or name not in data:
            continue
        rows.append((name, data[name]))
        seen.add(name)
    for key, value in data.items():
        if key not in seen:
            rows.append((key, value))
    return rows


def _details_table(rows: list[tuple[str, str]]) -> str:
    table_rows = "".join(
        f"""
        <tr>
          <td style="padding: 6px 12px 6px 0; font-size: 14px; color: #6b7280; vertical-align: top;">{escape(label)}</td>
          <td style="padding: 6px 0; font-size: 14px; color: #111827; font-weight: 600; vertical-align: top;">{escape(value)}</td>
        </tr>
        """
        for label, value in rows
    )
    return f"""
    <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0">
      <tbody>{table_rows}</tbody>
    </table>
    """
