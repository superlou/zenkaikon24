import json
from datetime import datetime, timedelta
import time
import traceback
import requests

class Guidebook:
    def __init__(self, api_key):
        self.API_KEY = api_key
    
    def headers(self):
        return {
            "Authorization": "JWT " + self.API_KEY
        }

    def get_json(self, url, params=None):
        response = requests.get(url, params=params, headers=self.headers())
        print(response.url)
        return response.json()

    def get_guides(self):
        URL = "https://builder.guidebook.com/open-api/v1/guides/"
        rsp = self.get_json(URL)
        return rsp
    
    def get_sessions(self, guide_id=None, ordering="start_time"):
        url = "https://builder.guidebook.com/open-api/v1/sessions/"
        params = {
            "guide": guide_id,
            "ordering": ordering,
        }
        
        sessions = []
        response = self.get_json(url, params)
        sessions += response["results"]
        next_url = response["next"]

        while next_url:
            response = self.get_json(next_url)
            sessions += response["results"]
            next_url = response["next"]
        
        return sessions
    
    def get_locations(self, guide_id=None):
        url = "https://builder.guidebook.com/open-api/v1/locations/"
        params = {
            "guide": guide_id
        }

        locations = []
        response = self.get_json(url, params)
        locations += response["results"]
        next_url = response["next"]

        while next_url:
            response = self.get_json(next_url)
            locations += response["results"]
            next_url = response["next"]
        
        return locations


def build_session_list(guidebook, guide_id):
    locations = guidebook.get_locations(guide_id)
    location_map = {location["id"]: location["name"] for location in locations}
    sessions = guidebook.get_sessions(guide_id)
    
    sessions = [{
        "name": session["name"],
        "start": session["start_time"],
        "finish": session["end_time"],
        "locations": [location_map[loc_id] for loc_id in session["locations"]],
    } for session in sessions]

    return sessions


GUIDEBOOK_TIMESTAMP_FMT = "%Y-%m-%dT%H:%M:%S.%f+0000"


def load_sessions_from_file(filename):
    try:
        data = json.load(open(filename))
        return [{
            "start": datetime.strptime(session["start"], GUIDEBOOK_TIMESTAMP_FMT),
            "finish": datetime.strptime(session["finish"], GUIDEBOOK_TIMESTAMP_FMT),
            "name": session["name"],
            "locations": session["locations"],
        } for session in data]
    except Exception:
        traceback.print_exc()
        return []


def update_guidebook_data(node, api_key, guide_id):
    # Make sure there's always some kind of sessions list to work with.
    saved_sessions_list = load_sessions_from_file("data_sessions.json")

    # Attempt to get data from Guidebook, and fall back to saved data
    # if not successful.
    try:
        guidebook = Guidebook(api_key)
        sessions_list = build_session_list(guidebook, guide_id)
    except Exception:
        node.send_json("guidebook/update", {
            "success": False,
            "updated": False,
            "msg": "Failed to retrieve Guidebook data",
        })
        print("Failed to retrieve Guidebook data")
        return saved_sessions_list

    # If no data has changed, return early.
    if sessions_list == saved_sessions_list:
        node.send_json("guidebook/update", {
            "success": True,
            "updated": False,
            "msg": "Guidebook data unchanged",
        })
        print("Guidebook data unchanged")
        return saved_sessions_list

    # Otherwise, persist the data, and reload it so everything
    # is formatted properly.
    with open("data_sessions.json", "w") as f:
        json.dump(sessions_list, f)

    sessions_list = load_sessions_from_file("data_sessions.json")
    node.send_json("guidebook/update", {
        "success": True,
        "updated": True,
        "msg": "Guidebook data updated",
    })
    print("Guidebook data updated")
    return sessions_list


def save_sessions_for_topic_list(sessions, filename):
    session_data = [{
        "start_hhmm": datetime.strftime(session["start"], "%I:%M").lstrip("0"),
        "start_ampm": datetime.strftime(session["start"], "%P"),
        "name": session["name"],
        "locations": session["locations"],        
    } for session in sessions]

    with open(filename, "w") as f:
        json.dump(session_data, f)


def write_sessions_now(sessions, now, max_duration=timedelta(hours=3.5)):
    sessions_now = [
        s for s in sessions
        if now >= s["start"] and now <= s["finish"] and (s["finish"] - s["start"]) < max_duration
    ]

    save_sessions_for_topic_list(sessions_now, "data_sessions_now.json")


def write_sessions_soon(sessions, now, max_duration=timedelta(hours=3.5)):
    def is_soon(now, start, finish):
        return start > (now + timedelta(hours=1)) and start < (now + timedelta(hours=2))

    sessions_soon = [
        s for s in sessions
        if is_soon(now, s["start"], s["finish"]) and (s["finish"] - s["start"]) < max_duration
    ]

    save_sessions_for_topic_list(sessions_soon, "data_sessions_soon.json")