import json
import sys
import os
import re
import uuid
import datetime

def get_sanitizer(file_path):
    with open(file_path) as file:
        lines = file.readlines()

    sanitizer = ""
    for line in lines:
        if re.findall(r'AFL_USE_[A-Za-z]+=1', line):
            sanitizer = line.replace('=', '_').split('_')[2]

    return sanitizer

def findings(dir_path):
    findings = 0

    for file in os.listdir(dir_path):
        pipe = os.popen(f'file -b {dir_path}/{file}')
        data_type = pipe.read().strip()
        
        if data_type == 'data':
            findings += 1

    return findings

def json_to_file(data_json):
    file_name = "data.json"
    if os.path.exists(file_name):
        with open(file_name, "r") as file:
            try:
                data = json.load(file)
            except json.JSONDecodeError:
                data = []
        data.append(data_json)
        with open(file_name, "w") as file:
            json.dump(data, file)
    else:
        with open(file_name, "w") as file:
            data_json = [data_json]
            json.dump(data_json, file)

if __name__ == "__main__":

    data_source = sys.argv[1]
    path = sys.argv[2]
    conf_comp = sys.argv[3]
    conf_fuzz = sys.argv[4]
    dirs_errs = sys.argv[5]
    description = sys.argv[6]
    name = sys.argv[7]

    analisys_data: dict = {}

    analisys_data["path"] = path
    analisys_data["name"] = name
    analisys_data["conf_fuzzing"] = conf_fuzz
    analisys_data["conf_compilator"] = conf_comp
    analisys_data["web_scrapper"] = data_source
    analisys_data["description"] = description
    analisys_data["dirs_errors"] = dirs_errs
    analisys_data["findings"] = findings(dirs_errs)
    analisys_data["id"] = str(uuid.uuid4())
    analisys_data["date"] = datetime.datetime.now().strftime("%d-%m-%Y %H:%M:%S")

    json_to_file(analisys_data)


