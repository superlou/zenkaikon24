from datetime import datetime
import time
from pytz import utc, timezone


def system_timezone():
    is_dst = time.localtime().tm_isdst
    tzname = time.tzname[is_dst]
    return timezone(tzname)


def determine_now_local(debug_datetime_text, local_tz):
    try:
        # If we can parse the debug datetime, use that as local time.
        fmt = '%Y-%m-%dT%H:%M:%S'
        now = datetime.strptime(debug_datetime_text, fmt)
        return local_tz.localize(now)
    except Exception:
        pass
    
    now = datetime.now()

    if system_timezone() == utc:
        # We are probably on a Raspberry Pi and need to get to local time
        now = utc.localize(now).astimezone(system_timezone())
    else:
        now = system_timezone().localize(now)

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
