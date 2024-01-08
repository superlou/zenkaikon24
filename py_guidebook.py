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