from bs4 import BeautifulSoup
import requests
import os

class ObdPidScrapper:
    def __init__(self, base_url: str, mod_url: list[str]) -> None:
        self = self
        self.base_url = base_url
        self.mod_url = mod_url

    def web_scrapping(self) -> list[str]:
        pids = []

        for modifier in self.mod_url:
            request = requests.get(self.base_url + modifier).content
            soup = BeautifulSoup(request, 'html.parser')

            tabla = soup.find('table')

            for row in tabla.findAll('tr')[1:(-1) if modifier == "05" or modifier == "09" else None]:
                pid = row.findAll('td')[0].text
                pids.append(pid.replace('\n', ''))

        return pids
    
    def pids_fuzzer(self, path: str, pids: list[str]) -> None:
        _path_inputs = path + "/inputs"
        
        if not os.path.exists(_path_inputs):
            os.mkdir(_path_inputs)

        for pid in pids:
            try:
                with open(_path_inputs + "/" + pid + ".txt", "w+") as file:
                    file.write(pid)
            except Exception as e:
                print(f"Error creating file for PID '{pid}': {e}")


_modes = ["01", "02", "05", "09"]
_base_url = "https://es.wikibooks.org/wiki/El_OBDII_Completo/Los_PIDs/PID_Modo_"

if __name__ == "__main__":
    web_scrapper = ObdPidScrapper(_base_url, _modes)

    pids = web_scrapper.web_scrapping()
    web_scrapper.pids_fuzzer(os.getcwd(), pids)