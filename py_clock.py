from datetime import datetime
import time
import pytz


def determine_now(debug_datetime_text, timezone):
    try:
        # If we can parse the debug datetime, use that as local time.
        fmt = '%Y-%m-%dT%H:%M:%S'
        now = datetime.strptime(debug_datetime_text, fmt)
        return now
    except Exception:
        pass
    
    is_dst = time.localtime().tm_isdst
    tzname = time.tzname[is_dst]

    now = datetime.now()

    if tzname == "UTC":
        # We are probably on a Raspberry Pi and need to convert to local time.
        now = pytz.utc.localize(now).astimezone(timezone)

    return now


def update_time(node, now):
    time_hhmm = now.strftime("%I:%M")
    time_am_pm = now.strftime("%p")

    # Used for compatiblity since "%-I" doesn't work on all systems
    if time_hhmm[0] == "0":
        time_hhmm = time_hhmm[1:]

    node.send_json("/clock/update", {
        "hh_mm": time_hhmm,
        "am_pm": time_am_pm,
    })
