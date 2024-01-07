from datetime import datetime


def determine_now(debug_datetime_text):
    try:
        fmt = '%Y-%m-%dT%H:%M:%S'
        now = datetime.strptime(debug_datetime_text, fmt)
    except Exception:
        now = datetime.now()

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
