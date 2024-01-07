import requests

class Guidebook:
    def __init__(self, api_key):
        self.API_KEY = api_key
    
    def headers(self):
        return {
            "Authorization": "JWT " + self.API_KEY
        }

    def get_json(self, url):
        return requests.get(url, headers=self.headers()).json()

    def get_guides(self):
        URL = "https://builder.guidebook.com/open-api/v1/guides/"
        rsp = self.get_json(URL)
        return rsp
    
    def get_sessions(self, guide_id=None):
        url = "https://builder.guidebook.com/open-api/v1/sessions/"
        if guide_id is not None:
            url += "?guide=" + guide_id        
        
        next_url = url
        sessions = []

        while next_url:
            print(next_url)
            response = self.get_json(next_url)
            sessions += response["results"]
            next_url = response["next"]
        
        return sessions
    
    def get_locations(self, guide_id=None):
        url = "https://builder.guidebook.com/open-api/v1/locations/"
        if guide_id is not None:
            url += "?guide=" + guide_id
        
        next_url = url
        locations = []

        while next_url:
            print(next_url)
            response = self.get_json(next_url)
            locations += response["results"]
            next_url = response["next"]
        
        return locations            